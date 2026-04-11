const Notification = require('../models/Notification');

const notificationController = {
  createNotification: async (req, res) => {
    try {
      const { userId, role, type, title, message } = req.body;

      const notification = new Notification({
        userId,
        role,
        type,
        title,
        message
      });
      await notification.save();

      res.status(201).json({ message: 'Notification created', notification });
    } catch (error) {
      res.status(500).json({ message: 'Failed to create notification', error: error.message });
    }
  },

  getNotifications: async (req, res) => {
    try {
      const userId = req.user.userId;
      const role = req.user.role;

      const notifications = await Notification.find({
        $or: [
          { userId: userId },
          { role: role },
          { role: 'all' }
        ]
      }).sort({ createdAt: -1 });

      res.json(notifications);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get notifications', error: error.message });
    }
  },

  getUnreadCount: async (req, res) => {
    try {
      const userId = req.user.userId;
      const role = req.user.role;

      const count = await Notification.countDocuments({
        $or: [
          { userId: userId },
          { role: role },
          { role: 'all' }
        ],
        read: false
      });

      res.json({ count });
    } catch (error) {
      res.status(500).json({ message: 'Failed to get count', error: error.message });
    }
  },

  markAsRead: async (req, res) => {
    try {
      const { id } = req.params;

      await Notification.findByIdAndUpdate(id, { read: true });
      res.json({ message: 'Marked as read' });
    } catch (error) {
      res.status(500).json({ message: 'Failed to update', error: error.message });
    }
  },

  markAllAsRead: async (req, res) => {
    try {
      const userId = req.user.userId;
      const role = req.user.role;

      await Notification.updateMany(
        {
          $or: [
            { userId: userId },
            { role: role },
            { role: 'all' }
          ]
        },
        { read: true }
      );

      res.json({ message: 'All marked as read' });
    } catch (error) {
      res.status(500).json({ message: 'Failed to update', error: error.message });
    }
  }
};

module.exports = notificationController;
