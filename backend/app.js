const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const fs = require("fs");
const https = require("https");
const morgan = require("morgan");

const authRoutes = require("./routes/auth");
const itemRoutes = require("./routes/items");
const locationRoutes = require("./routes/locations");
const { connect } = require("./config/mongoDB");
const { initWebSocketServer } = require("./utils/websocket");

dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/uploads", express.static("uploads"));

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/items", itemRoutes);
app.use("/api/locations", locationRoutes);

// MongoDB Connection
async function initializeMongoDB() {
    try {
        await connect();
        console.log("MongoDB connection initialized.");
    } catch (error) {
        console.error("Error initializing MongoDB connection:", error);
        process.exit(1);
    }
}

initializeMongoDB();

// Load SSL certificate and private key
const sslOptions = {
    key: fs.readFileSync("certificates/ufound-tech-private.key"),
    cert: fs.readFileSync("certificates/ufound-tech-certificate.crt"),
    ca: fs.readFileSync("certificates/ufound-tech-ca_bundle.crt")
};

// Start HTTPS server
const server = https.createServer(sslOptions, app).listen(process.env.PORT || 3000, () => {
    console.log(`HTTPS server running on port ${process.env.PORT || 3000}`);
});

// Initialize WebSocket Server
initWebSocketServer(server);
