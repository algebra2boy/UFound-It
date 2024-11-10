const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const bcrypt = require("bcrypt");
const nodemailer = require("nodemailer");
const { v4: uuidv4 } = require("uuid");
dotenv.config();

const { getDatabase } = require("../config/mongoDB");

const validatePreSignupData = (data) => {
  return typeof data.to === "string" && data.to.toLowerCase().endsWith("@umass.edu");
}

const validateSignupData = (data) => {
  if (typeof data.name !== "string" || data.name.trim() === "") return false;
  if (typeof data.email !== "string" || !data.email.toLowerCase().endsWith("@umass.edu")) return false;
  if (typeof data.password !== "string" || data.password.trim() === "") return false;
  if (typeof data.verificationCode !== "number" || !/^\d{4}$/.test(data.verificationCode.toString())) return false;
  return true;
};

const validateLoginData = (data) => {
  if (typeof data.email !== "string" || !data.email.toLowerCase().endsWith("@umass.edu")) return false;
  if (typeof data.password !== "string" || data.password.trim() === "") return false;
  return true;
}

// Set up the transporter
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.GMAIL_USER, // Your Gmail address
    pass: process.env.GMAIL_PASS, // Your Gmail app password or regular password (if less secure access is enabled)
  },
});

function generateVerificationCode() {
  return Math.floor(1000 + Math.random() * 9000); // Generates a number between 1000 and 9999
}

exports.preSignup = async (req, res) => {
  if (!validatePreSignupData(req.body)) {
    return res.status(400).json({ status: "fail", message: "Invalid UMass Email" });
  }

  const { to } = req.body;

  // Validate required fields
  if (!to) {
    return res.status(400).json({ status: "fail", message: "Missing email details" });
  }

  const database = getDatabase();
  const emailVerification = database.collection("EmailVerification");

  const verificationCode = generateVerificationCode();

  const verificationText = `
    Hi,

    Thank you for signing up for U Found It! To complete your registration and verify your email address, please use the verification code below:

    Your Verification Code: ${verificationCode}

    To proceed, enter this code in the signup form, and you'll be all set to access your new account.

    If you didn't sign up for U Found It or believe this email was sent in error, please ignore it.

    If you have any questions, feel free to reach out to us at codergeorge01@gmail.com.

    Best regards,
    The U Found It Team
  `;

  const subject = "Welcome to U Found It! Verify Your Email to Start Reuniting with Lost Items";

  const mailOptions = {
    from: process.env.GMAIL_USER,
    to,
    subject,
    text: verificationText,
  };

  try {
    const result = await emailVerification.updateOne({ email: to.toLowerCase() }, { $set: { code: verificationCode } }, { upsert: true });

    if (!result) {
      res.status(500).json({status: "fail", message: "Error storing verification code"});
    }

    const info = await transporter.sendMail(mailOptions);

    res.status(200).json({ status: "success", message: "Email sent successfully", info });
  } catch (error) {
    res.status(500).json({ status: "fail", message: "Error sending email", error });
  }
};

exports.signup = async (req, res) => {
  if (!validateSignupData(req.body)) {
    return res.status(400).json({ status: "fail", message: "Invalid request input" });
  }

  const { name, email, password, verificationCode } = req.body;

  try {
    const database = getDatabase(); // Retrieve the database instance
    const users = database.collection("Users");
    const emailVerification = database.collection("EmailVerification")

    const result = emailVerification.findOne({
      email,
      code: verificationCode
    })

    if (!result) {
      return res.status(400).json({ status: "fail", message: "Incorrect verification code" });
    }

    // Check if email already exists
    const existingUser = await users.findOne({ email: email.toLowerCase() });
    if (existingUser) {
      return res.status(400).json({ status: "fail", message: "Email already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const newUser = {
      userId: uuidv4(),
      name,
      email: email.toLowerCase(),
      password: hashedPassword, // Make sure to hash the password in a real application
    };
    await users.insertOne(newUser);

    res.status(201).json({
      userId: newUser.userId,
      status: "success",
      message: "Account created successfully",
    });
  } catch (err) {
    res.status(400).json({ status: "fail", message: err.message });
  }
};

exports.login = async (req, res) => {
  if (!validateLoginData(req.body)) {
    return res.status(400).json({ status: "fail", message: "Invalid request input" });
  }

  const { email, password } = req.body;

  try {
    const database = getDatabase();
    const users = database.collection("Users"); // Using the "User" collection

    // Check if the user exists
    const user = await users.findOne({ email: email.toLowerCase() });
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

    res.status(200).json({
      userId: user.userId,
      name: user.name,
      email: user.email,
      token,
      status: "success",
    });
  } catch (err) {
    res.status(500).json({ status: "fail", message: err.message });
  }
};
