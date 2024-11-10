// config/mongoDB.js
const { MongoClient, ServerApiVersion } = require("mongodb");
const uri = process.env.MONGODB_URI;

let client;
let database;

async function connect() {
  if (!client) {
    client = new MongoClient(uri, {
      serverApi: {
        version: ServerApiVersion.v1,
        strict: true,
        deprecationErrors: true,
      },
    });
    await client.connect();
    database = client.db("UFoundItDB"); // Initialize your main database here
    console.log("Connected to MongoDB successfully!");
  }
  return client;
}

function getDatabase() {
  if (!database) {
    throw new Error("Database connection is not initialized.");
  }
  return database;
}

module.exports = { connect, getDatabase };
