const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();
const config = require('./environment');

const supabaseUrl = config.SUPABASE_URL;
const supabaseKey = config.SUPABASE_SERVICE_ROLE_KEY || config.SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error('❌ Missing Supabase URL or Key');
} else if (config.isDevelopment) {
    console.log('✅ Supabase connected');
}

const supabase = createClient(supabaseUrl, supabaseKey);

module.exports = supabase;
