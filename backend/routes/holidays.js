const express = require('express');
const router = express.Router();
const holidayController = require('../controllers/holidayController');
const auth = require('../middleware/auth');

router.post('/create', auth, holidayController.createHoliday);
router.get('/', auth, holidayController.getHolidays);
router.get('/check', auth, holidayController.checkHoliday);

module.exports = router;
