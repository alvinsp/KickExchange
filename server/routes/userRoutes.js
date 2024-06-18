const express = require('express');
const router = express.Router();
const upload = require('../middlewares/uploadMiddleware');
const { uploadImage, getProfile } = require('../controllers/userController');
const authMiddleware = require('../middlewares/authMiddleware');

router.get('/profile', authMiddleware, getProfile)
router.patch('/upload', authMiddleware, upload.single('file'), uploadImage);

module.exports = router;