const redis = require('redis');
require('dotenv').config();
const config = require('./environment');

const redisClient = redis.createClient({
    url: config.REDIS_URL || 'redis://localhost:6379',
    socket: {
        reconnectStrategy: (retries) => {
            if (retries > 5) {
                return new Error('Redis connection failed');
            }
            return Math.min(retries * 100, 3000);
        }
    }
});

redisClient.on('error', (err) => {
    // Suppress connection errors to avoid terminal clutter when Redis isn't running
    const isConnRefused = err.code === 'ECONNREFUSED' ||
        (err.errors && err.errors.some(e => e.code === 'ECONNREFUSED'));

    if (isConnRefused) return;

    console.error('Redis Client Error', err);
});

(async () => {
    try {
        if (config.ENABLE_REDIS) {
            await redisClient.connect();
            console.log('✅ Connected to Redis (Optional Caching Enabled)');
        } else if (config.isDevelopment) {
            console.log('ℹ️  Redis disabled (optional)');
        }
    } catch (err) {
        // Silently continue - caching is optional
    }
})();

module.exports = redisClient;
