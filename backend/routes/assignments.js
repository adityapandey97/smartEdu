const express = require('express');
const router = express.Router();
const assignmentController = require('../controllers/assignmentController');
const auth = require('../middleware/auth');

router.post('/create', auth, assignmentController.createAssignment);
router.get('/', auth, assignmentController.getAssignments);
router.get('/:id', auth, assignmentController.getAssignment);
router.post('/submit', auth, assignmentController.submitAssignment);
router.get('/submissions/:assignmentId', auth, assignmentController.getSubmissions);
router.get('/my-submissions', auth, assignmentController.getMySubmissions);
router.get('/pending', auth, assignmentController.getPendingAssignments);

module.exports = router;
