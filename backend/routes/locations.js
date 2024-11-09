const express = require("express");
const router = express.Router();
const locationController = require("../controllers/locationController");

router.post("/add", locationController.add);

module.exports = router;
