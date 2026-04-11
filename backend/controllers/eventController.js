const Event = require('../models/Event');
const Notification = require('../models/Notification');

const eventController = {
  createEvent: async (req, res) => {
    try {
      const { title, description, date, venue, maxParticipants } = req.body;

      const event = new Event({
        title,
        description,
        date,
        venue,
        maxParticipants
      });
      await event.save();

      const notification = new Notification({
        role: 'student',
        type: 'event',
        title: 'New Event',
        message: `New event: ${title} on ${new Date(date).toLocaleDateString()}`
      });
      await notification.save();

      res.status(201).json({ message: 'Event created', event });
    } catch (error) {
      res.status(500).json({ message: 'Failed to create event', error: error.message });
    }
  },

  getEvents: async (req, res) => {
    try {
      const events = await Event.find().sort({ date: 1 });
      res.json(events);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get events', error: error.message });
    }
  },

  registerForEvent: async (req, res) => {
    try {
      const { eventId } = req.params;
      const userId = req.user.userId;

      const event = await Event.findById(eventId);
      if (!event) {
        return res.status(404).json({ message: 'Event not found' });
      }

      if (event.registeredUsers.includes(userId)) {
        return res.status(400).json({ message: 'Already registered' });
      }

      if (event.maxParticipants && event.registeredUsers.length >= event.maxParticipants) {
        return res.status(400).json({ message: 'Event is full' });
      }

      event.registeredUsers.push(userId);
      await event.save();

      res.json({ message: 'Registered successfully', event });
    } catch (error) {
      res.status(500).json({ message: 'Failed to register', error: error.message });
    }
  },

  getMyEvents: async (req, res) => {
    try {
      const events = await Event.find({ registeredUsers: req.user.userId })
        .sort({ date: 1 });
      res.json(events);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get events', error: error.message });
    }
  }
};

module.exports = eventController;
