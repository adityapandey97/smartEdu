const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');
const auth = require('../middleware/auth');

router.post('/create', auth, eventController.createEvent);
router.get('/', auth, eventController.getEvents);
router.post('/register/:eventId', auth, eventController.registerForEvent);
router.get('/my-events', auth, eventController.getMyEvents);

module.exports = router;
