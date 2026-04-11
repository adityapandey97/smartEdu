const Schedule = require('../models/Schedule');
const Notification = require('../models/Notification');

const scheduleController = {
  createSchedule: async (req, res) => {
    try {
      const { dayOfWeek, period, subject, teacherId, teacherName, room } = req.body;

      const schedule = new Schedule({
        dayOfWeek,
        period,
        subject,
        teacherId,
        teacherName,
        room
      });
      await schedule.save();

      res.status(201).json({ message: 'Schedule created', schedule });
    } catch (error) {
      res.status(500).json({ message: 'Failed to create schedule', error: error.message });
    }
  },

  getSchedule: async (req, res) => {
    try {
      const { dayOfWeek } = req.query;
      const query = dayOfWeek ? { dayOfWeek: parseInt(dayOfWeek) } : {};
      const schedules = await Schedule.find(query).sort({ period: 1 });
      res.json(schedules);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get schedule', error: error.message });
    }
  },

  setSubstitute: async (req, res) => {
    try {
      const { scheduleId, substituteTeacher } = req.body;

      const schedule = await Schedule.findById(scheduleId);
      if (!schedule) {
        return res.status(404).json({ message: 'Schedule not found' });
      }

      schedule.isSubstitute = true;
      schedule.substituteTeacher = substituteTeacher;
      await schedule.save();

      const notification = new Notification({
        role: 'student',
        type: 'substitute',
        title: 'Substitute Teacher',
        message: `${schedule.subject} class will be taken by ${substituteTeacher}`
      });
      await notification.save();

      res.json({ message: 'Substitute teacher set', schedule });
    } catch (error) {
      res.status(500).json({ message: 'Failed to set substitute', error: error.message });
    }
  }
};

module.exports = scheduleController;
