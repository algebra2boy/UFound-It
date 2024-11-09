const Item = require('../models/Item');
const multer = require('multer');
const {v4: uuidv4} = require('uuid');

// Configure multer for file uploads
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // Make sure this directory exists
    },
    filename: function (req, file, cb) {
        cb(null, uuidv4() + '-' + file.originalname);
    },
});
const upload = multer({storage: storage});

exports.uploadImage = upload.single('image');

exports.addItem = async (req, res) => {
    const {description, location, boxId, email} = req.body;
    const imageUrl = req.file ? req.file.path : null;

    try {
        const item = await Item.create({
            itemId: uuidv4(),
            imageUrl,
            description,
            location,
            boxId,
            email,
        });

        res.status(201).json({
            itemId: item.itemId,
            status: 'success',
            message: 'Item added successfully',
        });

        // TODO: Implement WebSocket notification for 'new item added'
    } catch (err) {
        res.status(400).json({status: 'fail', message: err.message});
    }
};

exports.deleteItem = async (req, res) => {
    const {email, itemId} = req.body;

    try {
        const item = await Item.findOneAndDelete({itemId, email});

        if (!item) {
            return res.status(400).json({status: 'fail', message: 'Item not found or unauthorized'});
        }

        res.status(200).json({
            itemId: item.itemId,
            status: 'success',
            message: 'Item deleted successfully',
        });
    } catch (err) {
        res.status(400).json({status: 'fail', message: err.message});
    }
};

exports.searchItems = async (req, res) => {
    try {
        const items = await Item.find({status: 'unclaimed'});
        res.status(200).json({
            items,
            status: 'success',
        });
    } catch (err) {
        res.status(500).json({status: 'fail', message: err.message});
    }
};

exports.claimItem = async (req, res) => {
    const {itemId} = req.body;

    try {
        const item = await Item.findOne({itemId});

        if (!item || item.status !== 'unclaimed') {
            return res.status(400).json({status: 'fail', message: 'Item is already claimed or not found'});
        }

        item.status = 'claimed';
        await item.save();

        res.status(200).json({
            status: 'success',
            message: 'Item has been claimed successfully',
        });

        // TODO: Implement WebSocket notification for 'item claimed'
    } catch (err) {
        res.status(400).json({status: 'fail', message: err.message});
    }
};

exports.pickupItem = async (req, res) => {
    const {itemId} = req.body;

    try {
        const item = await Item.findOne({itemId});

        if (!item || item.status !== 'claimed') {
            return res.status(400).json({status: 'fail', message: 'Item is not claimed yet or not found'});
        }

        item.status = 'picked up';
        await item.save();

        res.status(200).json({
            status: 'success',
            message: 'Item has been picked up successfully',
        });

        // TODO: Implement WebSocket notification for 'update status'
    } catch (err) {
        res.status(400).json({status: 'fail', message: err.message});
    }
};

exports.updateStatus = async (req, res) => {
    const {itemId} = req.body;
    const {status} = req.body;

    if (!['unclaimed', 'claimed', 'picked up'].includes(status)) {
        return res.status(400).json({status: 'fail', message: 'Invalid status value'});
    }

    try {
        const item = await Item.findOneAndUpdate({itemId}, {status}, {new: true});

        if (!item) {
            return res.status(400).json({status: 'fail', message: 'Item not found'});
        }

        res.status(200).json({
            status: 'success',
            message: 'Item status updated',
        });

        // TODO: Implement WebSocket notification for 'update status'
    } catch (err) {
        res.status(400).json({status: 'fail', message: err.message});
    }
};