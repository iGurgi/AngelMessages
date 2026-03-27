const express = require('express');
const { body, validationResult, param } = require('express-validator');
const Message = require('../models/Message');
const auth = require('../middleware/auth');
const adminAuth = require('../middleware/adminAuth');

const router = express.Router();

// Apply authentication and admin authorization to all admin routes
router.use(auth);
router.use(adminAuth);

// GET /admin/messages - List all messages with pagination
router.get('/messages', async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 50;
    const offset = (page - 1) * limit;

    // Build filter conditions
    const where = {};
    if (req.query.category) {
      where.category = req.query.category;
    }
    if (req.query.is_active !== undefined) {
      where.is_active = req.query.is_active === 'true';
    }
    if (req.query.search) {
      where[Op.or] = [
        { title: { [Op.iLike]: `%${req.query.search}%` } },
        { content: { [Op.iLike]: `%${req.query.search}%` } }
      ];
    }

    const { count, rows: messages } = await Message.findAndCountAll({
      where,
      limit,
      offset,
      order: [['created_at', 'DESC']],
      attributes: ['id', 'title', 'content', 'category', 'is_active', 'created_at', 'updated_at']
    });

    const totalPages = Math.ceil(count / limit);

    res.json({
      success: true,
      data: {
        messages,
        pagination: {
          current_page: page,
          total_pages: totalPages,
          total_count: count,
          per_page: limit,
          has_next: page < totalPages,
          has_previous: page > 1
        }
      }
    });
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch messages'
    });
  }
});

// POST /admin/messages - Create new message
router.post('/messages', [
  body('title')
    .trim()
    .isLength({ min: 1, max: 200 })
    .withMessage('Title must be between 1 and 200 characters'),
  body('content')
    .trim()
    .isLength({ min: 1, max: 2000 })
    .withMessage('Content must be between 1 and 2000 characters'),
  body('category')
    .isIn(['love', 'guidance', 'healing', 'protection', 'abundance', 'general'])
    .withMessage('Invalid category'),
  body('is_active')
    .optional()
    .isBoolean()
    .withMessage('is_active must be a boolean')
], async (req, res) => {
  try {
    // Check validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        error: 'Validation failed',
        details: errors.array()
      });
    }

    const { title, content, category, is_active = true } = req.body;

    // Create new message
    const message = await Message.create({
      title: title.trim(),
      content: content.trim(),
      category,
      is_active,
      created_by: req.user.id
    });

    res.status(201).json({
      success: true,
      data: {
        message: {
          id: message.id,
          title: message.title,
          content: message.content,
          category: message.category,
          is_active: message.is_active,
          created_at: message.created_at,
          updated_at: message.updated_at
        }
      },
      message: 'Message created successfully'
    });
  } catch (error) {
    console.error('Error creating message:', error);
    
    // Handle unique constraint violations
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(409).json({
        success: false,
        error: 'Message with similar content already exists'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Failed to create message'
    });
  }
});

// PUT /admin/messages/:id - Update existing message
router.put('/messages/:id', [
  param('id')
    .isInt({ gt: 0 })
    .withMessage('Message ID must be a positive integer'),
  body('title')
    .optional()
    .trim()
    .isLength({ min: 1, max: 200 })
    .withMessage('Title must be between 1 and 200 characters'),
  body('content')
    .optional()
    .trim()
    .isLength({ min: 1, max: 2000 })
    .withMessage('Content must be between 1 and 2000 characters'),
  body('category')
    .optional()
    .isIn(['love', 'guidance', 'healing', 'protection', 'abundance', 'general'])
    .withMessage('Invalid category'),
  body('is_active')
    .optional()
    .isBoolean()
    .withMessage('is_active must be a boolean')
], async (req, res) => {
  try {
    // Check validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        error: 'Validation failed',
        details: errors.array()
      });
    }

    const messageId = req.params.id;
    const updateData = {};

    // Build update data from request body
    if (req.body.title !== undefined) {
      updateData.title = req.body.title.trim();
    }
    if (req.body.content !== undefined) {
      updateData.content = req.body.content.trim();
    }
    if (req.body.category !== undefined) {
      updateData.category = req.body.category;
    }
    if (req.body.is_active !== undefined) {
      updateData.is_active = req.body.is_active;
    }

    // Check if message exists
    const message = await Message.findByPk(messageId);
    if (!message) {
      return res.status(404).json({
        success: false,
        error: 'Message not found'
      });
    }

    // Update message
    await message.update(updateData);

    res.json({
      success: true,
      data: {
        message: {
          id: message.id,
          title: message.title,
          content: message.content,
          category: message.category,
          is_active: message.is_active,
          created_at: message.created_at,
          updated_at: message.updated_at
        }
      },
      message: 'Message updated successfully'
    });
  } catch (error) {
    console.error('Error updating message:', error);
    
    // Handle unique constraint violations
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(409).json({
        success: false,
        error: 'Message with similar content already exists'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Failed to update message'
    });
  }
});

// DELETE /admin/messages/:id - Delete message
router.delete('/messages/:id', [
  param('id')
    .isInt({ gt: 0 })
    .withMessage('Message ID must be a positive integer')
], async (req, res) => {
  try {
    // Check validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        error: 'Validation failed',
        details: errors.array()
      });
    }

    const messageId = req.params.id;

    // Check if message exists
    const message = await Message.findByPk(messageId);
    if (!message) {
      return res.status(404).json({
        success: false,
        error: 'Message not found'
      });
    }

    // Soft delete by setting is_active to false instead of hard delete
    // This preserves data integrity and allows for recovery
    await message.update({ is_active: false });

    res.json({
      success: true,
      message: 'Message deactivated successfully'
    });
  } catch (error) {
    console.error('Error deleting message:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete message'
    });
  }
});

// GET /admin/messages/:id - Get single message details
router.get('/messages/:id', [
  param('id')
    .isInt({ gt: 0 })
    .withMessage('Message ID must be a positive integer')
], async (req, res) => {
  try {
    // Check validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        error: 'Validation failed',
        details: errors.array()
      });
    }

    const messageId = req.params.id;

    const message = await Message.findByPk(messageId, {
      attributes: ['id', 'title', 'content', 'category', 'is_active', 'created_at', 'updated_at']
    });

    if (!message) {
      return res.status(404).json({
        success: false,
        error: 'Message not found'
      });
    }

    res.json({
      success: true,
      data: {
        message: {
          id: message.id,
          title: message.title,
          content: message.content,
          category: message.category,
          is_active: message.is_active,
          created_at: message.created_at,
          updated_at: message.updated_at
        }
      }
    });
  } catch (error) {
    console.error('Error fetching message:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch message'
    });
  }
});

module.exports = router;