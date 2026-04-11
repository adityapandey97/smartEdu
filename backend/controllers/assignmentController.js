const Assignment = require('../models/Assignment');
const Submission = require('../models/Submission');
const Notification = require('../models/Notification');

const assignmentController = {
  createAssignment: async (req, res) => {
    try {
      const { title, description, subject, deadline } = req.body;

      const assignment = new Assignment({
        title,
        description,
        subject,
        deadline,
        createdBy: req.user.userId
      });
      await assignment.save();

      const notification = new Notification({
        role: 'student',
        type: 'assignment',
        title: 'New Assignment',
        message: `New assignment posted: ${title} (${subject})`
      });
      await notification.save();

      res.status(201).json({ message: 'Assignment created', assignment });
    } catch (error) {
      res.status(500).json({ message: 'Failed to create assignment', error: error.message });
    }
  },

  getAssignments: async (req, res) => {
    try {
      const { subject } = req.query;
      const query = subject ? { subject } : {};
      const assignments = await Assignment.find(query).populate('createdBy', 'name').sort({ deadline: -1 });
      res.json(assignments);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get assignments', error: error.message });
    }
  },

  getAssignment: async (req, res) => {
    try {
      const assignment = await Assignment.findById(req.params.id).populate('createdBy', 'name');
      res.json(assignment);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get assignment', error: error.message });
    }
  },

  submitAssignment: async (req, res) => {
    try {
      const { assignmentId, content, fileUrl } = req.body;
      const studentId = req.user.userId;

      const assignment = await Assignment.findById(assignmentId);
      if (!assignment) {
        return res.status(404).json({ message: 'Assignment not found' });
      }

      const isLate = new Date() > new Date(assignment.deadline);

      let submission = await Submission.findOne({ assignmentId, studentId });
      if (submission) {
        submission.content = content || submission.content;
        submission.fileUrl = fileUrl || submission.fileUrl;
        submission.status = isLate ? 'late' : 'submitted';
        submission.updatedAt = new Date();
        await submission.save();
      } else {
        submission = new Submission({
          assignmentId,
          studentId,
          content,
          fileUrl,
          status: isLate ? 'late' : 'submitted'
        });
        await submission.save();
      }

      res.status(201).json({ message: 'Assignment submitted', submission });
    } catch (error) {
      res.status(500).json({ message: 'Failed to submit assignment', error: error.message });
    }
  },

  getSubmissions: async (req, res) => {
    try {
      const { assignmentId } = req.params;
      const submissions = await Submission.find({ assignmentId })
        .populate('studentId', 'name email studentId')
        .sort({ submittedAt: -1 });
      res.json(submissions);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get submissions', error: error.message });
    }
  },

  getMySubmissions: async (req, res) => {
    try {
      const submissions = await Submission.find({ studentId: req.user.userId })
        .populate('assignmentId', 'title subject deadline');
      res.json(submissions);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get submissions', error: error.message });
    }
  },

  getPendingAssignments: async (req, res) => {
    try {
      const mySubmissions = await Submission.find({ studentId: req.user.userId }).select('assignmentId');
      const submittedIds = mySubmissions.map(s => s.assignmentId);

      const pendingAssignments = await Assignment.find({
        _id: { $nin: submittedIds },
        deadline: { $gte: new Date() }
      }).populate('createdBy', 'name');

      res.json(pendingAssignments);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get pending assignments', error: error.message });
    }
  }
};

module.exports = assignmentController;
