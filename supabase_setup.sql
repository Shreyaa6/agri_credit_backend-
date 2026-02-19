-- Create Farmers table with authentication fields
CREATE TABLE IF NOT EXISTS public.farmers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    farmer_id TEXT UNIQUE NOT NULL,
    aadhaar_number TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    mobile_number TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    language_preference TEXT DEFAULT 'English',
    aadhaar_verified BOOLEAN DEFAULT false,
    verification_status TEXT DEFAULT 'pending',
    village TEXT,
    district TEXT,
    state TEXT,
    trust_score INTEGER DEFAULT 0,
    risk_level TEXT,
    profile_completion INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE public.farmers ENABLE ROW LEVEL SECURITY;

-- Create policy to allow anyone to read (for demo purposes)
CREATE POLICY "Allow public read access" ON public.farmers
    FOR SELECT USING (true);

-- Create policy to allow insert for registration
CREATE POLICY "Allow public insert" ON public.farmers
    FOR INSERT WITH CHECK (true);

-- Create policy to allow update for own profile
CREATE POLICY "Allow users to update own profile" ON public.farmers
    FOR UPDATE USING (true);

-- Create function to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER update_farmers_updated_at BEFORE UPDATE ON public.farmers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create sequence for farmer_id generation
CREATE SEQUENCE IF NOT EXISTS farmer_id_seq START WITH 1000;

-- Create function to get next farmer ID
CREATE OR REPLACE FUNCTION get_next_farmer_id()
RETURNS INTEGER AS $$
BEGIN
    RETURN nextval('farmer_id_seq');
END;
$$ LANGUAGE plpgsql;

-- Create Farms table
CREATE TABLE IF NOT EXISTS public.farms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    farm_id TEXT UNIQUE NOT NULL,
    farmer_id TEXT NOT NULL REFERENCES public.farmers(farmer_id) ON DELETE CASCADE,
    land_size_acres DECIMAL(10, 2) NOT NULL,
    gps_lat DECIMAL(10, 8),
    gps_long DECIMAL(11, 8),
    state TEXT NOT NULL,
    district TEXT NOT NULL,
    village TEXT,
    irrigation_type TEXT,
    soil_type TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS for farms
ALTER TABLE public.farms ENABLE ROW LEVEL SECURITY;

-- Create policies for farms
CREATE POLICY "Allow public read access" ON public.farms
    FOR SELECT USING (true);

CREATE POLICY "Allow public insert" ON public.farms
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow users to update own farms" ON public.farms
    FOR UPDATE USING (true);

-- Create trigger for farms updated_at
CREATE TRIGGER update_farms_updated_at BEFORE UPDATE ON public.farms
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create sequence for farm_id generation
CREATE SEQUENCE IF NOT EXISTS farm_id_seq START WITH 1000;

-- Create function to get next farm ID
CREATE OR REPLACE FUNCTION get_next_farm_id()
RETURNS INTEGER AS $$
BEGIN
    RETURN nextval('farm_id_seq');
END;
$$ LANGUAGE plpgsql;

-- Insert mock data for farmers (updated for new schema)
INSERT INTO public.farmers (farmer_id, aadhaar_number, full_name, mobile_number, password_hash, language_preference, aadhaar_verified, verification_status, village, district, state, trust_score, risk_level, profile_completion)
VALUES 
('FRM1000', '123456789012', 'Rajesh Kumar', '9876543210', '$2a$10$mockHashedPassword1', 'Hindi', true, 'mock_verified', 'Bilaspur', 'Rampur', 'Uttar Pradesh', 82, 'Low', 85),
('FRM1001', '123456789013', 'Suresh Singh', '9876543211', '$2a$10$mockHashedPassword2', 'Hindi', true, 'mock_verified', 'Makhdumpur', 'Jehanabad', 'Bihar', 64, 'Medium', 72),
('FRM1002', '123456789014', 'Anita Devi', '9876543212', '$2a$10$mockHashedPassword3', 'Hindi', true, 'mock_verified', 'Kishanpur', 'Supaul', 'Bihar', 71, 'Low', 60),
('FRM1003', '123456789015', 'Vikram Mehta', '9876543213', '$2a$10$mockHashedPassword4', 'English', true, 'mock_verified', 'Palampur', 'Kangra', 'Himachal Pradesh', 45, 'High', 40)
ON CONFLICT (aadhaar_number) DO NOTHING;

-- Insert mock farms data
INSERT INTO public.farms (farm_id, farmer_id, land_size_acres, gps_lat, gps_long, state, district, village, irrigation_type, soil_type)
VALUES 
('FARM1000', 'FRM1000', 5.5, 29.058800, 76.085600, 'Uttar Pradesh', 'Rampur', 'Bilaspur', 'Canal', 'Loamy'),
('FARM1001', 'FRM1001', 3.0, 25.203800, 85.451500, 'Bihar', 'Jehanabad', 'Makhdumpur', 'Tubewell', 'Clay'),
('FARM1002', 'FRM1002', 2.5, 26.128700, 86.605100, 'Bihar', 'Supaul', 'Kishanpur', 'Rainfed', 'Sandy Loam')
ON CONFLICT (farm_id) DO NOTHING;

