const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const bcrypt = require("bcrypt");
dotenv.config();

const { getDatabase } = require("../config/mongoDB");

exports.signup = async (req, res) => {
  const { name, email, password } = req.body;

  try {
    const database = getDatabase(); // Retrieve the database instance
    const usersCollection = database.collection("Users");

    // Check if email already exists
    const existingUser = await usersCollection.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ status: "fail", message: "Email already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const newUser = {
      name,
      email,
      password: hashedPassword, // Make sure to hash the password in a real application
    };
    await usersCollection.insertOne(newUser);

    res.status(201).json({
      email: newUser.email,
      status: "success",
      message: "Account created. Please verify your email.",
    });
  } catch (err) {
    res.status(400).json({ status: "fail", message: err.message });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const database = getDatabase();
    const usersCollection = database.collection("Users"); // Using the "User" collection

    // Check if the user exists
    const user = await usersCollection.findOne({ email });
    if (!user) {
      return res.status(401).json({ status: "fail", message: "Invalid email or password" });
    }

    // Compare passwords
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ status: "fail", message: "Invalid email or password" });
    }

    // Generate JWT token
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: "1h" });
    const name = user.name;

    res.status(200).json({
      name,
      email: user.email,
      token,
      status: "success",
    });
  } catch (err) {
    res.status(500).json({ status: "fail", message: err.message });
  }
};
