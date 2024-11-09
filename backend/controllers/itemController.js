const AWS = require('aws-sdk');
const multer = require('multer');
const { v4: uuidv4 } = require('uuid');
const { getDatabase } = require('../config/mongoDB');

// AWS configuration using environment variables
AWS.config.update({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  region: process.env.AWS_REGION,
});

const s3 = new AWS.S3();

// Configure multer to store files in memory
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

exports.uploadImage = upload.single('image');

// Helper function to validate item data
function validateAddItemData(data) {
  if (typeof data.name !== "string" || data.name.trim() === "") return false;
  if (typeof data.description !== "string" || data.description.trim() === "") return false;
  if (typeof data.location !== "string" || data.location.trim() === "") return false;
  if (isNaN(parseInt(data.boxId))) return false;
  if (typeof data.email !== "string" || data.email.trim() === "") return false;
  if (typeof data.userName !== "string" || data.userName.trim() === "") return false;
  return true;
}

// Helper function to validate data for claiming an item
function validateClaimItemData(data) {
  if (typeof data.itemId !== "string" || data.itemId.trim() === "") return false;
  if (typeof data.email !== "string" || data.email.trim() === "") return false;
  if (typeof data.name !== "string" || data.name.trim() === "") return false;
  return true;
}

// Helper function to validate data for picking up an item
function validatePickupItemData(data) {
  return typeof data.itemId === 'string' && data.itemId.trim() !== "";
}

exports.addItem = async (req, res) => {
  if (!validateAddItemData(req.body)) {
    return res.status(400).json({
      status: "fail",
      message: "Invalid request inputs",
    });
  }

  const { name, description, location, boxId, email, userName, additionalNote } = req.body;
  const imageUrl = req.file ? req.file.path : null;

  try {
    const database = getDatabase();
    const locations = database.collection('Locations');

    // Check if an image is provided
    let imageUrl = null;
    if (req.file) {
      // Generate a unique filename
      const imageName = uuidv4() + '-' + req.file.originalname;

      // Prepare the params for S3 upload
      const params = {
        Bucket: process.env.S3_BUCKET_NAME, // Your bucket name
        Key: imageName,                     // File name you want to save as in S3
        Body: req.file.buffer,              // File buffer from multer
        ContentType: req.file.mimetype
      };

      // Uploading files to the bucket
      const uploadResult = await s3.upload(params).promise();
      imageUrl = uploadResult.Location; // The URL of the uploaded image
    }

    // Make sure the box is empty
    const existingDocument = await locations.findOne({
      location: location,
      boxes: {
        $elemMatch: {
          boxId: parseInt(boxId),
          containItem: true,
        }, // Check if the item field exists in this box
      },
    });

    if (existingDocument) {
      return res.status(400).json({
        status: "fail",
        message: `Box ${boxId} at ${location} already contains an item. Only one item is allowed per box.`,
      });
    }

    const item = {
      itemId: uuidv4(),
      name,
      description,
      additionalNote: additionalNote ? additionalNote : "",
      location,
      boxId,
      imageUrl,
      currentOwnerEmail: email,
      currentOwnerName: userName,
      isClaimed: false,
    };

    const result = await locations.updateOne(
        { location: location, 'boxes.boxId': parseInt(boxId) },
        {
          $set: {
            'boxes.$[box].item': item,
            'boxes.$[box].containItem': true,
          },
        },
        {
          arrayFilters: [{ 'box.boxId': parseInt(boxId) }],
        }
    );

    if (result) {
      return res.status(201).json({
        itemId: item.itemId,
        status: "success",
        message: `Item added to box ${boxId} at location ${location}`,
      });
    } else {
      return res.status(400).json({ status: "fail", message: "Invalid location or boxId" });
    }

    // TODO: Implement WebSocket notification for 'new item added'
  } catch (err) {
    res.status(400).json({ status: 'fail', message: err.message });
  }
};


exports.deleteItem = async (req, res) => {
  return;
};

