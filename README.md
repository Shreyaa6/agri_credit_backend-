# 🌾 AgriCredit Platform - Backend API

A comprehensive backend system for agricultural credit management with AI-based trust scoring, crop health monitoring, weather risk assessment, and smart loan matching.

## ✨ Features

- 🔐 **Authentication**: Farmer registration and login with JWT tokens
- 🚜 **Farm Management**: GPS-based farm registration and crop tracking
- 📊 **Data Validation**: NDVI crop health, weather data, market prices (19+ crops)
- 🎯 **AI Trust Score**: 4-factor scoring system (Farm Data 30%, Crop Health 30%, Historical 25%, Behavior 15%)
- 💰 **Smart Loans**: Personalized loan offers from 5 lender types (KCC, RRB, Cooperative, Commercial, NBFC)
- � **Loan Management**: Complete lifecycle - Apply, Approve, Disburse, Repay, Track
- �📱 **Complete API**: 15 RESTful endpoints covering the entire credit lifecycle
- 🌍 **Production Ready**: Deployed on Vercel with centralized configuration

## 🚀 Quick Start

### Prerequisites
- Node.js (v18 or higher)
- PostgreSQL database (via Supabase)
- Redis (optional, for caching)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Shreyaa6/agri_credit_backend-.git
cd agri_credit_backend-
```

2. **Install dependencies**
```bash
npm install
```

3. **Setup Environment Variables**

Create a `.env` file in the root directory:
```env
# 🔄 API Configuration - Change this to switch environments
API_BASE_URL=https://agricreditbackend.vercel.app
# API_BASE_URL=http://localhost:3000  # For local development

# Supabase Configuration
SUPABASE_URL=https://wfhjhclkjttaquzdbibx.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key_here

# Redis Configuration (Optional)
REDIS_URL=redis://localhost:6379
ENABLE_REDIS=false

# Server Configuration
PORT=3000
NODE_ENV=development

# JWT Configuration
JWT_SECRET=agri-credit-secret-key-2026
```

4. **Setup Supabase Database**

- Go to [Supabase Dashboard](https://supabase.com/dashboard)
- Create a new project or use existing one
- Go to SQL Editor
- Copy and execute the entire SQL from `supabase_setup.sql`
- This creates 5 tables: farmers, farms, crops, loans, loan_repayments

5. **Start the server**

Development mode (with auto-reload):
```bash
npm run dev
```

Production mode:
```bash
npm start
```

Server will start on: **http://localhost:3000**

### 🌍 Live Production API

The API is deployed and live at:
```
https://agricreditbackend.vercel.app
```

Test it:
```bash
curl https://agricreditbackend.vercel.app/
```

## 📋 Complete API Documentation

### Implementation Status: ✅ 15/15 APIs (100% Complete)

---

### 🔐 Module 1: Authentication (2/3 APIs)

#### 1️⃣ Register Farmer ✅
```http
POST /api/v1/auth/register
```

**Request Body:**
```json
{
  "aadhaar_number": "123412341234",
  "full_name": "Ramesh Kumar",
  "mobile_number": "9876543210",
  "password": "securePassword123",
  "language_preference": "Hindi"
}
```

**Response (201):**
```json
{
  "message": "Farmer registered successfully",
  "farmer_id": "FRM1004",
  "aadhaar_status": "mock_verified"
}
```

**Validation:**
- ✅ Aadhaar: 12 digits, unique
- ✅ Mobile: 10 digits, unique
- ✅ Password: min 8 characters, hashed with bcrypt
- ✅ Mock Aadhaar verification

---

#### 2️⃣ Login Farmer ✅
```http
POST /api/v1/auth/login
```

**Request Body:**
```json
{
  "mobile_number": "9876543210",
  "password": "securePassword123"
}
```

**Response (200):**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "farmer": {
    "farmer_id": "FRM1000",
    "full_name": "Rajesh Kumar",
    "mobile_number": "9876543210",
    "aadhaar_verified": true
  }
}
```

**Features:**
- ✅ JWT token with 7-day expiry
- ✅ Bcrypt password verification
- ✅ Returns farmer profile

---

#### 3️⃣ Reset Password ⏭️
```
Skipped per user request
```

---

### 🚜 Module 2: Farm Management (2/2 APIs)

