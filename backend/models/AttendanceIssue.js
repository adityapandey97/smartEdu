const mongoose = require('mongoose');

const attendanceIssueSchema = new mongoose.Schema({
  studentId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  subject: { type: String, required: true },
  date: { type: Date, required: true },
  issueType: { type: String, enum: ['marked_absent', 'wrong_date', 'other'], required: true },
  description: { type: String, required: true },
  proof: { type: String },
  status: { type: String, enum: ['pending', 'approved', 'rejected'], default: 'pending' },
  resolvedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  resolvedAt: { type: Date },
  resolutionNote: { type: String },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('AttendanceIssue', attendanceIssueSchema);
