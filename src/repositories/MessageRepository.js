const pool = require('../config/database');
const { DatabaseError } = require('../utils/errors');

class MessageRepository {
  constructor() {
    this.pool = pool;
  }

  /**
   * Get all active messages
   * @returns {Promise<Array>} Array of active messages
   */
  async getAllActive() {
    const query = `
      SELECT 
        id,
        title,
        content,
        category,
        author,
        tags,
        priority,
        created_at,
        updated_at
      FROM messages 
      WHERE is_active = true 
        AND deleted_at IS NULL
      ORDER BY priority DESC, created_at DESC
    `;

    try {
      const [rows] = await this.pool.execute(query);
      return rows.map(row => ({
        ...row,
        tags: row.tags ? JSON.parse(row.tags) : []
      }));
    } catch (error) {
      throw new DatabaseError(`Failed to fetch active messages: ${error.message}`);
    }
  }

  /**
   * Get messages by category
   * @param {string} category - Message category to filter by
   * @returns {Promise<Array>} Array of messages in the specified category
   */
  async getByCategory(category) {
    const query = `
      SELECT 
        id,
        title,
        content,
        category,
        author,
        tags,
        priority,
        created_at,
        updated_at
      FROM messages 
      WHERE category = ? 
        AND is_active = true 
        AND deleted_at IS NULL
      ORDER BY priority DESC, created_at DESC
    `;

    try {
      const [rows] = await this.pool.execute(query, [category]);
      return rows.map(row => ({
        ...row,
        tags: row.tags ? JSON.parse(row.tags) : []
      }));
    } catch (error) {
      throw new DatabaseError(`Failed to fetch messages by category '${category}': ${error.message}`);
    }
  }

  /**
   * Create a new message
   * @param {Object} messageData - Message data to create
   * @param {string} messageData.title - Message title
   * @param {string} messageData.content - Message content
   * @param {string} messageData.category - Message category
   * @param {string} messageData.author - Message author
   * @param {Array} [messageData.tags] - Optional tags array
   * @param {number} [messageData.priority] - Message priority (default: 1)
   * @returns {Promise<Object>} Created message with ID
   */
  async create(messageData) {
    const {
      title,
      content,
      category,
      author,
      tags = [],
      priority = 1
    } = messageData;

    if (!title || !content || !category || !author) {
      throw new Error('Missing required fields: title, content, category, author');
    }

    const query = `
      INSERT INTO messages (
        title,
        content,
        category,
        author,
        tags,
        priority,
        is_active,
        created_at,
        updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, true, NOW(), NOW())
    `;

    try {
      const [result] = await this.pool.execute(query, [
        title,
        content,
        category,
        author,
        JSON.stringify(tags),
        priority
      ]);

      // Fetch the created message
      const selectQuery = `
        SELECT 
          id,
          title,
          content,
          category,
          author,
          tags,
          priority,
          is_active,
          created_at,
          updated_at
        FROM messages 
        WHERE id = ?
      `;

      const [rows] = await this.pool.execute(selectQuery, [result.insertId]);
      const createdMessage = rows[0];
      
      return {
        ...createdMessage,
        tags: createdMessage.tags ? JSON.parse(createdMessage.tags) : []
      };
    } catch (error) {
      throw new DatabaseError(`Failed to create message: ${error.message}`);
    }
  }

