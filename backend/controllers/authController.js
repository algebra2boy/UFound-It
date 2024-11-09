const User = require('../models/User');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
dotenv.config();

exports.signup = async (req, res) => {
    const {email, password} = req.body;
    try {
        // Check if email already exists
        if (await User.findOne({email})) {
            return res.status(400).json({status: 'fail', message: 'Email already exists'});
        }

        const user = await User.create({email, password});
        res.status(201).json({
            email: user.email,
            status: 'success',
            message: 'Account created. Please verify your email.',
        });
    } catch (err) {
        res.status(400).json({status: 'fail', message: err.message});
    }
};

exports.login = async (req, res) => {
    const {email, password} = req.body;
    try {
        const user = await User.findOne({email});
        if (!user || !(await user.comparePassword(password))) {
            return res.status(401).json({status: 'fail', message: 'Invalid email or password'});
        }

        const token = jwt.sign({id: user._id}, process.env.JWT_SECRET, {expiresIn: '1h'});

        res.status(200).json({
            email: user.email,
            token,
            status: 'success',
        });
    } catch (err) {
        res.status(500).json({status: 'fail', message: err.message});
    }
};