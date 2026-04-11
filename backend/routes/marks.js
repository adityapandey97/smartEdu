const express = require('express');
const router = express.Router();
const markController = require('../controllers/markController');
const auth = require('../middleware/auth');

router.post('/upload', auth, markController.uploadMarks);
router.get('/student/:studentId', auth, markController.getStudentMarks);
router.get('/average/:studentId', auth, markController.getAverageMarks);
router.get('/analytics/:studentId', auth, markController.getAnalytics);

module.exports = router;
