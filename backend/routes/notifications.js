const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');
const auth = require('../middleware/auth');

router.post('/create', auth, notificationController.createNotification);
router.get('/', auth, notificationController.getNotifications);
router.get('/unread-count', auth, notificationController.getUnreadCount);
router.put('/read/:id', auth, notificationController.markAsRead);
router.put('/read-all', auth, notificationController.markAllAsRead);

module.exports = router;
