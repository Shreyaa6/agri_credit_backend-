#!/bin/bash

# 🧪 Environment Test Script
# Tests both local and production APIs

echo "🧪 AgriCredit API Environment Test"
echo "===================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to test an endpoint
test_endpoint() {
    local url=$1
    local name=$2
    
    echo -n "Testing $name... "
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url" --max-time 10)
    
    if [ "$response" = "200" ]; then
        echo -e "${GREEN}✅ PASS${NC} (HTTP $response)"
    else
        echo -e "${RED}❌ FAIL${NC} (HTTP $response)"
    fi
}

# Test Production (Vercel)
echo "📍 Testing PRODUCTION Environment"
echo "URL: https://agricreditbackend.vercel.app"
echo "-------------------------------------------"

test_endpoint "https://agricreditbackend.vercel.app/" "Root Endpoint"
test_endpoint "https://agricreditbackend.vercel.app/api/v1/validation/weather/FARM1000" "Weather API"
test_endpoint "https://agricreditbackend.vercel.app/api/v1/validation/market-price/Wheat" "Market Price API"

echo ""

# Test Local (if running)
echo "📍 Testing LOCAL Environment"
echo "URL: http://localhost:3000"
echo "-------------------------------------------"

# Check if local server is running
if curl -s http://localhost:3000/ > /dev/null 2>&1; then
    test_endpoint "http://localhost:3000/" "Root Endpoint"
    test_endpoint "http://localhost:3000/api/v1/validation/weather/FARM1000" "Weather API"
    test_endpoint "http://localhost:3000/api/v1/validation/market-price/Wheat" "Market Price API"
else
    echo -e "${YELLOW}⚠️  Local server not running${NC}"
    echo "Start it with: npm run dev"
fi

echo ""
echo "=================================="
echo "✅ Test Complete"
echo ""
echo "Current .env configuration:"
if grep -q "^API_BASE_URL=https://agricreditbackend.vercel.app" .env; then
    echo -e "${GREEN}🌍 Currently set to: PRODUCTION${NC}"
elif grep -q "^API_BASE_URL=http://localhost:3000" .env; then
    echo -e "${YELLOW}💻 Currently set to: LOCAL${NC}"
else
    echo -e "${YELLOW}⚠️  API_BASE_URL not set in .env${NC}"
fi

echo ""
echo "To switch environments, edit .env and change API_BASE_URL"
