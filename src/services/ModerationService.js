/**
 * Content moderation service for angel messages
 * Validates message content for appropriateness and spiritual context
 */
class ModerationService {
  constructor() {
    // Inappropriate content patterns
    this.inappropriatePatterns = [
      // Profanity and offensive language
      /\b(damn|hell|shit|fuck|bitch|ass|crap)\b/gi,
      // Violence and harm
      /\b(kill|murder|suicide|death|violence|hurt|harm|weapon)\b/gi,
      // Hate speech indicators
      /\b(hate|racist|discrimination|bigot)\b/gi,
      // Adult content
      /\b(sex|sexual|porn|naked|adult)\b/gi,
      // Gambling and addiction
      /\b(gamble|gambling|bet|casino|addiction|drugs)\b/gi
    ];

    // Required spiritual keywords that should be present
    this.spiritualKeywords = [
      'angel', 'angels', 'divine', 'blessed', 'blessing', 'blessings',
      'spirit', 'spiritual', 'soul', 'heart', 'love', 'light',
      'peace', 'harmony', 'guidance', 'wisdom', 'faith', 'hope',
      'grace', 'compassion', 'kindness', 'healing', 'prayer',
      'meditation', 'mindfulness', 'gratitude', 'joy', 'serenity',
      'enlightenment', 'awakening', 'consciousness', 'universe',
      'cosmic', 'energy', 'vibration', 'abundance', 'manifestation'
    ];

    // Positive emotion words that enhance spiritual messages
    this.positiveWords = [
      'beautiful', 'wonderful', 'amazing', 'perfect', 'gentle',
      'calm', 'peaceful', 'loving', 'caring', 'nurturing',
      'supportive', 'encouraging', 'uplifting', 'inspiring',
      'empowering', 'transformative', 'healing', 'sacred',
      'precious', 'worthy', 'valuable', 'special', 'unique'
    ];

    // Minimum and maximum content lengths
    this.minTitleLength = 10;
    this.maxTitleLength = 100;
    this.minContentLength = 50;
    this.maxContentLength = 500;
  }

  /**
   * Validates message content for appropriateness and spiritual context
   * @param {string} title - The message title
   * @param {string} content - The message content
   * @returns {Object} - Validation result with isValid boolean and reason string
   */
  validateContent(title, content) {
    // Input validation
    if (!title || typeof title !== 'string') {
      return {
        isValid: false,
        reason: 'Title is required and must be a string'
      };
    }

    if (!content || typeof content !== 'string') {
      return {
        isValid: false,
        reason: 'Content is required and must be a string'
      };
    }

    // Trim whitespace
    const trimmedTitle = title.trim();
    const trimmedContent = content.trim();

    // Length validation
    if (trimmedTitle.length < this.minTitleLength) {
      return {
        isValid: false,
        reason: `Title must be at least ${this.minTitleLength} characters long`
      };
    }

    if (trimmedTitle.length > this.maxTitleLength) {
      return {
        isValid: false,
        reason: `Title must not exceed ${this.maxTitleLength} characters`
      };
    }

    if (trimmedContent.length < this.minContentLength) {
      return {
        isValid: false,
        reason: `Content must be at least ${this.minContentLength} characters long`
      };
    }

    if (trimmedContent.length > this.maxContentLength) {
      return {
        isValid: false,
        reason: `Content must not exceed ${this.maxContentLength} characters`
      };
    }

    // Check for inappropriate content
    const combinedText = `${trimmedTitle} ${trimmedContent}`.toLowerCase();
    
    for (const pattern of this.inappropriatePatterns) {
      if (pattern.test(combinedText)) {
        return {
          isValid: false,
          reason: 'Content contains inappropriate language or themes'
        };
      }
    }

    // Validate spiritual context
    const spiritualValidation = this.validateSpiritualContext(combinedText);
    if (!spiritualValidation.isValid) {
      return spiritualValidation;
    }

    // Check message tone and structure
    const toneValidation = this.validateMessageTone(trimmedTitle, trimmedContent);
    if (!toneValidation.isValid) {
      return toneValidation;
    }

    // All validations passed
    return {
      isValid: true,
      reason: 'Content is valid and appropriate for angel messages'
    };
  }

