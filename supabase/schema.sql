-- ============================================================================
-- K2 DENT - SUPABASE DATABASE SCHEMA
-- Cabinet Dentaire Dr. Ekaterina SIALYEN
--
-- Author: Ismail Sialyen
-- Date: April 2026
-- Version: 1.0.0
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For full-text search

-- ============================================================================
-- PATIENTS
-- ============================================================================
CREATE TABLE patients (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  niss VARCHAR(15) UNIQUE NOT NULL, -- Format: XX.XX.XX-XXX.XX
  date_of_birth DATE,
  gender CHAR(1) CHECK (gender IN ('M', 'F', 'X')),
  phone VARCHAR(20),
  email VARCHAR(255),
  address TEXT,
  city VARCHAR(100),
  postal_code VARCHAR(10),
  mutuelle_code VARCHAR(3), -- 100, 200, 300, 400, 500, 600, 900
  bim BOOLEAN DEFAULT FALSE, -- Bénéficiaire Intervention Majorée
  allergies TEXT,
  medical_notes TEXT,
  emergency_contact_name VARCHAR(200),
  emergency_contact_phone VARCHAR(20),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

-- Indexes for fast search
CREATE INDEX idx_patients_niss ON patients(niss);
CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_patients_search ON patients USING gin ((first_name || ' ' || last_name || ' ' || niss) gin_trgm_ops);

-- Row Level Security
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view all patients"
  ON patients FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert patients"
  ON patients FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update patients"
  ON patients FOR UPDATE
  USING (auth.role() = 'authenticated');

-- ============================================================================
-- ANAMNESIS (Anamnèses avec versioning)
-- ============================================================================
CREATE TABLE anamnesis (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  version INTEGER NOT NULL,
  content TEXT NOT NULL,
  type VARCHAR(20) NOT NULL CHECK (type IN ('AI', 'MODIFIED', 'MANUAL')),
  recording_duration INTEGER, -- en secondes
  transcription TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id),

  UNIQUE(patient_id, version)
);

CREATE INDEX idx_anamnesis_patient ON anamnesis(patient_id, version DESC);

ALTER TABLE anamnesis ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view anamnesis"
  ON anamnesis FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert anamnesis"
  ON anamnesis FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- Auto-increment version trigger
CREATE OR REPLACE FUNCTION set_anamnesis_version()
RETURNS TRIGGER AS $$
BEGIN
  SELECT COALESCE(MAX(version), 0) + 1 INTO NEW.version
  FROM anamnesis WHERE patient_id = NEW.patient_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_version_anamnesis
  BEFORE INSERT ON anamnesis
  FOR EACH ROW
  EXECUTE FUNCTION set_anamnesis_version();

-- ============================================================================
-- TIMELINE EVENTS (Historique patient)
-- ============================================================================
CREATE TABLE timeline_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  event_type VARCHAR(50) NOT NULL, -- anamnesis, prescription, xray, certificate, inami, treatment
  title VARCHAR(255) NOT NULL,
  description TEXT,
  badge VARCHAR(50),
  event_data JSONB DEFAULT '{}'::jsonb, -- Données spécifiques à chaque type
  event_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_timeline_patient ON timeline_events(patient_id, event_date DESC);
CREATE INDEX idx_timeline_type ON timeline_events(event_type);

ALTER TABLE timeline_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view timeline"
  ON timeline_events FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert timeline events"
  ON timeline_events FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- ============================================================================
-- DENTAL CHARTS (Schémas dentaires)
-- ============================================================================
CREATE TABLE dental_charts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID UNIQUE NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  chart_data JSONB NOT NULL DEFAULT '{}'::jsonb,
  last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_dental_charts_patient ON dental_charts(patient_id);

ALTER TABLE dental_charts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view dental charts"
  ON dental_charts FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Users can upsert dental charts"
  ON dental_charts FOR ALL
  USING (auth.role() = 'authenticated');

-- ============================================================================
-- TOOTH TREATMENTS (Traitements par dent)
-- ============================================================================
CREATE TABLE tooth_treatments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  tooth_number VARCHAR(2) NOT NULL, -- FDI: 11-48
  treatment_type VARCHAR(50) NOT NULL, -- obturation, couronne, extraction, implant, etc.
  surface VARCHAR(10), -- DO, MOD, MODBL, etc.
  status VARCHAR(20) DEFAULT 'planned' CHECK (status IN ('planned', 'in_progress', 'completed', 'cancelled')),
  treatment_date DATE,
  cost DECIMAL(10,2),
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_treatments_patient ON tooth_treatments(patient_id);
CREATE INDEX idx_treatments_tooth ON tooth_treatments(patient_id, tooth_number);

