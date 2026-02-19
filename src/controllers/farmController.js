const supabase = require('../config/supabase');

/**
 * @route   POST /api/v1/farm/add
 * @desc    Add a new farm for a farmer
 * @access  Public (should be protected in production)
 */
exports.addFarm = async (req, res) => {
    try {
        const {
            farmer_id,
            land_size_acres,
            gps_lat,
            gps_long,
            state,
            district,
            village,
            irrigation_type,
            soil_type
        } = req.body;

        // Validation: Check if required fields are provided
        if (!farmer_id || !land_size_acres || !state || !district) {
            return res.status(400).json({
                error: 'Missing required fields',
                message: 'farmer_id, land_size_acres, state, and district are required'
            });
        }

        // Validate land size is a positive number
        if (isNaN(land_size_acres) || parseFloat(land_size_acres) <= 0) {
            return res.status(400).json({
                error: 'Invalid land size',
                message: 'land_size_acres must be a positive number'
            });
        }

        // Validate GPS coordinates if provided
        if (gps_lat && (isNaN(gps_lat) || gps_lat < -90 || gps_lat > 90)) {
            return res.status(400).json({
                error: 'Invalid GPS latitude',
                message: 'gps_lat must be between -90 and 90'
            });
        }

        if (gps_long && (isNaN(gps_long) || gps_long < -180 || gps_long > 180)) {
            return res.status(400).json({
                error: 'Invalid GPS longitude',
                message: 'gps_long must be between -180 and 180'
            });
        }

        // Check if farmer exists
        const { data: farmer, error: farmerError } = await supabase
            .from('farmers')
            .select('farmer_id, full_name')
            .eq('farmer_id', farmer_id)
            .single();

        if (farmerError || !farmer) {
            return res.status(404).json({
                error: 'Farmer not found',
                message: `No farmer found with ID: ${farmer_id}`
            });
        }

        // Generate unique farm_id
        const { data: seqData } = await supabase
            .rpc('get_next_farm_id');
        
        let farm_id;
        if (seqData) {
            farm_id = `FARM${seqData}`;
        } else {
            // Fallback: generate from timestamp if sequence fails
            farm_id = `FARM${Date.now().toString().slice(-6)}`;
        }

        // Insert farm into database
        const { data: newFarm, error: insertError } = await supabase
            .from('farms')
            .insert([{
                farm_id,
                farmer_id,
                land_size_acres: parseFloat(land_size_acres),
                gps_lat: gps_lat ? parseFloat(gps_lat) : null,
                gps_long: gps_long ? parseFloat(gps_long) : null,
                state,
                district,
                village: village || null,
                irrigation_type: irrigation_type || null,
                soil_type: soil_type || null
            }])
            .select()
            .single();

        if (insertError) {
            console.error('Insert Error:', insertError);
            throw insertError;
        }

        // Return success response
        return res.status(201).json({
            message: 'Farm added successfully',
            farm_id: newFarm.farm_id,
            farmer_name: farmer.full_name,
            land_size_acres: newFarm.land_size_acres,
            location: {
                state: newFarm.state,
                district: newFarm.district,
                village: newFarm.village
            }
        });

    } catch (error) {
        console.error('Add Farm Error:', error);
        return res.status(500).json({
            error: 'Failed to add farm',
            message: error.message
        });
    }
};

/**
 * @route   GET /api/v1/farm/:farmer_id
 * @desc    Get all farms for a farmer
 * @access  Public
 */
exports.getFarmsByFarmer = async (req, res) => {
    try {
        const { farmer_id } = req.params;

        if (!farmer_id) {
            return res.status(400).json({
                error: 'Missing farmer_id',
                message: 'farmer_id is required'
            });
        }

        // Get all farms for the farmer
        const { data: farms, error } = await supabase
            .from('farms')
            .select('*')
            .eq('farmer_id', farmer_id)
            .order('created_at', { ascending: false });

        if (error) {
            throw error;
        }

        return res.status(200).json({
            farmer_id,
            total_farms: farms.length,
            farms
        });

    } catch (error) {
        console.error('Get Farms Error:', error);
        return res.status(500).json({
            error: 'Failed to fetch farms',
            message: error.message
        });
    }
};

/**
 * @route   GET /api/v1/farm/details/:farm_id
 * @desc    Get details of a specific farm
 * @access  Public
 */
exports.getFarmDetails = async (req, res) => {
    try {
        const { farm_id } = req.params;

        if (!farm_id) {
            return res.status(400).json({
                error: 'Missing farm_id',
                message: 'farm_id is required'
            });
        }

        // Get farm details with farmer information
        const { data: farm, error } = await supabase
            .from('farms')
            .select(`
                *,
                farmers:farmer_id (
                    farmer_id,
                    full_name,
                    mobile_number,
                    state,
                    district,
                    village
                )
            `)
            .eq('farm_id', farm_id)
            .single();

        if (error || !farm) {
            return res.status(404).json({
                error: 'Farm not found',
                message: `No farm found with ID: ${farm_id}`
            });
        }

        return res.status(200).json({
            farm
        });

    } catch (error) {
        console.error('Get Farm Details Error:', error);
        return res.status(500).json({
            error: 'Failed to fetch farm details',
            message: error.message
        });
    }
};
