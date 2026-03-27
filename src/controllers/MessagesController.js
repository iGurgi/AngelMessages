const crypto = require('crypto');
const rateLimit = require('express-rate-limit');

// Rate limiting middleware - 100 requests per hour per IP
const dailyMessagesRateLimit = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 100,
  message: {
    error: 'Too many requests for daily messages. Please try again later.',
    retryAfter: 3600
  },
  standardHeaders: true,
  legacyHeaders: false,
});

class MessagesController {
  constructor(messageService) {
    this.messageService = messageService;
  }

  /**
   * Get daily messages with ETag caching and rate limiting
   * @param {Object} req - Express request object
   * @param {Object} res - Express response object
   */
  async getDailyMessages(req, res) {
    try {
      // Apply rate limiting
      await new Promise((resolve, reject) => {
        dailyMessagesRateLimit(req, res, (err) => {
          if (err) reject(err);
          else resolve();
        });
      });

      const clientETag = req.headers['if-none-match'];
      const currentDate = new Date().toISOString().split('T')[0]; // YYYY-MM-DD format
      
      // Fetch active messages from database/service
      const activeMessages = await this.messageService.getActiveMessages(currentDate);
      
      if (!activeMessages || activeMessages.length === 0) {
        return res.status(404).json({
          error: 'No active messages found for today',
          date: currentDate,
          messages: []
        });
      }

      // Generate ETag based on messages content and date
      const messagesHash = crypto
        .createHash('md5')
        .update(JSON.stringify(activeMessages) + currentDate)
        .digest('hex');
      const etag = `"${messagesHash}"`;

      // Check if client has cached version
      if (clientETag === etag) {
        return res.status(304).end();
      }

      // Format response data
      const responseData = {
        date: currentDate,
        lastUpdated: new Date().toISOString(),
        messages: activeMessages.map(message => ({
          id: message.id,
          text: message.text,
          author: message.author || null,
          category: message.category || 'inspiration',
          priority: message.priority || 1,
          isActive: message.isActive,
          scheduledDate: message.scheduledDate,
          createdAt: message.createdAt,
          updatedAt: message.updatedAt
        })),
        totalCount: activeMessages.length
      };

      // Set response headers
      res.set({
        'Content-Type': 'application/json',
        'ETag': etag,
        'Cache-Control': 'private, max-age=3600', // Cache for 1 hour
        'Last-Modified': new Date().toUTCString(),
        'X-Total-Count': activeMessages.length.toString(),
        'X-Rate-Limit-Remaining': res.get('X-RateLimit-Remaining') || '99'
      });

      return res.status(200).json(responseData);

    } catch (error) {
      console.error('Error in getDailyMessages:', error);
      
      // Handle specific error types
      if (error.name === 'ValidationError') {
        return res.status(400).json({
          error: 'Invalid request parameters',
          details: error.message
        });
      }
      
      if (error.name === 'DatabaseError') {
        return res.status(503).json({
          error: 'Service temporarily unavailable',
          message: 'Please try again later'
        });
      }

      // Rate limit exceeded
      if (error.status === 429) {
        return res.status(429).json({
          error: 'Too many requests',
          message: 'Rate limit exceeded. Please try again later.',
          retryAfter: 3600
        });
      }

      // Generic server error
      return res.status(500).json({
        error: 'Internal server error',
        message: 'An unexpected error occurred while fetching daily messages'
      });
    }
  }

  /**
   * Get rate limiting middleware for use in routes
   */
  static getRateLimitMiddleware() {
    return dailyMessagesRateLimit;
  }

  /**
   * Health check endpoint for messages service
   */
  async healthCheck(req, res) {
    try {
      const isHealthy = await this.messageService.isHealthy();
      
      if (isHealthy) {
        return res.status(200).json({
          status: 'healthy',
          service: 'messages',
          timestamp: new Date().toISOString()
        });
      } else {
        return res.status(503).json({
          status: 'unhealthy',
          service: 'messages',
          timestamp: new Date().toISOString()
        });
      }
    } catch (error) {
      return res.status(503).json({
        status: 'error',
        service: 'messages',
        error: error.message,
        timestamp: new Date().toISOString()
      });
    }
  }
}

module.exports = MessagesController;