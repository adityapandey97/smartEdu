const express = require('express');
const router = express.Router();
const quizController = require('../controllers/quizController');
const auth = require('../middleware/auth');

router.post('/create', auth, quizController.createQuiz);
router.get('/', auth, quizController.getQuizzes);
router.get('/:id', auth, quizController.getQuiz);
router.post('/submit', auth, quizController.submitQuiz);
router.get('/my-results', auth, quizController.getMyResults);
router.get('/results/:quizId', auth, quizController.getQuizResults);

module.exports = router;
