const express = require('express');
const router = express.Router();
const attendanceController = require('../controllers/attendanceController');
const auth = require('../middleware/auth');

router.post('/mark', auth, attendanceController.markAttendance);
router.get('/student/:studentId', auth, attendanceController.getStudentAttendance);
router.get('/overview/:studentId', auth, attendanceController.getAttendanceOverview);
router.post('/report-issue', auth, attendanceController.reportIssue);
router.get('/issues/pending', auth, attendanceController.getPendingIssues);
router.put('/resolve/:id', auth, attendanceController.resolveIssue);
router.get('/my-issues', auth, attendanceController.getMyIssues);

module.exports = router;
