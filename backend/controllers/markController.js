const Mark = require('../models/Mark');
const Notification = require('../models/Notification');

const markController = {
  uploadMarks: async (req, res) => {
    try {
      const { studentId, subject, examType, marks, total } = req.body;

      const existingMark = await Mark.findOne({ studentId, subject, examType });
      if (existingMark) {
        existingMark.marks = marks;
        existingMark.total = total;
        await existingMark.save();
      } else {
        const newMark = new Mark({
          studentId,
          subject,
          examType,
          marks,
          total,
          uploadedBy: req.user.userId
        });
        await newMark.save();
      }

      const notification = new Notification({
        userId: studentId,
        type: 'marks',
        title: 'Marks Updated',
        message: `New marks uploaded for ${subject} - ${examType}: ${marks}/${total}`
      });
      await notification.save();

      res.json({ message: 'Marks uploaded successfully' });
    } catch (error) {
      res.status(500).json({ message: 'Failed to upload marks', error: error.message });
    }
  },

  getStudentMarks: async (req, res) => {
    try {
      const { studentId } = req.params;
      const { subject } = req.query;

      const query = { studentId };
      if (subject) query.subject = subject;

      const marks = await Mark.find(query).populate('uploadedBy', 'name').sort({ createdAt: -1 });

      const subjectWise = {};
      marks.forEach(m => {
        if (!subjectWise[m.subject]) {
          subjectWise[m.subject] = [];
        }
        subjectWise[m.subject].push(m);
      });

      const summary = Object.keys(subjectWise).map(sub => {
        const totalMarks = subjectWise[sub].reduce((sum, m) => sum + m.marks, 0);
        const totalMax = subjectWise[sub].reduce((sum, m) => sum + m.total, 0);
        return {
          subject: sub,
          average: totalMax > 0 ? (totalMarks / subjectWise[sub].length).toFixed(2) : 0,
          totalExams: subjectWise[sub].length
        };
      });

      const overallAverage = summary.length > 0
        ? (summary.reduce((sum, s) => sum + parseFloat(s.average), 0) / summary.length).toFixed(2)
        : 0;

      res.json({
        marks,
        summary,
        overallAverage
      });
    } catch (error) {
      res.status(500).json({ message: 'Failed to get marks', error: error.message });
    }
  },

  getAverageMarks: async (req, res) => {
    try {
      const { studentId } = req.params;
      const marks = await Mark.find({ studentId });

      const subjectWise = {};
      marks.forEach(m => {
        if (!subjectWise[m.subject]) {
          subjectWise[m.subject] = { total: 0, count: 0 };
        }
        subjectWise[m.subject].total += (m.marks / m.total) * 100;
        subjectWise[m.subject].count++;
      });

      const averages = Object.keys(subjectWise).map(sub => ({
        subject: sub,
        average: (subjectWise[sub].total / subjectWise[sub].count).toFixed(2)
      }));

      const overallAverage = averages.length > 0
        ? (averages.reduce((sum, a) => sum + parseFloat(a.average), 0) / averages.length).toFixed(2)
        : 0;

      res.json({ averages, overallAverage });
    } catch (error) {
      res.status(500).json({ message: 'Failed to get average', error: error.message });
    }
  },

  getAnalytics: async (req, res) => {
    try {
      const { studentId } = req.params;
      const marks = await Mark.find({ studentId });

      const subjectWise = {};
      marks.forEach(m => {
        if (!subjectWise[m.subject]) {
          subjectWise[m.subject] = { total: 0, count: 0 };
        }
        subjectWise[m.subject].total += (m.marks / m.total) * 100;
        subjectWise[m.subject].count++;
      });

      const chartData = Object.keys(subjectWise).map(sub => ({
        subject: sub,
        percentage: (subjectWise[sub].total / subjectWise[sub].count).toFixed(2)
      }));

      res.json(chartData);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get analytics', error: error.message });
    }
  }
};

module.exports = markController;
