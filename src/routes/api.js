const express = require('express');
const MessagesController = require('../controllers/MessagesController');
const ApiVersion = require('../middleware/ApiVersion');
const RateLimiter = require('../middleware/RateLimiter');

const router = express.Router();

// Apply middleware to all API routes
router.use(ApiVersion);
router.use(RateLimiter);

// Messages endpoints
router.get('/messages/daily', MessagesController.getDailyMessages);

module.exports = router;