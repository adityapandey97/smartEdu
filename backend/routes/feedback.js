const express = require('express');
const router = express.Router();
const feedbackController = require('../controllers/feedbackController');
const auth = require('../middleware/auth');

router.post('/submit', auth, feedbackController.submitFeedback);
router.get('/', auth, feedbackController.getFeedback);
router.get('/teacher/:teacherId', auth, feedbackController.getTeacherFeedback);

module.exports = router;
