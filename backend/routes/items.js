const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/authMiddleware');
const itemController = require('../controllers/itemController');

// This is what the final router should be
// router.post('/add', authMiddleware, itemController.uploadImage, itemController.addItem);

// This is the testing version (no image is uploaded and no user verification is needed)
router.post('/add', itemController.addItem); 

router.post('/delete', authMiddleware, itemController.deleteItem);
router.get('/search', itemController.searchItems);
router.post('/claim', authMiddleware, itemController.claimItem);
router.post('/pickup', authMiddleware, itemController.pickupItem);
router.put('/updateStatus', authMiddleware, itemController.updateStatus);

module.exports = router;