ALTER TABLE tooth_treatments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage treatments"
  ON tooth_treatments FOR ALL
  USING (auth.role() = 'authenticated');

-- ============================================================================
-- INAMI ACTS (Actes INAMI)
-- ============================================================================
CREATE TABLE inami_acts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  act_code VARCHAR(10) NOT NULL,
  act_description TEXT,
  tooth_number VARCHAR(2),
  quantity INTEGER DEFAULT 1,
  act_date DATE NOT NULL,
  honoraire DECIMAL(10,2) NOT NULL,
  part_mutuelle DECIMAL(10,2) NOT NULL,
  ticket_moderateur DECIMAL(10,2) NOT NULL,
  has_bim BOOLEAN DEFAULT FALSE,
  mutuelle_code VARCHAR(3),
  notes TEXT,
  eattest_sent BOOLEAN DEFAULT FALSE,
  eattest_reference VARCHAR(100),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_inami_patient ON inami_acts(patient_id);
CREATE INDEX idx_inami_date ON inami_acts(act_date DESC);
CREATE INDEX idx_inami_code ON inami_acts(act_code);

ALTER TABLE inami_acts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage INAMI acts"
  ON inami_acts FOR ALL
  USING (auth.role() = 'authenticated');

-- ============================================================================
-- PRESCRIPTIONS (Recip-e)
-- ============================================================================
CREATE TABLE prescriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recipe_id VARCHAR(50) UNIQUE NOT NULL, -- BE-2026-XXXX-RXDE
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  medications JSONB NOT NULL DEFAULT '[]'::jsonb,
  notes TEXT,
  prescription_date DATE NOT NULL,
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'dispensed', 'cancelled', 'expired')),
  sent_to_pharmacy BOOLEAN DEFAULT FALSE,
  pharmacy_name VARCHAR(200),
  dispensed_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_prescriptions_patient ON prescriptions(patient_id);
CREATE INDEX idx_prescriptions_recipe ON prescriptions(recipe_id);
CREATE INDEX idx_prescriptions_date ON prescriptions(prescription_date DESC);

ALTER TABLE prescriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage prescriptions"
  ON prescriptions FOR ALL
  USING (auth.role() = 'authenticated');

-- ============================================================================
-- CERTIFICATES (Certificats médicaux)
-- ============================================================================
CREATE TABLE certificates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  certificate_type VARCHAR(50) NOT NULL CHECK (certificate_type IN ('incapacity', 'care', 'medical', 'sport')),
  diagnosis TEXT,
  start_date DATE,
  end_date DATE,
  home_rest BOOLEAN DEFAULT FALSE,
  certificate_date DATE NOT NULL,
  certificate_text TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_certificates_patient ON certificates(patient_id);
CREATE INDEX idx_certificates_date ON certificates(certificate_date DESC);

ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage certificates"
  ON certificates FOR ALL
  USING (auth.role() = 'authenticated');

-- ============================================================================
-- APPOINTMENTS (Rendez-vous)
-- ============================================================================
CREATE TABLE appointments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  duration_minutes INTEGER DEFAULT 60,
  appointment_type VARCHAR(50) DEFAULT 'consultation', -- consultation, suivi, urgence, controle
  status VARCHAR(20) DEFAULT 'confirmed' CHECK (status IN ('confirmed', 'cancelled', 'completed', 'no_show', 'rescheduled')),
  notes TEXT,
  reminder_sent BOOLEAN DEFAULT FALSE,
  reminder_sent_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_appointments_date ON appointments(appointment_date, appointment_time);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_status ON appointments(status) WHERE status IN ('confirmed', 'rescheduled');

ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage appointments"
  ON appointments FOR ALL
  USING (auth.role() = 'authenticated');

-- ============================================================================
-- STAFF PROFILES (Profils utilisateurs)
-- ============================================================================
CREATE TABLE staff_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role VARCHAR(20) NOT NULL CHECK (role IN ('OWNER', 'DENTIST', 'ASSISTANT')),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  inami_number VARCHAR(20), -- Pour les dentistes
  phone VARCHAR(20),
  email VARCHAR(255),
  specialization VARCHAR(100),
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE staff_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view staff"
  ON staff_profiles FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Owners can manage staff"
  ON staff_profiles FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM staff_profiles
      WHERE id = auth.uid() AND role = 'OWNER'
    )
  );

