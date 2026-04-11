const LeaveApplication = require('../models/LeaveApplication');
const Notification = require('../models/Notification');

const leaveController = {
  applyLeave: async (req, res) => {
    try {
      const { startDate, endDate, reason } = req.body;

      const application = new LeaveApplication({
        studentId: req.user.userId,
        startDate,
        endDate,
        reason
      });
      await application.save();

      res.status(201).json({ message: 'Leave application submitted', application });
    } catch (error) {
      res.status(500).json({ message: 'Failed to submit application', error: error.message });
    }
  },

  getMyApplications: async (req, res) => {
    try {
      const applications = await LeaveApplication.find({ studentId: req.user.userId })
        .sort({ createdAt: -1 });
      res.json(applications);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get applications', error: error.message });
    }
  },

  getAllApplications: async (req, res) => {
    try {
      const applications = await LeaveApplication.find({ status: 'pending' })
        .populate('studentId', 'name email studentId')
        .sort({ createdAt: -1 });
      res.json(applications);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get applications', error: error.message });
    }
  },

  reviewApplication: async (req, res) => {
    try {
      const { id } = req.params;
      const { status, reviewNote } = req.body;

      const application = await LeaveApplication.findById(id);
      if (!application) {
        return res.status(404).json({ message: 'Application not found' });
      }

      application.status = status;
      application.reviewedBy = req.user.userId;
      application.reviewedAt = new Date();
      application.reviewNote = reviewNote;
      await application.save();

      const notification = new Notification({
        userId: application.studentId,
        type: 'general',
        title: 'Leave Application Status',
        message: `Your leave application has been ${status}`
      });
      await notification.save();

      res.json({ message: 'Application reviewed', application });
    } catch (error) {
      res.status(500).json({ message: 'Failed to review application', error: error.message });
    }
  }
};

module.exports = leaveController;
