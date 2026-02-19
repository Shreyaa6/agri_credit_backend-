#!/bin/bash

# AgriCredit Backend - Quick Vercel Deploy Script
# This script helps you deploy to Vercel with all necessary configurations

echo "🚀 AgriCredit Backend - Vercel Deployment Script"
echo "================================================"
echo ""

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null
then
    echo "❌ Vercel CLI is not installed."
    echo "📦 Installing Vercel CLI..."
    npm install -g vercel
fi

echo "✅ Vercel CLI is ready"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  No .env file found!"
    echo "Creating template .env file..."
    cat > .env.template << EOF
# Supabase Configuration
SUPABASE_URL=your_supabase_url_here
SUPABASE_ANON_KEY=your_supabase_anon_key_here

# JWT Configuration
JWT_SECRET=your_jwt_secret_here

# Redis Configuration (Optional)
REDIS_URL=your_redis_url_here

# Node Environment
NODE_ENV=production
PORT=3000
EOF
    echo "✅ Created .env.template - Please fill in your values"
    echo ""
fi

# Ask user if they want to set environment variables
echo "📋 Environment Variables Setup"
echo "------------------------------"
echo "Do you want to add environment variables to Vercel now? (y/n)"
read -r add_env

if [ "$add_env" = "y" ]; then
    echo ""
    echo "Adding SUPABASE_URL..."
    vercel env add SUPABASE_URL production
    
    echo "Adding SUPABASE_ANON_KEY..."
    vercel env add SUPABASE_ANON_KEY production
    
    echo "Adding JWT_SECRET..."
    vercel env add JWT_SECRET production
    
    echo ""
    echo "Do you want to add Redis URL? (y/n)"
    read -r add_redis
    if [ "$add_redis" = "y" ]; then
        vercel env add REDIS_URL production
    fi
    
    echo "✅ Environment variables added!"
else
    echo "⚠️  Remember to add environment variables manually:"
    echo "   - Via Vercel Dashboard: https://vercel.com/dashboard"
    echo "   - Or use: vercel env add VARIABLE_NAME production"
fi

echo ""
echo "🚀 Deploying to Vercel..."
echo "-------------------------"
echo "Choose deployment type:"
echo "1) Preview deployment (test)"
echo "2) Production deployment"
read -r deploy_type

if [ "$deploy_type" = "2" ]; then
    echo "Deploying to production..."
    vercel --prod
else
    echo "Deploying preview..."
    vercel
fi

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📝 Next Steps:"
echo "1. Test your API endpoints"
echo "2. Update frontend with new Vercel URL"
echo "3. Check logs: vercel logs"
echo "4. Monitor at: https://vercel.com/dashboard"
echo ""
echo "🎉 Your AgriCredit API is live!"
