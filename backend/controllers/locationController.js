const { v4: uuidv4 } = require("uuid");

const { getDatabase } = require("../config/mongoDB");

exports.add = async (req, res) => {
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
    res.status(201).json({
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