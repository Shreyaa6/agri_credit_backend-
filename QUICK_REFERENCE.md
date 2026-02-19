# 🚀 Quick Reference - Environment Switching

## ⚡ ONE-LINE CHANGE TO SWITCH ENVIRONMENTS

### Current Setup:
- **Production URL**: `https://agricreditbackend.vercel.app`
- **Local URL**: `http://localhost:3000`

---

## 🔄 How to Switch (2 Steps)

### 1️⃣ Open `.env` file
### 2️⃣ Change ONE line:

```env
# For PRODUCTION (Vercel)
API_BASE_URL=https://agricreditbackend.vercel.app

# For LOCAL Development
# API_BASE_URL=http://localhost:3000
```

**That's it!** All code automatically uses this URL.

---

## 📱 Test Commands

### Test Production
```bash
curl https://agricreditbackend.vercel.app/
```

### Test Local
```bash
npm run dev
curl http://localhost:3000/
```

---

## 🎯 Where the Magic Happens

All configuration is in:
```
src/config/environment.js
```

All other files import from here:
```javascript
const config = require('./config/environment');
console.log(config.API_BASE_URL);  // Uses .env value
```

---

## 📊 What Gets Changed Automatically

✅ API Base URL  
✅ All endpoint calls  
✅ Environment detection  
✅ Logging behavior  
✅ CORS settings  
✅ Port configuration  

---

## 🎨 Visual Guide

```
┌─────────────────────────────────────────┐
│           .env File                     │
│  API_BASE_URL=https://...vercel.app    │ ◄── CHANGE THIS
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│     src/config/environment.js           │ ◄── READS THIS
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│  All files automatically use config     │ ◄── USES EVERYWHERE
│  - index.js                             │
│  - supabase.js                          │
│  - redis.js                             │
│  - All controllers                      │
└─────────────────────────────────────────┘
```

---

## 🎁 Bonus: Frontend Integration

**React/Next.js:**
```javascript
const API_URL = 'https://agricreditbackend.vercel.app';
fetch(`${API_URL}/api/v1/auth/login`);
```

**React Native:**
```javascript
const API_URL = __DEV__ 
  ? 'http://localhost:3000'
  : 'https://agricreditbackend.vercel.app';
```

---

## 🔥 Pro Tips

1. **Never** hardcode URLs in components
2. Always use `config.API_BASE_URL`
3. Comment out unused environment in `.env`
4. Keep `.env` file secure (never commit)

---

## ✅ Quick Checklist

- [x] Vercel deployed: `https://agricreditbackend.vercel.app`
- [x] Environment config created: `src/config/environment.js`
- [x] `.env` updated with `API_BASE_URL`
- [x] All files use centralized config
- [x] Production API tested and working
- [x] Easy switching between local/production

---

## 📚 Full Documentation

See `ENVIRONMENT_SETUP.md` for complete details.

---

**🎉 You're all set!** Change one line, update everywhere!