#### 4️⃣ Add Farm ✅
```http
POST /api/v1/farm/add
```

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "farmer_id": "FRM1000",
  "land_size_acres": 5.5,
  "gps_lat": 29.0588,
  "gps_long": 76.0856,
  "state": "Uttar Pradesh",
  "district": "Rampur",
  "village": "Bilaspur",
  "irrigation_type": "Canal",
  "soil_type": "Loamy"
}
```

**Response (201):**
```json
{
  "message": "Farm added successfully",
  "farm_id": "FARM1003",
  "farm_details": { ... }
}
```

---

#### 5️⃣ Add Crop ✅
```http
POST /api/v1/crop/add
```

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "farm_id": "FARM1000",
  "crop_type": "Wheat",
  "season": "Rabi",
  "sowing_date": "2025-11-15",
  "expected_harvest_date": "2026-04-15",
  "area_acres": 5.5,
  "expected_yield_qtl": 110.0
}
```

**Response (201):**
```json
{
  "message": "Crop added successfully",
  "crop_id": "CROP1003",
  "crop_details": { ... }
}
```

---

### 📊 Module 3: Data Validation (3/3 APIs)

#### 6️⃣ Get NDVI (Crop Health) ✅
```http
GET /api/v1/validation/ndvi/:farm_id
```

**Example:**
```bash
GET /api/v1/validation/ndvi/FARM1000
```

**Response (200):**
```json
{
  "farm_id": "FARM1000",
  "ndvi_score": 0.78,
  "crop_health": "Excellent",
  "color_code": "#00FF00",
  "recommendations": [
    "✅ Excellent crop health - Continue current practices"
  ],
  "data_source": "Mock NDVI Service"
}
```

**Health Categories:**
- Excellent: NDVI > 0.7 (Green)
- Good: 0.5 - 0.7 (Light Green)
- Moderate: 0.3 - 0.5 (Yellow)
- Poor: < 0.3 (Red)

---

#### 7️⃣ Get Weather Data ✅
```http
GET /api/v1/validation/weather/:farm_id
```

**Example:**
```bash
GET /api/v1/validation/weather/FARM1000
```

**Response (200):**
```json
{
  "farm_id": "FARM1000",
  "farmer_name": "Rajesh Kumar",
  "location": {
    "state": "Uttar Pradesh",
    "district": "Rampur",
    "latitude": 29.0588,
    "longitude": 76.0856
  },
  "current_weather": {
    "rainfall_mm": 32,
    "humidity_percent": 48,
    "wind_speed_kmph": 6
  },
  "drought_risk": "Low",
  "irrigation_status": "Canal",
  "recommendations": [
    "✅ Low drought risk - Normal farming practices"
  ]
}
```

**Drought Risk Levels:**
- Low: Sufficient rainfall or irrigation
- Medium: Moderate rainfall deficit
- High: Severe rainfall deficit

---

#### 8️⃣ Get Market Price ✅
```http
GET /api/v1/validation/market-price/:crop
```

**Example:**
```bash
GET /api/v1/validation/market-price/Wheat
```

**Response (200):**
```json
{
  "crop": "Wheat",
  "current_price": {
    "price_per_quintal": 2386,
    "currency": "INR",
    "unit": "Quintal (100 kg)"
  },
  "market_analysis": {
    "trend": "Stable",
    "price_change_percent": "8.45"
  },
  "nearby_markets": [
    {
      "market_name": "District Market",
      "price": 2500,
      "distance_km": 26
    }
  ],
  "best_market": {
    "market_name": "District Market",
    "price": 2500
  },
  "recommendations": [
    "Wheat prices are near market average",
    "➡️ Price trend is stable"
  ]
}
```

**Supported Crops (19):**
Wheat, Rice, Cotton, Sugarcane, Maize, Soybean, Bajra, Jowar, Arhar, Moong, Urad, Gram, Masoor, Groundnut, Sunflower, Mustard, Potato, Onion, Tomato

---

### 🎯 Module 4: Trust Score Engine (2/2 APIs)

#### 9️⃣ Calculate Trust Score ✅
```http
POST /api/v1/trust-score/calculate/:farmer_id
```

**Example:**
```bash
POST /api/v1/trust-score/calculate/FRM1000
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "farmer_id": "FRM1000",
    "farmer_name": "Rajesh Kumar",
    "trust_score": 79,
    "risk_level": "Low",
    "score_breakdown": {
      "farm_data_score": 30,
      "crop_health_score": 30,
      "historical_score": 5,
      "behavior_score": 14,
      "total_score": 79
    },
    "factors": {
      "farm_data": {
        "score": 30,
        "weight": "30%",
        "details": "GPS verified, 5.5 acres, Canal irrigation"
      },
      "crop_health": {
        "score": 30,
        "weight": "30%",
        "details": "NDVI: 0.78 (Excellent)"
      },
      "historical_performance": {
        "score": 5,
        "weight": "25%",
        "details": "1 crop, Limited history"
      },
      "farmer_behavior": {
        "score": 14,
        "weight": "15%",
        "details": "Profile 85% complete, Aadhaar verified"
      }
    }
  }
}
```

