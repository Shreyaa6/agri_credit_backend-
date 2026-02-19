const express = require('express');
const router = express.Router();
const farmController = require('../controllers/farmController');

// POST /api/v1/farm/add - Add new farm
router.post('/add', farmController.addFarm);

// GET /api/v1/farm/:farmer_id - Get all farms for a farmer
router.get('/:farmer_id', farmController.getFarmsByFarmer);

// GET /api/v1/farm/details/:farm_id - Get specific farm details
router.get('/details/:farm_id', farmController.getFarmDetails);

module.exports = router;
