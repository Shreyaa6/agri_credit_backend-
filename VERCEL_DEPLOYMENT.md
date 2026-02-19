# AgriCredit Backend - Vercel Deployment Guide

## 🚀 Deployment Steps

### 1. Prerequisites
- Install Vercel CLI: `npm install -g vercel`
- Create a Vercel account at https://vercel.com

### 2. Environment Variables Setup
Before deploying, you need to add these environment variables to Vercel:

```bash
# Supabase Configuration
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# JWT Configuration
JWT_SECRET=your_jwt_secret

# Redis Configuration (Optional - for production caching)
REDIS_URL=your_redis_url

# Node Environment
NODE_ENV=production
```

### 3. Deploy to Vercel

#### Option A: Deploy via Vercel CLI (Recommended)
```bash
# Login to Vercel
vercel login

# Deploy to production
vercel --prod
```

#### Option B: Deploy via Vercel Dashboard
1. Go to https://vercel.com/dashboard
2. Click "Add New Project"
3. Import your Git repository
4. Configure environment variables in Project Settings
5. Deploy

### 4. Configure Environment Variables in Vercel

**Via CLI:**
```bash
vercel env add SUPABASE_URL
vercel env add SUPABASE_ANON_KEY
vercel env add JWT_SECRET
vercel env add REDIS_URL
```

**Via Dashboard:**
1. Go to your project in Vercel Dashboard
2. Navigate to Settings → Environment Variables
3. Add each variable for Production environment
4. Redeploy the project

### 5. Get Your Environment Variables

**Supabase:**
1. Go to https://supabase.com/dashboard
2. Select your project
3. Go to Settings → API
4. Copy `URL` and `anon` key

**JWT Secret:**
```bash
# Generate a secure JWT secret
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

**Redis (Optional):**
- Use Upstash Redis: https://upstash.com/
- Or disable Redis by removing it from the code

### 6. Verify Deployment

After deployment, test your API:
```bash
# Replace with your Vercel URL
curl https://your-project.vercel.app/

# Test auth endpoint
curl https://your-project.vercel.app/api/v1/auth/login
```

## 📝 Important Notes

### Vercel Limitations
- **Serverless Functions**: Each API request runs as a serverless function
- **10 second timeout**: Functions timeout after 10 seconds on free plan
- **Stateless**: No persistent connections (Redis connections are created per request)
- **Cold starts**: First request after inactivity may be slower

### Configuration Files Created
- `vercel.json` - Vercel deployment configuration
- `.vercelignore` - Files to exclude from deployment
- Updated `package.json` - Added engines and vercel-build script
- Updated `src/index.js` - Export app for Vercel serverless

### Redis Configuration
If you want to use Redis in production:
1. Sign up for Upstash Redis (free tier available)
2. Get your Redis URL
3. Add it to Vercel environment variables
4. No code changes needed

### Database Migrations
Your Supabase database is already set up. Just ensure:
- Database is accessible from Vercel (should be by default)
- RLS policies are configured correctly
- Connection strings are correct

## 🔧 Troubleshooting

### Issue: 500 Internal Server Error
**Solution**: Check Vercel Function logs:
```bash
vercel logs
```

### Issue: Environment variables not working
**Solution**: 
1. Ensure variables are added for "Production" environment
2. Redeploy after adding variables
3. Check variable names match exactly

### Issue: Database connection timeout
**Solution**:
- Verify Supabase URL is correct
- Check if Supabase project is paused (free tier pauses after inactivity)
- Ensure no IP restrictions on Supabase

### Issue: CORS errors
**Solution**: Already configured in code with `cors()` middleware

## 🎯 Next Steps After Deployment

1. **Custom Domain**: Add a custom domain in Vercel settings
2. **Monitoring**: Enable Vercel Analytics
3. **Logging**: Set up error tracking (Sentry, LogRocket)
4. **Performance**: Monitor function execution times
5. **Security**: Add rate limiting (use Vercel Edge Config)

## 📚 Useful Commands

```bash
# Check deployment status
vercel ls

# View function logs
vercel logs

# View environment variables
vercel env ls

# Remove deployment
vercel rm project-name

# Pull environment variables locally
vercel env pull
```

## 🔗 Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Vercel Node.js Runtime](https://vercel.com/docs/functions/runtimes/node-js)
- [Supabase + Vercel Guide](https://supabase.com/docs/guides/getting-started/quickstarts/vercel)
- [Express on Vercel](https://vercel.com/guides/using-express-with-vercel)

## ✅ Deployment Checklist

- [ ] Environment variables added to Vercel
- [ ] Database is accessible and running
- [ ] JWT secret is secure and added
- [ ] Test all API endpoints after deployment
- [ ] Update frontend API URL to Vercel URL
- [ ] Monitor logs for errors
- [ ] Set up custom domain (optional)
- [ ] Enable Vercel Analytics (optional)

---

**Deployed Successfully?** 🎉
Your AgriCredit API is now live and ready to serve requests!
