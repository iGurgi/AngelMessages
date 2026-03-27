/**
 * Message model for Angel Messages application
 * Represents a daily inspirational message with validation
 */

class Message {
  // Category enum for message classification
  static CATEGORIES = {
    LOVE: 'love',
    GUIDANCE: 'guidance',
    PROTECTION: 'protection',
    HEALING: 'healing',
    ABUNDANCE: 'abundance',
    SPIRITUAL_GROWTH: 'spiritual_growth',
    COMFORT: 'comfort',
    ENCOURAGEMENT: 'encouragement'
  };

  // Validation constants
  static VALIDATION = {
    TITLE_MIN_LENGTH: 3,
    TITLE_MAX_LENGTH: 100,
    CONTENT_MIN_LENGTH: 10,
    CONTENT_MAX_LENGTH: 500
  };

  constructor({ id, title, content, category, createdAt = new Date() }) {
    this.id = id;
    this.title = title;
    this.content = content;
    this.category = category;
    this.createdAt = createdAt instanceof Date ? createdAt : new Date(createdAt);
    
    // Validate on construction
    this.validate();
  }

  /**
   * Validates all message properties
   * @throws {Error} If validation fails
   */
  validate() {
    const errors = [];

    // Validate ID
    if (!this.id || typeof this.id !== 'string') {
      errors.push('ID is required and must be a string');
    }

    // Validate title
    const titleValidation = this.validateTitle(this.title);
    if (!titleValidation.isValid) {
      errors.push(...titleValidation.errors);
    }

    // Validate content
    const contentValidation = this.validateContent(this.content);
    if (!contentValidation.isValid) {
      errors.push(...contentValidation.errors);
    }

    // Validate category
    const categoryValidation = this.validateCategory(this.category);
    if (!categoryValidation.isValid) {
      errors.push(...categoryValidation.errors);
    }

    // Validate createdAt
    if (!(this.createdAt instanceof Date) || isNaN(this.createdAt.getTime())) {
      errors.push('createdAt must be a valid Date');
    }

    if (errors.length > 0) {
      throw new Error(`Message validation failed: ${errors.join(', ')}`);
    }
  }

  /**
   * Validates message title
   * @param {string} title - The title to validate
   * @returns {Object} Validation result with isValid boolean and errors array
   */
  validateTitle(title) {
    const errors = [];

    if (!title || typeof title !== 'string') {
      errors.push('Title is required and must be a string');
    } else {
      const trimmedTitle = title.trim();
      
      if (trimmedTitle.length < Message.VALIDATION.TITLE_MIN_LENGTH) {
        errors.push(`Title must be at least ${Message.VALIDATION.TITLE_MIN_LENGTH} characters long`);
      }
      
      if (trimmedTitle.length > Message.VALIDATION.TITLE_MAX_LENGTH) {
        errors.push(`Title must not exceed ${Message.VALIDATION.TITLE_MAX_LENGTH} characters`);
      }
      
      // Check for only whitespace
      if (trimmedTitle.length === 0) {
        errors.push('Title cannot be empty or contain only whitespace');
      }
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Validates message content
   * @param {string} content - The content to validate
   * @returns {Object} Validation result with isValid boolean and errors array
   */
  validateContent(content) {
    const errors = [];

    if (!content || typeof content !== 'string') {
      errors.push('Content is required and must be a string');
    } else {
      const trimmedContent = content.trim();
      
      if (trimmedContent.length < Message.VALIDATION.CONTENT_MIN_LENGTH) {
        errors.push(`Content must be at least ${Message.VALIDATION.CONTENT_MIN_LENGTH} characters long`);
      }
      
      if (trimmedContent.length > Message.VALIDATION.CONTENT_MAX_LENGTH) {
        errors.push(`Content must not exceed ${Message.VALIDATION.CONTENT_MAX_LENGTH} characters`);
      }
      
      // Check for only whitespace
      if (trimmedContent.length === 0) {
        errors.push('Content cannot be empty or contain only whitespace');
      }
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Validates message category
   * @param {string} category - The category to validate
   * @returns {Object} Validation result with isValid boolean and errors array
   */
  validateCategory(category) {
    const errors = [];
    const validCategories = Object.values(Message.CATEGORIES);

    if (!category || typeof category !== 'string') {
      errors.push('Category is required and must be a string');
    } else if (!validCategories.includes(category)) {
      errors.push(`Category must be one of: ${validCategories.join(', ')}`);
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Sanitizes input text by trimming whitespace and removing dangerous characters
   * @param {string} text - Text to sanitize
   * @returns {string} Sanitized text
   */
  static sanitizeText(text) {
    if (typeof text !== 'string') {
      return '';
    }

    return text
      .trim()
      .replace(/[<>"'&]/g, '') // Remove potentially dangerous characters
      .replace(/\s+/g, ' '); // Replace multiple whitespace with single space
  }

  /**
   * Creates a Message instance from raw data with sanitization
   * @param {Object} data - Raw message data
   * @returns {Message} New Message instance
   */
  static fromRawData(data) {
    const sanitizedData = {
      id: data.id,
      title: Message.sanitizeText(data.title),
      content: Message.sanitizeText(data.content),
      category: typeof data.category === 'string' ? data.category.toLowerCase() : '',
      createdAt: data.createdAt || new Date()
    };

    return new Message(sanitizedData);
  }

  /**
   * Converts message to JSON object
   * @returns {Object} JSON representation of the message
   */
  toJSON() {
    return {
      id: this.id,
      title: this.title,
      content: this.content,
      category: this.category,
      createdAt: this.createdAt.toISOString()
    };
  }

  /**
   * Gets all valid categories
   * @returns {Array<string>} Array of valid category values
   */
  static getValidCategories() {
    return Object.values(Message.CATEGORIES);
  }

  /**
   * Checks if a category is valid
   * @param {string} category - Category to check
   * @returns {boolean} True if category is valid
   */
  static isValidCategory(category) {
    return Object.values(Message.CATEGORIES).includes(category);
  }
}

module.exports = Message;