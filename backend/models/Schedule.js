const mongoose = require('mongoose');

const scheduleSchema = new mongoose.Schema({
  dayOfWeek: { type: Number, required: true },
  period: { type: Number, required: true },
  subject: { type: String, required: true },
  teacherId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  teacherName: { type: String },
  room: { type: String },
  isSubstitute: { type: Boolean, default: false },
  substituteTeacher: { type: String },
  createdAt: { type: Date, default: Date.now }
});

scheduleSchema.index({ dayOfWeek: 1, period: 1 });

module.exports = mongoose.model('Schedule', scheduleSchema);
