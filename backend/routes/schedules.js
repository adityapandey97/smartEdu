const express = require('express');
const router = express.Router();
const scheduleController = require('../controllers/scheduleController');
const auth = require('../middleware/auth');

router.post('/create', auth, scheduleController.createSchedule);
router.get('/', auth, scheduleController.getSchedule);
router.post('/substitute', auth, scheduleController.setSubstitute);

module.exports = router;