  /**
   * Update an existing message
   * @param {number} id - Message ID to update
   * @param {Object} data - Data to update
   * @returns {Promise<Object>} Updated message
   */
  async update(id, data) {
    if (!id) {
      throw new Error('Message ID is required');
    }

    // Check if message exists
    const checkQuery = 'SELECT id FROM messages WHERE id = ? AND deleted_at IS NULL';
    const [existingRows] = await this.pool.execute(checkQuery, [id]);
    
    if (existingRows.length === 0) {
      throw new Error(`Message with ID ${id} not found`);
    }

    // Build dynamic update query
    const updateFields = [];
    const values = [];

    const allowedFields = ['title', 'content', 'category', 'author', 'tags', 'priority', 'is_active'];
    
    for (const [key, value] of Object.entries(data)) {
      if (allowedFields.includes(key) && value !== undefined) {
        updateFields.push(`${key} = ?`);
        values.push(key === 'tags' ? JSON.stringify(value) : value);
      }
    }

    if (updateFields.length === 0) {
      throw new Error('No valid fields to update');
    }

    updateFields.push('updated_at = NOW()');
    values.push(id);

    const query = `
      UPDATE messages 
      SET ${updateFields.join(', ')}
      WHERE id = ?
    `;

    try {
      await this.pool.execute(query, values);

      // Fetch the updated message
      const selectQuery = `
        SELECT 
          id,
          title,
          content,
          category,
          author,
          tags,
          priority,
          is_active,
          created_at,
          updated_at
        FROM messages 
        WHERE id = ?
      `;

      const [rows] = await this.pool.execute(selectQuery, [id]);
      const updatedMessage = rows[0];
      
      return {
        ...updatedMessage,
        tags: updatedMessage.tags ? JSON.parse(updatedMessage.tags) : []
      };
    } catch (error) {
      throw new DatabaseError(`Failed to update message: ${error.message}`);
    }
  }

  /**
   * Soft delete a message
   * @param {number} id - Message ID to delete
   * @returns {Promise<boolean>} Success status
   */
  async delete(id) {
    if (!id) {
      throw new Error('Message ID is required');
    }

    // Check if message exists
    const checkQuery = 'SELECT id FROM messages WHERE id = ? AND deleted_at IS NULL';
    const [existingRows] = await this.pool.execute(checkQuery, [id]);
    
    if (existingRows.length === 0) {
      throw new Error(`Message with ID ${id} not found`);
    }

    const query = `
      UPDATE messages 
      SET deleted_at = NOW(), is_active = false, updated_at = NOW()
      WHERE id = ?
    `;

    try {
      const [result] = await this.pool.execute(query, [id]);
      return result.affectedRows > 0;
    } catch (error) {
      throw new DatabaseError(`Failed to delete message: ${error.message}`);
    }
  }

  /**
   * Get a single message by ID
   * @param {number} id - Message ID
   * @returns {Promise<Object|null>} Message or null if not found
   */
  async getById(id) {
    const query = `
      SELECT 
        id,
        title,
        content,
        category,
        author,
        tags,
        priority,
        is_active,
        created_at,
        updated_at
      FROM messages 
      WHERE id = ? AND deleted_at IS NULL
    `;

    try {
      const [rows] = await this.pool.execute(query, [id]);
      if (rows.length === 0) {
        return null;
      }
      
      const message = rows[0];
      return {
        ...message,
        tags: message.tags ? JSON.parse(message.tags) : []
      };
    } catch (error) {
      throw new DatabaseError(`Failed to fetch message by ID: ${error.message}`);
    }
  }

  /**
   * Get random message from a category (for daily message feature)
   * @param {string} category - Message category
   * @returns {Promise<Object|null>} Random message or null if none found
   */
  async getRandomByCategory(category) {
    const query = `
      SELECT 
        id,
        title,
        content,
        category,
        author,
        tags,
        priority,
        created_at,
        updated_at
      FROM messages 
      WHERE category = ? 
        AND is_active = true 
        AND deleted_at IS NULL
      ORDER BY RAND() 
      LIMIT 1
    `;

    try {
      const [rows] = await this.pool.execute(query, [category]);
      if (rows.length === 0) {
        return null;
      }
      
      const message = rows[0];
      return {
        ...message,
        tags: message.tags ? JSON.parse(message.tags) : []
      };
    } catch (error) {
      throw new DatabaseError(`Failed to fetch random message: ${error.message}`);
    }
  }
}

module.exports = MessageRepository;