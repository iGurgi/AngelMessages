const crypto = require('crypto');

/**
 * Service for generating and comparing ETags for HTTP caching
 * Used to implement conditional requests and 304 Not Modified responses
 */
class ETagService {
  /**
   * Generate an ETag from data using MD5 hash
   * @param {any} data - The data to generate ETag from (will be JSON stringified)
   * @returns {string} ETag in format '"<hash>"'
   */
  static generateETag(data) {
    if (data === null || data === undefined) {
      return '"d41d8cd98f00b204e9800998ecf8427e"'; // Empty string hash
    }

    // Convert data to consistent string representation
    const dataString = typeof data === 'string' ? data : JSON.stringify(data);
    
    // Generate MD5 hash
    const hash = crypto.createHash('md5').update(dataString, 'utf8').digest('hex');
    
    // Return ETag in proper HTTP format with quotes
    return `"${hash}"`;
  }

  /**
   * Compare request ETag with current ETag to determine if content has changed
   * @param {string} requestETag - ETag from If-None-Match header
   * @param {string} currentETag - Current ETag for the resource
   * @returns {boolean} True if ETags match (return 304), false if different (return 200)
   */
  static compareETag(requestETag, currentETag) {
    if (!requestETag || !currentETag) {
      return false; // No ETag comparison possible
    }

    // Handle multiple ETags in If-None-Match header (comma-separated)
    if (requestETag.includes(',')) {
      const eTags = requestETag.split(',').map(etag => etag.trim());
      return eTags.includes(currentETag);
    }

    // Handle wildcard ETag (*)
    if (requestETag.trim() === '*') {
      return true;
    }

    // Direct comparison
    return requestETag.trim() === currentETag.trim();
  }

  /**
   * Generate ETag for message data specifically
   * Includes message content, date, and any metadata for comprehensive caching
   * @param {Object} message - Message object
   * @returns {string} ETag for the message
   */
  static generateMessageETag(message) {
    const { content, date, category, author, ...metadata } = message;
    
    // Create consistent data representation for ETag generation
    const etagData = {
      content,
      date: date instanceof Date ? date.toISOString() : date,
      category,
      author,
      metadata: Object.keys(metadata).sort().reduce((sorted, key) => {
        sorted[key] = metadata[key];
        return sorted;
      }, {})
    };

    return this.generateETag(etagData);
  }

  /**
   * Check if request should return 304 Not Modified
   * @param {string} ifNoneMatch - If-None-Match header value
   * @param {string} currentETag - Current resource ETag
   * @returns {boolean} True if should return 304
   */
  static shouldReturn304(ifNoneMatch, currentETag) {
    return this.compareETag(ifNoneMatch, currentETag);
  }
}

module.exports = ETagService;