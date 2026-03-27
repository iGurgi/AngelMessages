const Message = require('../../models/Message');
const { validationResult } = require('express-validator');
const logger = require('../../utils/logger');

class MessageAdminController {
  /**
   * List all messages with pagination and filtering
   * GET /api/admin/messages
   */
  async list(req, res) {
    try {
      const {
        page = 1,
        limit = 20,
        status,
        category,
        search,
        sortBy = 'createdAt',
        sortOrder = 'desc'
      } = req.query;

      const offset = (parseInt(page) - 1) * parseInt(limit);
      const filters = {};

      // Apply filters
      if (status) filters.status = status;
      if (category) filters.category = category;
      if (search) {
        filters.$or = [
          { content: { $regex: search, $options: 'i' } },
          { category: { $regex: search, $options: 'i' } }
        ];
      }

      // Build sort object
      const sortObj = {};
      sortObj[sortBy] = sortOrder === 'desc' ? -1 : 1;

      const [messages, total] = await Promise.all([
        Message.find(filters)
          .sort(sortObj)
          .skip(offset)
          .limit(parseInt(limit))
          .populate('createdBy', 'name email')
          .populate('moderatedBy', 'name email'),
        Message.countDocuments(filters)
      ]);

      const totalPages = Math.ceil(total / parseInt(limit));

      logger.info(`Admin listed messages: page ${page}, total ${total}`, {
        userId: req.user.id,
        filters
      });

      res.json({
        success: true,
        data: {
          messages,
          pagination: {
            currentPage: parseInt(page),
            totalPages,
            totalItems: total,
            itemsPerPage: parseInt(limit),
            hasNextPage: parseInt(page) < totalPages,
            hasPrevPage: parseInt(page) > 1
          }
        }
      });
    } catch (error) {
      logger.error('Error listing messages:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to retrieve messages',
        error: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }

  /**
   * Create a new message
   * POST /api/admin/messages
   */
  async create(req, res) {
    try {
      // Check validation results
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          message: 'Validation failed',
          errors: errors.array()
        });
      }

      const { content, category, scheduledFor, metadata } = req.body;

      // Check for duplicate content
      const existingMessage = await Message.findOne({ content });
      if (existingMessage) {
        return res.status(409).json({
          success: false,
          message: 'A message with this content already exists'
        });
      }

      // Create new message
      const message = new Message({
        content,
        category: category || 'general',
        scheduledFor: scheduledFor ? new Date(scheduledFor) : new Date(),
        status: 'active', // Admin messages are active by default
        metadata: metadata || {},
        createdBy: req.user.id,
        moderatedBy: req.user.id,
        moderatedAt: new Date()
      });

      await message.save();
      await message.populate('createdBy', 'name email');
      await message.populate('moderatedBy', 'name email');

      logger.info('Admin created new message:', {
        messageId: message._id,
        userId: req.user.id,
        category: message.category
      });

      res.status(201).json({
        success: true,
        message: 'Message created successfully',
        data: { message }
      });
    } catch (error) {
      logger.error('Error creating message:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to create message',
        error: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }

  /**
   * Update an existing message
   * PUT /api/admin/messages/:id
   */
  async update(req, res) {
    try {
      // Check validation results
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          message: 'Validation failed',
          errors: errors.array()
        });
      }

      const { id } = req.params;
      const { content, category, scheduledFor, metadata, moderationNotes } = req.body;

      // Find existing message
      const message = await Message.findById(id);
      if (!message) {
        return res.status(404).json({
          success: false,
          message: 'Message not found'
        });
      }

      // Check for duplicate content (excluding current message)
      if (content && content !== message.content) {
        const existingMessage = await Message.findOne({ 
          content, 
          _id: { $ne: id } 
        });
        if (existingMessage) {
          return res.status(409).json({
            success: false,
            message: 'A message with this content already exists'
          });
        }
      }

      // Prepare update data
      const updateData = {
        updatedAt: new Date(),
        moderatedBy: req.user.id,
        moderatedAt: new Date()
      };

      if (content !== undefined) updateData.content = content;
      if (category !== undefined) updateData.category = category;
      if (scheduledFor !== undefined) updateData.scheduledFor = new Date(scheduledFor);
      if (metadata !== undefined) updateData.metadata = metadata;
      if (moderationNotes !== undefined) updateData.moderationNotes = moderationNotes;

      // Update message
      const updatedMessage = await Message.findByIdAndUpdate(
        id,
        updateData,
        { new: true, runValidators: true }
      ).populate('createdBy', 'name email')
       .populate('moderatedBy', 'name email');

      logger.info('Admin updated message:', {
        messageId: id,
        userId: req.user.id,
        changes: Object.keys(updateData)
      });

