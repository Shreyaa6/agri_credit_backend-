/**
 * Centralized Environment Configuration
 * Change API_BASE_URL here to switch between local and production
 */

const config = {
  // 🔄 CHANGE THIS ONE LINE TO SWITCH ENVIRONMENTS
  API_BASE_URL: process.env.API_BASE_URL || 'https://agricreditbackend.vercel.app',
  
  // Alternative: Use local development
  // API_BASE_URL: process.env.API_BASE_URL || 'http://localhost:3000',
  
  // Supabase Configuration
  SUPABASE_URL: process.env.SUPABASE_URL,
  SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY,
  SUPABASE_SERVICE_ROLE_KEY: process.env.SUPABASE_SERVICE_ROLE_KEY,
  
  // Redis Configuration
  REDIS_URL: process.env.REDIS_URL,
  
  // JWT Configuration
  JWT_SECRET: process.env.JWT_SECRET || 'agri-credit-secret-key-2026',
  JWT_EXPIRES_IN: '7d',
  
  // Server Configuration
  PORT: process.env.PORT || 3000,
  NODE_ENV: process.env.NODE_ENV || 'development',
  
  // API Configuration
  API_VERSION: 'v1',
  API_PREFIX: '/api/v1',
  
  // Environment Detection
  isDevelopment: process.env.NODE_ENV === 'development',
  isProduction: process.env.NODE_ENV === 'production',
  isTest: process.env.NODE_ENV === 'test',
  
  // CORS Configuration
  CORS_ORIGIN: process.env.CORS_ORIGIN || '*',
  
  // Feature Flags
  ENABLE_REDIS: process.env.ENABLE_REDIS === 'true' || false,
  ENABLE_LOGGING: process.env.ENABLE_LOGGING === 'true' || true,
};

// Log current environment on startup (only in development)
if (config.isDevelopment) {
  console.log('🌍 Environment Configuration:');
  console.log(`  API Base URL: ${config.API_BASE_URL}`);
  console.log(`  Environment: ${config.NODE_ENV}`);
  console.log(`  Port: ${config.PORT}`);
}

module.exports = config;
