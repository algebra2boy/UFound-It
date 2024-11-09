const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/authMiddleware');
const itemController = require('../controllers/itemController');

router.post('/add', authMiddleware, itemController.uploadImage, itemController.addItem);
router.post('/delete', authMiddleware, itemController.deleteItem);
router.get('/search', itemController.searchItems);
router.post('/claim', authMiddleware, itemController.claimItem);
router.post('/pickup', authMiddleware, itemController.pickupItem);
router.put('/updateStatus', authMiddleware, itemController.updateStatus);

module.exports = router;