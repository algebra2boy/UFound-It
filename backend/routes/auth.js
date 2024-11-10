const express = require('express');
const router = express.Router();
const {signup, login, preSignup} = require('../controllers/authController');

router.post('/signup', signup);
router.post('/login', login);
router.post('/presignup', preSignup)

module.exports = router;