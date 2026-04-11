const Attendance = require('../models/Attendance');
const AttendanceIssue = require('../models/AttendanceIssue');
const User = require('../models/User');
const Notification = require('../models/Notification');

const attendanceController = {
  markAttendance: async (req, res) => {
    try {
      const { studentId, subject, date, status } = req.body;
      const markedBy = req.user.userId;

      let attendance = await Attendance.findOne({ studentId, subject, date });
      if (attendance) {
        attendance.status = status;
        attendance.markedBy = markedBy;
        await attendance.save();
      } else {
        attendance = new Attendance({ studentId, subject, date, status, markedBy });
        await attendance.save();
      }

      res.json({ message: 'Attendance marked successfully', attendance });
    } catch (error) {
      res.status(500).json({ message: 'Failed to mark attendance', error: error.message });
    }
  },

  getStudentAttendance: async (req, res) => {
    try {
      const { studentId } = req.params;
      const { subject } = req.query;

      const query = { studentId };
      if (subject) query.subject = subject;

      const attendance = await Attendance.find(query).sort({ date: -1 });
      const totalClasses = attendance.length;
      const presentClasses = attendance.filter(a => a.status === 'present').length;
      const attendancePercentage = totalClasses > 0 ? (presentClasses / totalClasses) * 100 : 0;

      const subjectWise = {};
      attendance.forEach(a => {
        if (!subjectWise[a.subject]) {
          subjectWise[a.subject] = { total: 0, present: 0 };
        }
        subjectWise[a.subject].total++;
        if (a.status === 'present') subjectWise[a.subject].present++;
      });

      const subjectsArray = Object.keys(subjectWise).map(subject => ({
        subject,
        total: subjectWise[subject].total,
        present: subjectWise[subject].present,
        percentage: subjectWise[subject].total > 0
          ? (subjectWise[subject].present / subjectWise[subject].total) * 100
          : 0
      }));

      res.json({
        totalClasses,
        presentClasses,
        attendancePercentage: attendancePercentage.toFixed(2),
        subjects: subjectsArray,
        records: attendance
      });
    } catch (error) {
      res.status(500).json({ message: 'Failed to get attendance', error: error.message });
    }
  },

  getAttendanceOverview: async (req, res) => {
    try {
      const { studentId } = req.params;
      const attendance = await Attendance.find({ studentId });
      const totalClasses = attendance.length;
      const presentClasses = attendance.filter(a => a.status === 'present').length;
      const percentage = totalClasses > 0 ? (presentClasses / totalClasses) * 100 : 0;

      res.json({
        totalClasses,
        presentClasses,
        percentage: percentage.toFixed(2),
        isBelow75: percentage < 75
      });
    } catch (error) {
      res.status(500).json({ message: 'Failed to get overview', error: error.message });
    }
  },

  reportIssue: async (req, res) => {
    try {
      const { studentId, subject, date, issueType, description, proof } = req.body;

      const issue = new AttendanceIssue({
        studentId,
        subject,
        date,
        issueType,
        description,
        proof
      });
      await issue.save();

      const notification = new Notification({
        userId: req.user.userId,
        role: 'teacher',
        type: 'attendance',
        title: 'Attendance Issue Reported',
        message: `Student reported attendance issue for ${subject} on ${new Date(date).toLocaleDateString()}`
      });
      await notification.save();

      res.status(201).json({ message: 'Issue reported successfully', issue });
    } catch (error) {
      res.status(500).json({ message: 'Failed to report issue', error: error.message });
    }
  },

  getPendingIssues: async (req, res) => {
    try {
      const issues = await AttendanceIssue.find({ status: 'pending' })
        .populate('studentId', 'name email studentId')
        .sort({ createdAt: -1 });
      res.json(issues);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get issues', error: error.message });
    }
  },

  resolveIssue: async (req, res) => {
    try {
      const { id } = req.params;
      const { status, resolutionNote } = req.body;

      const issue = await AttendanceIssue.findById(id);
      if (!issue) {
        return res.status(404).json({ message: 'Issue not found' });
      }

      issue.status = status;
      issue.resolvedBy = req.user.userId;
      issue.resolvedAt = new Date();
      issue.resolutionNote = resolutionNote;
      await issue.save();

      if (status === 'approved') {
        let attendance = await Attendance.findOne({
          studentId: issue.studentId,
          subject: issue.subject,
          date: issue.date
        });

        if (attendance) {
          attendance.status = 'present';
          await attendance.save();
        } else {
          attendance = new Attendance({
            studentId: issue.studentId,
            subject: issue.subject,
            date: issue.date,
            status: 'present',
            markedBy: req.user.userId
          });
          await attendance.save();
        }
      }

      const notification = new Notification({
        userId: issue.studentId,
        type: 'attendance',
        title: 'Attendance Issue Resolved',
        message: `Your attendance issue for ${issue.subject} has been ${status}`
      });
      await notification.save();

      res.json({ message: 'Issue resolved successfully', issue });
    } catch (error) {
      res.status(500).json({ message: 'Failed to resolve issue', error: error.message });
    }
  },

  getMyIssues: async (req, res) => {
    try {
      const issues = await AttendanceIssue.find({ studentId: req.user.userId })
        .sort({ createdAt: -1 });
      res.json(issues);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get issues', error: error.message });
    }
  }
};

module.exports = attendanceController;
