const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const authRoutes = require("./routes/auth");
const itemRoutes = require("./routes/items");
const locationRoutes = require("./routes/locations")
const { connect } = require("./config/mongoDB"); // Only importing `connect` to initialize MongoDB connection
const { initWebSocketServer } = require("./utils/websocket");

dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/uploads", express.static("uploads")); // Serve uploaded images

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/items", itemRoutes);
app.use("/api/locations", locationRoutes);

// MongoDB Connection
async function initializeMongoDB() {
  try {
    await connect(); // Establish MongoDB connection on server startup
    console.log("MongoDB connection initialized.");
  } catch (error) {
    console.error("Error initializing MongoDB connection:", error);
    process.exit(1); // Exit if MongoDB connection fails
  }
}

initializeMongoDB();

// Start Server
const server = app.listen(process.env.PORT || 3000, () => console.log(`Server running on port ${process.env.PORT || 3000}`));

// Initialize WebSocket Server
initWebSocketServer(server);
