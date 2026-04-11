const express = require('express');
const router = express.Router();
const materialController = require('../controllers/materialController');
const auth = require('../middleware/auth');

router.post('/upload', auth, materialController.uploadMaterial);
router.get('/', auth, materialController.getMaterials);
router.get('/subject/:subject', auth, materialController.getMaterialsBySubject);

module.exports = router;
