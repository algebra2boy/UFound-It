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

exports.addItem = async (req, res) => {
  const {
    name,
    description,
    location,
    boxId,
    email,
    userName,
    additionalNote,
  } = req.body;

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

    const item = {
      itemId: uuidv4(),
      name,
      description,
      additionalNote,
      location,
      boxId,
      imageUrl,
      currentOwnerEmail: email,
      currentOwnerName: userName,
      isClaimed: false,
      isPickedUp: false,
    };

    console.log(req.body)

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

    if (result.matchedCount === 0) {
      return res.status(400).json({ status: 'fail', message: 'Invalid location or boxId' });
    }

    res.status(201).json({
      itemId: item.itemId,
      status: 'success',
      message: `Item added to box ${boxId} at location ${location}`,
    });

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
    const database = getDatabase()
    const locations = database.collection("Locations")

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
      res.status(500).json({
        status: "fail",
        message: "server error"
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

    res.status(200).json({
      newIsClaimedStatus: !currentIsClaimed,
      newOwnerName: name,
      newOwnerEmail: email,
      status: "success",
    });

    // item.status = "claimed";
    // await item.save();

    // res.status(200).json({
    //   status: "success",
    //   message: "Item has been claimed successfully",
    // });

    // TODO: Implement WebSocket notification for 'item claimed'
  } catch (err) {
    res.status(400).json({ status: "fail", message: err.message });
  }
};

exports.pickupItem = async (req, res) => {
  const { itemId } = req.body;

  try {
    const item = await Item.findOne({ itemId });

    if (!item || item.status !== "claimed") {
      return res.status(400).json({ status: "fail", message: "Item is not claimed yet or not found" });
    }

    item.status = "picked up";
    await item.save();

    res.status(200).json({
      status: "success",
      message: "Item has been picked up successfully",
    });

    // TODO: Implement WebSocket notification for 'update status'
  } catch (err) {
    res.status(400).json({ status: "fail", message: err.message });
  }
};

exports.updateStatus = async (req, res) => {
  const { itemId } = req.body;
  const { status } = req.body;

  if (!["unclaimed", "claimed", "picked up"].includes(status)) {
    return res.status(400).json({ status: "fail", message: "Invalid status value" });
  }

  try {
    const item = await Item.findOneAndUpdate({ itemId }, { status }, { new: true });

    if (!item) {
      return res.status(400).json({ status: "fail", message: "Item not found" });
    }

    res.status(200).json({
      status: "success",
      message: "Item status updated",
    });

    // TODO: Implement WebSocket notification for 'update status'
  } catch (err) {
    res.status(400).json({ status: "fail", message: err.message });
  }
};
