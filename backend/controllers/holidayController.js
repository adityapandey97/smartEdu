const Holiday = require('../models/Holiday');
const Notification = require('../models/Notification');

const holidayController = {
  createHoliday: async (req, res) => {
    try {
      const { title, date, reason } = req.body;

      const holiday = new Holiday({
        title,
        date,
        reason,
        createdBy: req.user.userId
      });
      await holiday.save();

      const notification = new Notification({
        role: 'all',
        type: 'holiday',
        title: 'Holiday Announcement',
        message: `${title} - ${reason || 'Enjoy your holiday!'}`
      });
      await notification.save();

      res.status(201).json({ message: 'Holiday created', holiday });
    } catch (error) {
      res.status(500).json({ message: 'Failed to create holiday', error: error.message });
    }
  },

  getHolidays: async (req, res) => {
    try {
      const holidays = await Holiday.find().sort({ date: 1 });
      res.json(holidays);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get holidays', error: error.message });
    }
  },

  checkHoliday: async (req, res) => {
    try {
      const { date } = req.query;
      const holiday = await Holiday.findOne({ date: new Date(date) });
      res.json({ isHoliday: !!holiday, holiday });
    } catch (error) {
      res.status(500).json({ message: 'Failed to check holiday', error: error.message });
    }
  }
};

module.exports = holidayController;