  /**
   * Validates that content has appropriate spiritual context
   * @param {string} text - Combined title and content text
   * @returns {Object} - Validation result
   */
  validateSpiritualContext(text) {
    const words = text.toLowerCase().split(/\s+/);
    const hasSpiritual = this.spiritualKeywords.some(keyword => 
      text.includes(keyword.toLowerCase())
    );

    if (!hasSpiritual) {
      return {
        isValid: false,
        reason: 'Content must include spiritual or angelic themes'
      };
    }

    // Check for negative spiritual content patterns
    const negativePatterns = [
      /\b(curse|cursed|damned|evil|demon|devil|satan)\b/gi,
      /\b(punishment|punish|wrath|anger|revenge)\b/gi,
      /\b(fear|afraid|terror|horror|nightmare)\b/gi
    ];

    for (const pattern of negativePatterns) {
      if (pattern.test(text)) {
        return {
          isValid: false,
          reason: 'Content should focus on positive spiritual themes'
        };
      }
    }

    return { isValid: true };
  }

  /**
   * Validates the tone and structure of the message
   * @param {string} title - The message title
   * @param {string} content - The message content
   * @returns {Object} - Validation result
   */
  validateMessageTone(title, content) {
    const combinedText = `${title} ${content}`.toLowerCase();
    
    // Check for positive language presence
    const hasPositive = this.positiveWords.some(word => 
      combinedText.includes(word.toLowerCase())
    );

    // Check for command/imperative language balance
    const imperativePatterns = /\b(you must|you should|you have to|you need to)\b/gi;
    const imperativeMatches = (combinedText.match(imperativePatterns) || []).length;
    const totalSentences = content.split(/[.!?]+/).filter(s => s.trim().length > 0).length;
    
    if (imperativeMatches > totalSentences * 0.3) {
      return {
        isValid: false,
        reason: 'Message tone should be gentle and encouraging rather than commanding'
      };
    }

    // Check for excessive repetition
    const words = combinedText.split(/\s+/);
    const wordCount = {};
    let maxRepetition = 0;
    
    words.forEach(word => {
      if (word.length > 3) { // Only count significant words
        wordCount[word] = (wordCount[word] || 0) + 1;
        maxRepetition = Math.max(maxRepetition, wordCount[word]);
      }
    });

    if (maxRepetition > 4) {
      return {
        isValid: false,
        reason: 'Content contains excessive word repetition'
      };
    }

    // Check for proper sentence structure
    const sentences = content.split(/[.!?]+/).filter(s => s.trim().length > 0);
    if (sentences.length < 2) {
      return {
        isValid: false,
        reason: 'Content should contain at least two complete sentences'
      };
    }

    // Validate title format (should be sentence case, not all caps)
    if (title === title.toUpperCase() && title.length > 10) {
      return {
        isValid: false,
        reason: 'Title should use proper capitalization, not all uppercase'
      };
    }

    return { isValid: true };
  }

  /**
   * Get content validation statistics
   * @param {string} title - The message title
   * @param {string} content - The message content
   * @returns {Object} - Content statistics
   */
  getContentStats(title, content) {
    const combinedText = `${title} ${content}`.toLowerCase();
    const words = combinedText.split(/\s+/);
    
    const spiritualCount = this.spiritualKeywords.filter(keyword => 
      combinedText.includes(keyword.toLowerCase())
    ).length;
    
    const positiveCount = this.positiveWords.filter(word => 
      combinedText.includes(word.toLowerCase())
    ).length;

    return {
      titleLength: title.trim().length,
      contentLength: content.trim().length,
      wordCount: words.length,
      spiritualKeywords: spiritualCount,
      positiveWords: positiveCount,
      sentenceCount: content.split(/[.!?]+/).filter(s => s.trim().length > 0).length
    };
  }
}

module.exports = ModerationService;