exports.searchItems = async (req, res) => {
  try {
    const database = getDatabase();
    const locations = database.collection("Locations");

    const items = await locations
        .aggregate([
          {
            $unwind: "$boxes", // Deconstructs the `boxes` array so each box becomes a separate document
          },
          {
            $match: { "boxes.containItem": true }, // Filters for boxes that contain an item
          },
          {
            $replaceRoot: { newRoot: "$boxes.item" }, // Replaces the document root with the `item` field from each box
          },
        ])
        .toArray();

    if (!items) {
      return res.status(500).json({
        status: "fail",
        message: "server error",
      });
    }

    res.status(200).json({
      items,
      status: "success",
    });
  } catch (err) {
    res.status(500).json({ status: "fail", message: err.message });
  }
};

exports.claimItemToggle = async (req, res) => {
  if (!validateClaimItemData(req.body)) {
    return res.status(400).json({
      status: "fail",
      message: "Invalid request inputs",
    });
  }

  const { itemId, email, name } = req.body;

  try {
    const database = getDatabase();
    const locations = database.collection("Locations"); // Replace with your collection name

    // First, find the current value of isClaimed for the target item by itemId
    const document = await locations.findOne({
      "boxes.item.itemId": itemId,
    });

    if (!document) {
      return res.status(404).json({ status: "fail", message: "Item not found" });
    }

    // Find the specific box with the matching itemId to retrieve `isClaimed` status
    const box = document.boxes.find((b) => b.item && b.item.itemId === itemId);
    if (!box || !box.item) {
      return res.status(404).json({ status: "fail", message: "Box or item not found" });
    }

    const currentIsClaimed = box.item.isClaimed;

    // Toggle the isClaimed value
    const result = await locations.updateOne(
        { "boxes.item.itemId": itemId },
        {
          $set: {
            "boxes.$[box].item.isClaimed": !currentIsClaimed,
            "boxes.$[box].item.currentOwnerName": name,
            "boxes.$[box].item.currentOwnerEmail": email,
          },
        },
        {
          arrayFilters: [{ "box.item.itemId": itemId }],
        }
    );

    if (result.matchedCount === 0) {
      return res.status(404).json({ status: "fail", message: "Update failed, item not found" });
    }

    return res.status(200).json({
      newIsClaimedStatus: !currentIsClaimed,
      newOwnerName: name,
      newOwnerEmail: email,
      status: "success",
    });

    // TODO: Implement WebSocket notification for 'item claimed'
  } catch (err) {
    res.status(400).json({ status: "fail", message: err.message });
  }
};

exports.pickupItem = async (req, res) => {
  if (!validatePickupItemData(req.body)) {
    return res.status(400).json({
      status: "fail",
      message: "Invalid request inputs",
    });
  }

  const { itemId } = req.body;

  try {
    const database = getDatabase();
    const locations = database.collection("Locations");
    const pickedUpItems = database.collection("PickedUpItems");

    // Find the item in the Locations collection
    const document = await locations.findOne({
      "boxes.item.itemId": itemId,
    });

    if (!document) {
      return res.status(404).json({ status: "fail", message: "Item not found." });
    }

    // Locate the specific box containing the item with the matching itemId
    const box = document.boxes.find((b) => b.item && b.item.itemId === itemId);
    if (!box || !box.item) {
      return res.status(404).json({ status: "fail", message: "Item not found in the boxes." });
    }

    const item = box.item;

    // Insert the item into the PickedUpItems collection
    await pickedUpItems.insertOne({
      ...item,
      pickedUpAt: new Date(), // Optionally add a timestamp for when the item was moved
    });

    // Remove the item from the Locations collection
    const result = await locations.updateOne(
      { "boxes.item.itemId": itemId },
      {
        $set: {
          "boxes.$[box].item": null,
          "boxes.$[box].containItem": false,
        },
      },
      {
        arrayFilters: [{ "box.item.itemId": itemId }],
      }
    );

    if (result.modifiedCount > 0) {
      return res.status(200).json({
        itemId: item.itemId,
        status: "success",
        message: `Item moved to PickedUpItems collection successfully.`,
      });
    } else {
      return res.status(500).json({ status: "fail", message: "Failed to update the original location document." });
    }

    // TODO: Implement WebSocket notification for 'update status'
  } catch (err) {
    res.status(400).json({ status: "fail", message: err.message });
  }
};