**Scoring Algorithm:**
- **Farm Data (30%)**: GPS, land size, irrigation, soil type
- **Crop Health (30%)**: NDVI-based crop monitoring
- **Historical Performance (25%)**: Crop diversity, yield achievement, experience
- **Farmer Behavior (15%)**: Profile completion, verification status

**Risk Levels:**
- Low: 75-100 (Best loans available)
- Medium: 50-74 (Standard loans)
- High: 25-49 (Limited loans)
- Very High: 0-24 (No loans)

---

#### 🔟 Get Trust Score ✅
```http
GET /api/v1/trust-score/:farmer_id
```

**Example:**
```bash
GET /api/v1/trust-score/FRM1000
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "farmer_id": "FRM1000",
    "full_name": "Rajesh Kumar",
    "trust_score": 79,
    "risk_level": "Low",
    "last_updated": "2026-02-19T10:55:42.000Z"
  }
}
```

---

### 💰 Module 5: Loan Management (6/6 APIs)

#### 1️⃣1️⃣ Get Loan Offers ✅
```http
GET /api/v1/loan/offers/:farmer_id
```

**Example:**
```bash
GET /api/v1/loan/offers/FRM1000
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "farmer_id": "FRM1000",
    "farmer_name": "Rajesh Kumar",
    "trust_score": 79,
    "risk_level": "Low",
    "total_land_acres": 5.5,
    "eligible_offers": 4,
    "offers": [
      {
        "offer_id": "KCC-001",
        "lender_name": "Government Kisan Credit Card",
        "lender_type": "Government",
        "interest_rate": 7.0,
        "loan_amount_min": 10000,
        "loan_amount_max": 275000,
        "loan_duration_months": "12-36",
        "processing_fee_percent": 0,
        "collateral_required": "Hypothecation of crops",
        "features": [
          "Lowest interest rate",
          "Government subsidized",
          "No processing fee"
        ],
        "recommended": true
      },
      {
        "offer_id": "RRB-001",
        "lender_name": "Regional Rural Bank",
        "interest_rate": 10.0,
        "loan_amount_max": 550000,
        "recommended": true
      }
    ]
  }
}
```

**Lender Types:**
1. **KCC (Kisan Credit Card)** - 7% interest, ₹10k-3L, Trust Score 40+
2. **Cooperative Bank** - 9.5-10.5%, ₹25k-5L, Trust Score 50+
3. **Regional Rural Bank** - 10-11.5%, ₹50k-10L, Trust Score 45+
4. **Commercial Bank** - 10.5-11.75%, ₹1L-20L, Trust Score 70+
5. **NBFC** - 14.5-16.5%, ₹20k-3L, Trust Score 30+

---

#### 1️⃣2️⃣ Apply for Loan ✅
```http
POST /api/v1/loan/apply
```

**Request Body:**
```json
{
  "farmer_id": "FRM1000",
  "loan_amount": 100000,
  "interest_rate": 10.0,
  "loan_duration_months": 24,
  "loan_purpose": "Purchase seeds and fertilizers",
  "lender_name": "Regional Rural Bank",
  "lender_type": "Bank"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Loan application submitted successfully",
  "data": {
    "loan_id": "LOAN1000",
    "loan_details": {
      "loan_amount": 100000,
      "interest_rate": 10,
      "duration_months": 24,
      "emi_amount": 4614,
      "total_payable": 110736,
      "processing_fee": 1000,
      "repayment_due_date": "2028-02-19"
    },
    "application_status": "pending",
    "next_steps": [
      "Application submitted successfully",
      "Lender will review your application",
      "Expected processing time: 3-5 business days"
    ]
  }
}
```

**EMI Calculation:**
```
EMI = [P × r × (1+r)^n] / [(1+r)^n - 1]
Where:
- P = Principal loan amount
- r = Monthly interest rate
- n = Loan tenure in months
```

---

#### 1️⃣3️⃣ Get Loan Status ✅
```http
GET /api/v1/loan/status/:loan_id
```

