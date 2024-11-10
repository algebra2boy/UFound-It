const { v4: uuidv4 } = require("uuid");

const { getDatabase } = require("../config/mongoDB");

// Helper function to validate data for adding a location
function validateAddLocationData(data) {
  if (typeof data.location !== "string" || data.location.trim() === "") return false;
  if (typeof lat === 'number' && lat >= -90 && lat <= 90) return false;
  if (typeof long === "number" && long >= -180 && long <= 180) return false;
  return true;
}

exports.add = async (req, res) => {
  if (!validateAddLocationData(req.body)) {
    return res.status(400).json({
      status: "fail",
      message: "Invalid request inputs",
    });
  }

  const { location, lat, long } = req.body;

  try {
    const database = getDatabase();
    const locations = database.collection("Locations");

    const boxes = Array.from({ length: 10 }, (_, index) => ({
      id: uuidv4(),
      boxId: index + 1,
      item: null,
      containItem: false,
    }));

    const newLocation = {
      location,
      lat,
      long,
      boxes,
    };

    await locations.insertOne(newLocation);

    res.status(201).json({
      location,
      lat,
      long,
      status: "success",
      message: "Location created.",
    });
  } catch {
    res.status(400).json({ status: "fail", message: err.message });
  }
};

exports.list = async (req, res) => {
  try {
    const database = getDatabase();
    const locations = database.collection("Locations");

    const locationDocuments = await locations.find({}).toArray();
    res.status(200).json({
      locations: locationDocuments.map((locationDoc) => ({
        location: locationDoc.location,
        lat: locationDoc.lat,
        long: locationDoc.long
      })),
      status: "success",
    });

  } catch (err) {
    res.status(400).json({ status: "fail", message: err.message });
  }
}