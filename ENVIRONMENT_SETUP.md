# 🔄 Environment Configuration Guide

## Quick Environment Switching

Your backend is now configured with **centralized environment management**. You only need to change the API URL in **ONE PLACE** to switch between local development and production.

## 🎯 How to Switch Environments

### Option 1: Change in `.env` file (Recommended)

Open `.env` file and modify the `API_BASE_URL` line:

**For Production (Vercel):**
```env
API_BASE_URL=https://agricreditbackend.vercel.app
# API_BASE_URL=http://localhost:3000
```

**For Local Development:**
```env
# API_BASE_URL=https://agricreditbackend.vercel.app
API_BASE_URL=http://localhost:3000
```

### Option 2: Use Environment Variable

Run your app with the environment variable:

```bash
# For production
API_BASE_URL=https://agricreditbackend.vercel.app npm run dev

# For local
API_BASE_URL=http://localhost:3000 npm run dev
```

## 📁 Centralized Configuration

All environment variables are managed in **one place**:

```
src/config/environment.js
```

This file exports a `config` object used throughout the application:

```javascript
const config = require('./config/environment');

// Use anywhere in your code
console.log(config.API_BASE_URL);
console.log(config.SUPABASE_URL);
console.log(config.JWT_SECRET);
```

## 🌍 Current Deployment URLs

### Production (Vercel)
```
https://agricreditbackend.vercel.app
```

**Test it:**
```bash
curl https://agricreditbackend.vercel.app/
```

### Local Development
```
http://localhost:3000
```

**Test it:**
```bash
curl http://localhost:3000/
```

## 📋 Complete Environment Variables

Here's what you need in your `.env` file:

```env
# 🔄 API Configuration - CHANGE THIS ONE LINE
API_BASE_URL=https://agricreditbackend.vercel.app

# Supabase Configuration
SUPABASE_URL=https://wfhjhclkjttaquzdbibx.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# Redis Configuration (Optional)
REDIS_URL=redis://localhost:6379
ENABLE_REDIS=false

# Server Configuration
PORT=3000
NODE_ENV=development

# JWT Configuration
JWT_SECRET=agri-credit-secret-key-2026
```

## 🔧 Files Modified for Centralized Config

1. ✅ `src/config/environment.js` - Central config file (NEW)
2. ✅ `src/index.js` - Uses centralized config
3. ✅ `src/config/supabase.js` - Uses centralized config
4. ✅ `src/config/redis.js` - Uses centralized config
5. ✅ `.env` - Added API_BASE_URL

## 🚀 Quick Start Commands

### Start Local Development
```bash
npm run dev
```

### Test Production API
```bash
# Test root endpoint
curl https://agricreditbackend.vercel.app/

# Test login
curl -X POST https://agricreditbackend.vercel.app/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"mobile_number":"9876543210","password":"test123"}'

# Test weather data
curl https://agricreditbackend.vercel.app/api/v1/validation/weather/FARM1000
```

## 📱 Frontend Integration

When building a frontend, import the base URL from your config:

**React/Next.js Example:**
```javascript
// config/api.js
export const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 
  'https://agricreditbackend.vercel.app';

// Usage
import { API_BASE_URL } from './config/api';

const response = await fetch(`${API_BASE_URL}/api/v1/auth/login`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ mobile_number, password })
});
```

**React Native Example:**
```javascript
// config/api.js
const API_BASE_URL = __DEV__ 
  ? 'http://localhost:3000'  // Development
  : 'https://agricreditbackend.vercel.app';  // Production

export default API_BASE_URL;
```

## 🔄 Environment Detection

The app automatically detects the environment:

```javascript
const config = require('./config/environment');

if (config.isDevelopment) {
  console.log('Running in development mode');
}

if (config.isProduction) {
  console.log('Running in production mode');
}
```

## 🎨 Benefits of This Setup

✅ **Single Source of Truth** - Change URL in one place  
✅ **Easy Switching** - Comment/uncomment one line  
✅ **Environment Detection** - Auto-detects dev/prod  
✅ **Type Safety** - All config in one object  
✅ **Frontend Ready** - Easy to integrate with React/React Native  
✅ **Clean Code** - No more `process.env` everywhere  

## 🔐 Security Notes

1. **Never commit `.env`** to git (already in `.gitignore`)
2. **Use different JWT secrets** for dev/prod
3. **Keep Supabase keys secure**
4. **Use service role key only on backend**

## 📝 Vercel Environment Variables

Your production environment variables are set in Vercel:

1. Go to https://vercel.com/dashboard
2. Select your project: `agricreditbackend`
3. Go to Settings → Environment Variables
4. Add:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `JWT_SECRET`
   - `NODE_ENV=production`
   - `API_BASE_URL=https://agricreditbackend.vercel.app`

## 🧪 Testing Both Environments

**Test Local:**
```bash
# Start local server
npm run dev

# Test in another terminal
curl http://localhost:3000/
```

**Test Production:**
```bash
# No server needed, just test
curl https://agricreditbackend.vercel.app/
```

## 🎯 Summary

**To switch from Production → Local:**
1. Open `.env`
2. Change `API_BASE_URL=http://localhost:3000`
3. Save and restart server

**To switch from Local → Production:**
1. Open `.env`
2. Change `API_BASE_URL=https://agricreditbackend.vercel.app`
3. Save and restart server

That's it! One line change, everywhere updated! 🎉