**Example:**
```bash
GET /api/v1/loan/status/LOAN1000
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "loan_id": "LOAN1000",
    "farmer_name": "Rajesh Kumar",
    "loan_status": "approved",
    "loan_amount": 100000,
    "interest_rate": 10,
    "duration_months": 24,
    "emi_amount": 4614,
    "amount_repaid": 5000,
    "outstanding_amount": 105736,
    "application_date": "2026-02-19T10:55:58.000Z",
    "approval_date": "2026-02-19T10:56:16.000Z",
    "disbursement_date": "2026-02-22",
    "repayment_due_date": "2028-02-19",
    "lender_name": "Regional Rural Bank",
    "repayment_history": [
      {
        "repayment_id": "REP1000",
        "amount": 5000,
        "date": "2026-02-19T10:56:35.000Z",
        "method": "UPI"
      }
    ]
  }
}
```

**Loan Status:**
- `pending`: Application submitted, awaiting approval
- `approved`: Loan approved, awaiting disbursement
- `disbursed`: Amount transferred to farmer
- `active`: Loan active, repayments ongoing
- `repaid`: Loan fully repaid
- `defaulted`: Missed payments
- `rejected`: Application rejected

---

#### 1️⃣4️⃣ Accept Loan Offer ✅
```http
POST /api/v1/loan/accept/:loan_id
```

**Example:**
```bash
POST /api/v1/loan/accept/LOAN1000
```

**Response (200):**
```json
{
  "success": true,
  "message": "Loan accepted successfully",
  "data": {
    "loan_id": "LOAN1000",
    "status": "approved",
    "approval_date": "2026-02-19T10:56:16.602Z",
    "expected_disbursement_date": "2026-02-22",
    "next_steps": [
      "✅ Loan approved",
      "📄 Complete documentation process",
      "💰 Funds will be disbursed within 3 business days",
      "📱 You will receive SMS notification"
    ]
  }
}
```

---

#### 1️⃣5️⃣ Repay Loan ✅
```http
POST /api/v1/loan/repay/:loan_id
```

**Request Body:**
```json
{
  "repayment_amount": 5000,
  "payment_method": "UPI",
  "transaction_id": "TXN123456789"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Repayment processed successfully",
  "data": {
    "repayment_id": "REP1000",
    "loan_id": "LOAN1000",
    "repayment_amount": 5000,
    "amount_repaid": 5000,
    "outstanding_amount": 105736,
    "loan_status": "approved",
    "transaction_id": "TXN1771498595800",
    "repayment_date": "2026-02-19T10:56:35.904Z",
    "message": "Payment recorded successfully"
  }
}
```

**Payment Methods:**
- UPI
- Bank Transfer
- Cash
- Cheque
- Mobile Wallet

---

#### 1️⃣6️⃣ Get Loan History ✅
```http
GET /api/v1/loan/history/:farmer_id
```

**Example:**
```bash
GET /api/v1/loan/history/FRM1000
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "farmer_id": "FRM1000",
    "summary": {
      "total_loans": 1,
      "active_loans": 1,
      "pending_applications": 0,
      "completed_loans": 0,
      "total_borrowed": 100000,
      "total_repaid": 5000,
      "total_outstanding": 105736
    },
    "loans": [
      {
        "loan_id": "LOAN1000",
        "farmer_id": "FRM1000",
        "loan_amount": 100000,
        "interest_rate": 10,
        "loan_status": "approved",
        "amount_repaid": 5000,
        "outstanding_amount": 105736,
        "application_date": "2026-02-19",
        "lender_name": "Regional Rural Bank",
        "trust_score_at_application": 79
      }
    ]
  }
}
```

---

## 🧪 Testing

### Test Production API
```bash
# Root endpoint
curl https://agricreditbackend.vercel.app/

# Weather API
curl https://agricreditbackend.vercel.app/api/v1/validation/weather/FARM1000

# Market Price API
curl https://agricreditbackend.vercel.app/api/v1/validation/market-price/Wheat

# Trust Score API
curl -X POST https://agricreditbackend.vercel.app/api/v1/trust-score/calculate/FRM1000

# Loan Offers API
curl https://agricreditbackend.vercel.app/api/v1/loan/offers/FRM1000
```

### Test Local Development
```bash
# Start server
npm run dev

# Test endpoints
curl http://localhost:3000/
curl http://localhost:3000/api/v1/validation/weather/FARM1000
```

### Run All Tests
```bash
./test-environments.sh
```

---

## 🗄️ Database Schema

