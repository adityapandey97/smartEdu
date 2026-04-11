const express = require('express');
const router = express.Router();
const leaveController = require('../controllers/leaveController');
const auth = require('../middleware/auth');

router.post('/apply', auth, leaveController.applyLeave);
router.get('/my-applications', auth, leaveController.getMyApplications);
router.get('/all', auth, leaveController.getAllApplications);
router.put('/review/:id', auth, leaveController.reviewApplication);

module.exports = router;
