const mongoose = require('mongoose');

const itemSchema = new mongoose.Schema({
    itemId: {
        type: String,
        unique: true,
        required: true,
    },
    imageUrl: String,
    description: String,
    location: String,
    boxId: Number,
    email: String,
    status: {
        type: String,
        enum: ['unclaimed', 'claimed', 'picked up'],
        default: 'unclaimed',
    },
    dateFound: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('Item', itemSchema);