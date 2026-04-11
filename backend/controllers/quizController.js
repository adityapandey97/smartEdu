const Quiz = require('../models/Quiz');
const QuizResult = require('../models/QuizResult');

const quizController = {
  createQuiz: async (req, res) => {
    try {
      const { title, subject, duration, questions } = req.body;

      const quiz = new Quiz({
        title,
        subject,
        duration,
        questions,
        createdBy: req.user.userId
      });
      await quiz.save();

      res.status(201).json({ message: 'Quiz created', quiz });
    } catch (error) {
      res.status(500).json({ message: 'Failed to create quiz', error: error.message });
    }
  },

  getQuizzes: async (req, res) => {
    try {
      const { subject } = req.query;
      const query = subject ? { subject } : {};
      const quizzes = await Quiz.find(query).populate('createdBy', 'name').sort({ createdAt: -1 });
      res.json(quizzes);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get quizzes', error: error.message });
    }
  },

  getQuiz: async (req, res) => {
    try {
      const quiz = await Quiz.findById(req.params.id);
      res.json(quiz);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get quiz', error: error.message });
    }
  },

  submitQuiz: async (req, res) => {
    try {
      const { quizId, answers } = req.body;
      const studentId = req.user.userId;

      const quiz = await Quiz.findById(quizId);
      if (!quiz) {
        return res.status(404).json({ message: 'Quiz not found' });
      }

      let score = 0;
      const answeredQuestions = answers.map((answer, index) => {
        const correct = answer === quiz.questions[index].correctAnswer;
        if (correct) score++;
        return {
          questionIndex: index,
          selectedAnswer: answer,
          correct
        };
      });

      const result = new QuizResult({
        quizId,
        studentId,
        score,
        totalQuestions: quiz.questions.length,
        answers: answeredQuestions
      });
      await result.save();

      res.json({ message: 'Quiz submitted', result });
    } catch (error) {
      res.status(500).json({ message: 'Failed to submit quiz', error: error.message });
    }
  },

  getMyResults: async (req, res) => {
    try {
      const results = await QuizResult.find({ studentId: req.user.userId })
        .populate('quizId', 'title subject')
        .sort({ completedAt: -1 });
      res.json(results);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get results', error: error.message });
    }
  },

  getQuizResults: async (req, res) => {
    try {
      const { quizId } = req.params;
      const results = await QuizResult.find({ quizId })
        .populate('studentId', 'name email studentId')
        .sort({ score: -1 });
      res.json(results);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get results', error: error.message });
    }
  }
};

module.exports = quizController;
