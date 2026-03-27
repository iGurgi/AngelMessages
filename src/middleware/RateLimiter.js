/**
 * Rate Limiter Middleware for Angel Messages API
 * Tracks daily requests per device_id and enforces 1000 requests/day limit
 */

class RateLimiter {
  constructor() {
    // In-memory store for request counts
    // Format: { device_id: { count: number, resetTime: Date } }
    this.requestCounts = new Map();
    
    // Clean up expired entries every hour
    setInterval(() => this.cleanup(), 60 * 60 * 1000);
  }

  /**
   * Get the start of the current day in UTC
   */
  getCurrentDayStart() {
    const now = new Date();
    return new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
  }

  /**
   * Get the start of the next day in UTC
   */
  getNextDayStart() {
    const today = this.getCurrentDayStart();
    return new Date(today.getTime() + 24 * 60 * 60 * 1000);
  }

  /**
   * Clean up expired request count entries
   */
  cleanup() {
    const now = new Date();
    for (const [deviceId, data] of this.requestCounts.entries()) {
      if (now >= data.resetTime) {
        this.requestCounts.delete(deviceId);
      }
    }
  }

  /**
   * Get current request count for a device
   */
  getRequestCount(deviceId) {
    const data = this.requestCounts.get(deviceId);
    const now = new Date();
    
    // If no data exists or reset time has passed, return 0
    if (!data || now >= data.resetTime) {
      return 0;
    }
    
    return data.count;
  }

  /**
   * Increment request count for a device
   */
  incrementRequestCount(deviceId) {
    const now = new Date();
    const resetTime = this.getNextDayStart();
    const currentData = this.requestCounts.get(deviceId);
    
    // If no data exists or reset time has passed, start fresh
    if (!currentData || now >= currentData.resetTime) {
      this.requestCounts.set(deviceId, {
        count: 1,
        resetTime: resetTime
      });
      return 1;
    }
    
    // Increment existing count
    currentData.count += 1;
    return currentData.count;
  }

  /**
   * Get seconds until rate limit reset
   */
  getSecondsUntilReset(deviceId) {
    const data = this.requestCounts.get(deviceId);
    if (!data) {
      return 0;
    }
    
    const now = new Date();
    const secondsUntilReset = Math.max(0, Math.floor((data.resetTime - now) / 1000));
    return secondsUntilReset;
  }

  /**
   * Express middleware function
   */
  middleware() {
    return (req, res, next) => {
      const deviceId = req.headers['device-id'] || req.headers['x-device-id'];
      
      // Require device_id header
      if (!deviceId) {
        return res.status(400).json({
          error: 'Bad Request',
          message: 'device-id header is required'
        });
      }

      const DAILY_LIMIT = 1000;
      const currentCount = this.getRequestCount(deviceId);
      
      // Check if already at limit
      if (currentCount >= DAILY_LIMIT) {
        const resetInSeconds = this.getSecondsUntilReset(deviceId);
        
        return res.status(429)
          .set({
            'X-RateLimit-Limit': DAILY_LIMIT.toString(),
            'X-RateLimit-Remaining': '0',
            'X-RateLimit-Reset': Math.floor(Date.now() / 1000 + resetInSeconds).toString(),
            'Retry-After': resetInSeconds.toString()
          })
          .json({
            error: 'Too Many Requests',
            message: `Daily limit of ${DAILY_LIMIT} requests exceeded`,
            resetInSeconds: resetInSeconds
          });
      }
      
      // Increment request count
      const newCount = this.incrementRequestCount(deviceId);
      const remaining = Math.max(0, DAILY_LIMIT - newCount);
      const resetInSeconds = this.getSecondsUntilReset(deviceId);
      
      // Add rate limit headers to response
      res.set({
        'X-RateLimit-Limit': DAILY_LIMIT.toString(),
        'X-RateLimit-Remaining': remaining.toString(),
        'X-RateLimit-Reset': Math.floor(Date.now() / 1000 + resetInSeconds).toString()
      });
      
      // Continue to next middleware
      next();
    };
  }
}

// Create singleton instance
const rateLimiter = new RateLimiter();

// Export the middleware function
module.exports = rateLimiter.middleware();

// Export the class for testing
module.exports.RateLimiter = RateLimiter;
module.exports.rateLimiterInstance = rateLimiter;