const Feedback = require('../models/Feedback');

const feedbackController = {
  submitFeedback: async (req, res) => {
    try {
      const { teacherId, subject, rating, comment } = req.body;

      const feedback = new Feedback({
        studentId: req.user.userId,
        teacherId,
        subject,
        rating,
        comment
      });
      await feedback.save();

      res.status(201).json({ message: 'Feedback submitted', feedback });
    } catch (error) {
      res.status(500).json({ message: 'Failed to submit feedback', error: error.message });
    }
  },

  getFeedback: async (req, res) => {
    try {
      const feedback = await Feedback.find()
        .populate('studentId', 'name email')
        .populate('teacherId', 'name')
        .sort({ createdAt: -1 });
      res.json(feedback);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get feedback', error: error.message });
    }
  },

  getTeacherFeedback: async (req, res) => {
    try {
      const feedback = await Feedback.find({ teacherId: req.params.teacherId })
        .populate('studentId', 'name email')
        .sort({ createdAt: -1 });

      const avgRating = feedback.length > 0
        ? (feedback.reduce((sum, f) => sum + f.rating, 0) / feedback.length).toFixed(1)
        : 0;

      res.json({ feedback, averageRating: avgRating });
    } catch (error) {
      res.status(500).json({ message: 'Failed to get feedback', error: error.message });
    }
  }
};

module.exports = feedbackController;