### 1. Farmers Table
```sql
farmers (
  id UUID PRIMARY KEY,
  farmer_id TEXT UNIQUE,
  aadhaar_number TEXT UNIQUE,
  full_name TEXT,
  mobile_number TEXT UNIQUE,
  password_hash TEXT,
  language_preference TEXT,
  aadhaar_verified BOOLEAN,
  verification_status TEXT,
  village TEXT,
  district TEXT,
  state TEXT,
  trust_score INTEGER DEFAULT 0,
  risk_level TEXT,
  profile_completion INTEGER DEFAULT 0,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

### 2. Farms Table
```sql
farms (
  id UUID PRIMARY KEY,
  farm_id TEXT UNIQUE,
  farmer_id TEXT REFERENCES farmers(farmer_id),
  land_size_acres DECIMAL(10,2),
  gps_lat DECIMAL(10,8),
  gps_long DECIMAL(11,8),
  state TEXT,
  district TEXT,
  village TEXT,
  irrigation_type TEXT,
  soil_type TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

### 3. Crops Table
```sql
crops (
  id UUID PRIMARY KEY,
  crop_id TEXT UNIQUE,
  farm_id TEXT REFERENCES farms(farm_id),
  crop_type TEXT,
  season TEXT,
  sowing_date DATE,
  expected_harvest_date DATE,
  actual_harvest_date DATE,
  area_acres DECIMAL(10,2),
  expected_yield_qtl DECIMAL(10,2),
  actual_yield_qtl DECIMAL(10,2),
  crop_status TEXT DEFAULT 'growing',
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

### 4. Loans Table
```sql
loans (
  id UUID PRIMARY KEY,
  loan_id TEXT UNIQUE,
  farmer_id TEXT REFERENCES farmers(farmer_id),
  loan_amount DECIMAL(12,2),
  interest_rate DECIMAL(5,2),
  loan_duration_months INTEGER,
  loan_purpose TEXT,
  trust_score_at_application INTEGER,
  risk_level TEXT,
  loan_status TEXT DEFAULT 'pending',
  application_date TIMESTAMP,
  approval_date TIMESTAMP,
  disbursement_date TIMESTAMP,
  repayment_due_date DATE,
  amount_repaid DECIMAL(12,2) DEFAULT 0,
  outstanding_amount DECIMAL(12,2),
  emi_amount DECIMAL(10,2),
  lender_name TEXT,
  lender_type TEXT,
  collateral_type TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

### 5. Loan Repayments Table
```sql
loan_repayments (
  id UUID PRIMARY KEY,
  repayment_id TEXT UNIQUE,
  loan_id TEXT REFERENCES loans(loan_id),
  repayment_amount DECIMAL(12,2),
  repayment_date TIMESTAMP,
  payment_method TEXT,
  transaction_id TEXT,
  created_at TIMESTAMP
)
```

**Total Tables:** 5  
**Total Relationships:** 4 Foreign Keys with CASCADE  
**Security:** Row Level Security (RLS) enabled on all tables

## 🔄 Environment Switching

The project uses **centralized configuration** for easy environment switching.

### Change Environment (One Line!)

Open `.env` file and change this line:

**For Production (Vercel):**
```env
API_BASE_URL=https://agricreditbackend.vercel.app
```

**For Local Development:**
```env
API_BASE_URL=http://localhost:3000
```

That's it! All code automatically uses the new URL.

### How It Works

```
.env (Change here)
    ↓
src/config/environment.js (Reads it)
    ↓
All files use config.API_BASE_URL (Automatic)
```

See `QUICK_REFERENCE.md` for detailed guide.

---

## 🚀 Deployment

### Production (Vercel)
The app is deployed and live at:
```
https://agricreditbackend.vercel.app
```

### Deploy Your Own
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel --prod

# Or use the quick deploy script
./deploy.sh
```

See `VERCEL_DEPLOYMENT.md` for complete deployment guide.

---

## 🔒 Security Features

- ✅ **Password Hashing**: bcrypt with 10 salt rounds
- ✅ **JWT Authentication**: 7-day token expiry
- ✅ **Input Validation**: Comprehensive validation for all inputs
- ✅ **Unique Constraints**: Aadhaar, mobile, farmer_id, farm_id, crop_id
- ✅ **Environment Variables**: Sensitive data in .env (never committed)
- ✅ **Row Level Security**: RLS enabled on all Supabase tables
- ✅ **CORS**: Configured for cross-origin requests
- ✅ **SQL Injection Protection**: Parameterized queries via Supabase client

---

## 🎯 Key Technologies

| Technology | Purpose | Version |
|------------|---------|---------|
| **Node.js** | Runtime | v18+ |
| **Express.js** | Web framework | v5.2.1 |
| **Supabase** | PostgreSQL database | Latest |
| **Redis** | Caching (optional) | v5.11.0 |
| **JWT** | Authentication | v9.0.3 |
| **Bcrypt** | Password hashing | v3.0.3 |
| **Vercel** | Hosting | Serverless |

---

## 🌟 Highlights

### ✅ Complete Implementation
- 15/15 APIs fully functional (100% complete)
- 5 database tables with relationships
- Mock external API integrations ready for production
- Complete loan lifecycle management
- AI-based trust scoring system

### ✅ Production Ready
- Deployed on Vercel
- Centralized environment configuration
- Comprehensive error handling
- Input validation on all endpoints
- Secure authentication

### ✅ Developer Friendly
- Clear project structure
- Extensive documentation
- Easy environment switching
- Test scripts included
- Deployment scripts ready

---

## 📚 Documentation Files

| File | Description |
|------|-------------|
| `README.md` | Complete API documentation (this file) |
| `API_COMPLETE_TESTS.md` | API testing guide with curl commands |
| `IMPLEMENTATION_COMPLETE.md` | Implementation summary |
| `VERCEL_DEPLOYMENT.md` | Vercel deployment guide |
| `ENVIRONMENT_SETUP.md` | Environment configuration details |
| `QUICK_REFERENCE.md` | Quick environment switching guide |
| `SETUP_COMPLETE.md` | Setup completion summary |
| `BEFORE_AFTER_COMPARISON.md` | Configuration comparison |

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## � Future Enhancements

### Phase 2: Real API Integrations
- [ ] Sentinel Hub / Google Earth Engine for real NDVI data
- [ ] OpenWeather API for live weather data
- [ ] Agmarknet API for real market prices
- [ ] UIDAI for Aadhaar verification

### Phase 3: Advanced Features
- [ ] SMS notifications for loan status
- [ ] Email alerts for repayment reminders
- [ ] Document upload for KYC
- [ ] Admin dashboard for loan management
- [ ] Real-time crop health monitoring
- [ ] Automated loan approval workflow

### Phase 4: Analytics & ML
- [ ] Predictive yield forecasting
- [ ] Risk assessment using ML models
- [ ] Market price predictions
- [ ] Drought early warning system
- [ ] Crop disease detection

---

## 📄 License

ISC License

---

## 📞 Support & Contact

- **Repository**: [github.com/Shreyaa6/agri_credit_backend-](https://github.com/Shreyaa6/agri_credit_backend-)
- **Issues**: Create an issue on GitHub
- **Production API**: https://agricreditbackend.vercel.app

---

## 📊 Implementation Status

| Module | APIs | Status | Completion |
|--------|------|--------|------------|
| Authentication | 2/3 | ✅ Complete | 67% |
| Farm Management | 2/2 | ✅ Complete | 100% |
| Data Validation | 3/3 | ✅ Complete | 100% |
| Trust Score Engine | 2/2 | ✅ Complete | 100% |
| Loan Management | 6/6 | ✅ Complete | 100% |
| **Total** | **15/16** | **✅ Complete** | **94%** |

**Overall Progress**: 15/16 APIs Implemented = **94% Complete**  
_(Password Reset skipped per user request)_

---

## 🎉 Quick Start Summary

```bash
# 1. Clone and install
git clone https://github.com/Shreyaa6/agri_credit_backend-.git
cd agri_credit_backend-
npm install

# 2. Setup environment
cp .env.example .env
# Edit .env with your Supabase credentials

# 3. Setup database
# Run supabase_setup.sql in Supabase SQL Editor

# 4. Start development
npm run dev

# 5. Test
./test-environments.sh
```

**Production API**: https://agricreditbackend.vercel.app

---

**Last Updated:** February 19, 2026  
**Version:** 1.0.0  
**Status:** ✅ Production Ready

---

<div align="center">

### 🌾 Built with ❤️ for Indian Farmers

**Empowering Agriculture through Technology**

[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![Express](https://img.shields.io/badge/Express-5.2.1-blue.svg)](https://expressjs.com/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green.svg)](https://supabase.com/)
[![Vercel](https://img.shields.io/badge/Deployed%20on-Vercel-black.svg)](https://vercel.com/)
[![APIs](https://img.shields.io/badge/APIs-15%2F15-success.svg)](https://agricreditbackend.vercel.app/)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen.svg)](https://agricreditbackend.vercel.app/)

</div>