-- ============================================================================
-- XRAYS / IMAGES (Radiographies)
-- ============================================================================
CREATE TABLE xrays (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  xray_type VARCHAR(50) NOT NULL, -- panoramic, periapical, bitewing, cephalometric
  tooth_number VARCHAR(2),
  image_url TEXT NOT NULL, -- Supabase Storage URL
  thumbnail_url TEXT,
  xray_date DATE NOT NULL,
  notes TEXT,
  ai_analysis JSONB, -- IA analysis results
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_xrays_patient ON xrays(patient_id);
CREATE INDEX idx_xrays_date ON xrays(xray_date DESC);

ALTER TABLE xrays ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage xrays"
  ON xrays FOR ALL
  USING (auth.role() = 'authenticated');

-- ============================================================================
-- FUNCTIONS & TRIGGERS
-- ============================================================================

-- Auto-update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_patients_updated_at
  BEFORE UPDATE ON patients
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_dental_charts_updated_at
  BEFORE UPDATE ON dental_charts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- VIEWS (Vues utiles)
-- ============================================================================

-- Vue: Patients avec dernière anamnèse
CREATE VIEW patients_with_latest_anamnesis AS
SELECT
  p.*,
  a.version as latest_anamnesis_version,
  a.content as latest_anamnesis_content,
  a.created_at as latest_anamnesis_date,
  a.type as latest_anamnesis_type
FROM patients p
LEFT JOIN LATERAL (
  SELECT * FROM anamnesis
  WHERE patient_id = p.id
  ORDER BY version DESC
  LIMIT 1
) a ON true;

-- Vue: Rendez-vous du jour
CREATE VIEW todays_appointments AS
SELECT
  a.*,
  p.first_name,
  p.last_name,
  p.phone,
  p.niss
FROM appointments a
JOIN patients p ON a.patient_id = p.id
WHERE a.appointment_date = CURRENT_DATE
  AND a.status IN ('confirmed', 'rescheduled')
ORDER BY a.appointment_time;

-- Vue: Statistiques patients
CREATE VIEW patient_statistics AS
SELECT
  COUNT(*) as total_patients,
  COUNT(*) FILTER (WHERE bim = true) as bim_patients,
  COUNT(*) FILTER (WHERE mutuelle_code = '300') as mc_patients,
  COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '30 days') as new_patients_30d,
  COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '7 days') as new_patients_7d
FROM patients;

-- ============================================================================
-- SAMPLE DATA (Pour tester)
-- ============================================================================

-- Insert sample staff (à exécuter après création du user dans auth.users)
-- INSERT INTO staff_profiles (id, role, first_name, last_name, inami_number, email, active)
-- VALUES
--   ('YOUR-AUTH-USER-ID', 'OWNER', 'Ismail', 'Sialyen', NULL, 'ismail@k2dent.be', true),
--   ('YOUR-AUTH-USER-ID', 'DENTIST', 'Ekaterina', 'SIALYEN', '3-02462-81-001', 'ekaterina@k2dent.be', true);

-- Sample patient (pour tester)
-- INSERT INTO patients (first_name, last_name, niss, date_of_birth, gender, phone, email, mutuelle_code, bim, allergies)
-- VALUES
--   ('Marie', 'Dubois', '85.07.30-123.45', '1985-07-30', 'F', '+32 2 123 45 67', 'marie@example.be', '300', false, 'Pénicilline'),
--   ('Jean', 'Martin', '78.03.15-456.78', '1978-03-15', 'M', '+32 2 234 56 78', 'jean@example.be', '200', false, NULL);

-- ============================================================================
-- BACKUP & MAINTENANCE
-- ============================================================================

-- Enable Point-in-Time Recovery (PITR) automatique dans Supabase Dashboard
-- Backups quotidiens automatiques
-- Retention: 7 jours (Free tier), 30 jours (Pro tier)

COMMENT ON TABLE patients IS 'Patients du cabinet dentaire K2 Dent';
COMMENT ON TABLE anamnesis IS 'Anamnèses avec versioning automatique';
COMMENT ON TABLE timeline_events IS 'Historique complet des événements patient';
COMMENT ON TABLE dental_charts IS 'Schémas dentaires stockés en JSONB';
COMMENT ON TABLE tooth_treatments IS 'Traitements par dent avec FDI notation';
COMMENT ON TABLE inami_acts IS 'Actes INAMI Article 5 pour facturation';
COMMENT ON TABLE prescriptions IS 'Prescriptions Recip-e électroniques';
COMMENT ON TABLE certificates IS 'Certificats médicaux belges';
COMMENT ON TABLE appointments IS 'Agenda des rendez-vous';
COMMENT ON TABLE staff_profiles IS 'Profils du personnel du cabinet';
COMMENT ON TABLE xrays IS 'Radiographies et imagerie médicale';

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