      res.json({
        success: true,
        message: 'Message updated successfully',
        data: { message: updatedMessage }
      });
    } catch (error) {
      logger.error('Error updating message:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to update message',
        error: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }

  /**
   * Delete a message
   * DELETE /api/admin/messages/:id
   */
  async delete(req, res) {
    try {
      const { id } = req.params;

      // Find and delete message
      const message = await Message.findById(id);
      if (!message) {
        return res.status(404).json({
          success: false,
          message: 'Message not found'
        });
      }

      // Soft delete - mark as inactive instead of hard delete
      const deletedMessage = await Message.findByIdAndUpdate(
        id,
        {
          status: 'deleted',
          deletedAt: new Date(),
          deletedBy: req.user.id,
          updatedAt: new Date()
        },
        { new: true }
      );

      logger.info('Admin deleted message:', {
        messageId: id,
        userId: req.user.id,
        originalStatus: message.status
      });

      res.json({
        success: true,
        message: 'Message deleted successfully',
        data: { message: deletedMessage }
      });
    } catch (error) {
      logger.error('Error deleting message:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to delete message',
        error: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }

  /**
   * Toggle message active status
   * PATCH /api/admin/messages/:id/toggle
   */
  async toggle_active(req, res) {
    try {
      const { id } = req.params;
      const { moderationNotes } = req.body;

      // Find existing message
      const message = await Message.findById(id);
      if (!message) {
        return res.status(404).json({
          success: false,
          message: 'Message not found'
        });
      }

      // Cannot toggle deleted messages
      if (message.status === 'deleted') {
        return res.status(400).json({
          success: false,
          message: 'Cannot toggle status of deleted messages'
        });
      }

      // Determine new status
      const newStatus = message.status === 'active' ? 'inactive' : 'active';

      // Perform moderation checks for activation
      if (newStatus === 'active') {
        const moderationResult = await this._performModerationChecks(message.content);
        if (!moderationResult.approved) {
          return res.status(422).json({
            success: false,
            message: 'Message failed moderation checks',
            data: {
              reasons: moderationResult.reasons,
              suggestions: moderationResult.suggestions
            }
          });
        }
      }

      // Update message status
      const updatedMessage = await Message.findByIdAndUpdate(
        id,
        {
          status: newStatus,
          moderatedBy: req.user.id,
          moderatedAt: new Date(),
          moderationNotes: moderationNotes || message.moderationNotes,
          updatedAt: new Date()
        },
        { new: true, runValidators: true }
      ).populate('createdBy', 'name email')
       .populate('moderatedBy', 'name email');

      logger.info('Admin toggled message status:', {
        messageId: id,
        userId: req.user.id,
        oldStatus: message.status,
        newStatus
      });

      res.json({
        success: true,
        message: `Message ${newStatus === 'active' ? 'activated' : 'deactivated'} successfully`,
        data: { message: updatedMessage }
      });
    } catch (error) {
      logger.error('Error toggling message status:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to toggle message status',
        error: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }

  /**
   * Perform automated moderation checks on message content
   * @private
   */
  async _performModerationChecks(content) {
    try {
      const reasons = [];
      const suggestions = [];
      let approved = true;

      // Content length checks
      if (content.length < 10) {
        approved = false;
        reasons.push('Content too short (minimum 10 characters)');
        suggestions.push('Add more meaningful content to provide value to users');
      }

      if (content.length > 500) {
        approved = false;
        reasons.push('Content too long (maximum 500 characters)');
        suggestions.push('Shorten the message to be more concise and impactful');
      }

      // Profanity and inappropriate content (basic check)
      const inappropriateWords = [
        'hate', 'violence', 'harm', 'kill', 'death', 'suicide',
        'drug', 'alcohol', 'gambling', 'sex', 'explicit'
      ];
      
      const lowerContent = content.toLowerCase();
      const foundInappropriate = inappropriateWords.filter(word => 
        lowerContent.includes(word)
      );

      if (foundInappropriate.length > 0) {
        approved = false;
        reasons.push(`Contains inappropriate content: ${foundInappropriate.join(', ')}`);
        suggestions.push('Remove inappropriate language and focus on positive, uplifting content');
      }

      // Required positive elements
      const positiveWords = [
        'love', 'peace', 'hope', 'joy', 'faith', 'blessing', 'light',
        'guidance', 'strength', 'courage', 'gratitude', 'compassion'
      ];

      const foundPositive = positiveWords.some(word => 
        lowerContent.includes(word)
      );

      if (!foundPositive) {
        reasons.push('Content may lack positive spiritual elements');
        suggestions.push('Consider adding uplifting words that inspire and encourage');
      }

      // Check for commercial content
      const commercialWords = ['buy', 'purchase', 'sale', 'discount', 'price', '$'];
      const foundCommercial = commercialWords.some(word => 
        lowerContent.includes(word)
      );

      if (foundCommercial) {
        approved = false;
        reasons.push('Contains commercial content');
        suggestions.push('Remove commercial language - focus on spiritual guidance');
      }

      return {
        approved,
        reasons,
        suggestions,
        checkedAt: new Date()
      };
    } catch (error) {
      logger.error('Error in moderation checks:', error);
      return {
        approved: false,
        reasons: ['Moderation check failed - manual review required'],
        suggestions: ['Please review content manually'],
        error: error.message
      };
    }
  }
}

module.exports = new MessageAdminController();