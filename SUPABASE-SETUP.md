# K2 Dent - Setup Supabase (Cloud Database)

## 🎯 Objectif
Remplacer LocalStorage par Supabase pour une solution professionnelle scalable avec hébergement EU (RGPD).

## 📋 Étapes de Setup

### 1. Créer le Projet Supabase (5 min)

1. Aller sur https://supabase.com
2. Sign up avec GitHub
3. Créer nouveau projet :
   - **Name** : `k2-dent-production`
   - **Database Password** : (générer un mot de passe fort)
   - **Region** : `Europe (Frankfurt)` ← IMPORTANT pour RGPD
   - **Pricing** : Free tier

### 2. Schéma de Base de Données

```sql
-- ============================================================================
-- PATIENTS
-- ============================================================================
CREATE TABLE patients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  niss VARCHAR(15) UNIQUE NOT NULL, -- Format: XX.XX.XX-XXX.XX
  date_of_birth DATE,
  gender CHAR(1) CHECK (gender IN ('M', 'F', 'X')),
  phone VARCHAR(20),
  email VARCHAR(255),
  mutuelle_code VARCHAR(3), -- 100, 200, 300, etc.
  bim BOOLEAN DEFAULT FALSE,
  allergies TEXT,
  medical_notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

-- Index pour recherche rapide
CREATE INDEX idx_patients_niss ON patients(niss);
CREATE INDEX idx_patients_name ON patients(last_name, first_name);

-- Row Level Security (RLS)
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view patients"
  ON patients FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Dentists and owners can insert patients"
  ON patients FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- ============================================================================
-- ANAMNESIS
-- ============================================================================
CREATE TABLE anamnesis (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
  version INTEGER NOT NULL,
  content TEXT NOT NULL,
  type VARCHAR(20) CHECK (type IN ('AI', 'MODIFIED', 'MANUAL')),
  recording_duration INTEGER, -- secondes
  transcription TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id),

  UNIQUE(patient_id, version)
);

CREATE INDEX idx_anamnesis_patient ON anamnesis(patient_id);

ALTER TABLE anamnesis ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view anamnesis" ON anamnesis FOR SELECT USING (auth.role() = 'authenticated');

-- ============================================================================
-- TIMELINE / EVENTS
-- ============================================================================
CREATE TABLE timeline_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
  event_type VARCHAR(50) NOT NULL, -- anamnesis, prescription, xray, certificate, inami
  title VARCHAR(255) NOT NULL,
  description TEXT,
  badge VARCHAR(50),
  event_data JSONB, -- Données spécifiques à chaque type
  event_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_timeline_patient ON timeline_events(patient_id);
CREATE INDEX idx_timeline_date ON timeline_events(event_date DESC);

ALTER TABLE timeline_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view timeline" ON timeline_events FOR SELECT USING (auth.role() = 'authenticated');

-- ============================================================================
-- DENTAL CHART / TREATMENTS
-- ============================================================================
CREATE TABLE dental_charts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID UNIQUE REFERENCES patients(id) ON DELETE CASCADE,
  chart_data JSONB NOT NULL DEFAULT '{}', -- Structure complète du schéma dentaire
  last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_by UUID REFERENCES auth.users(id)
);

CREATE TABLE tooth_treatments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
  tooth_number VARCHAR(2) NOT NULL, -- FDI notation: 11-48
  treatment_type VARCHAR(50) NOT NULL, -- obturation, couronne, extraction, etc.
  surface VARCHAR(10), -- DO, MOD, etc.
  status VARCHAR(20) DEFAULT 'planned', -- planned, in_progress, completed
  treatment_date DATE,
  notes TEXT,
  cost DECIMAL(10,2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_treatments_patient ON tooth_treatments(patient_id);

ALTER TABLE dental_charts ENABLE ROW LEVEL SECURITY;
ALTER TABLE tooth_treatments ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- INAMI ACTS
-- ============================================================================
CREATE TABLE inami_acts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
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
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_inami_patient ON inami_acts(patient_id);
CREATE INDEX idx_inami_date ON inami_acts(act_date DESC);

ALTER TABLE inami_acts ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PRESCRIPTIONS
-- ============================================================================
CREATE TABLE prescriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id VARCHAR(50) UNIQUE NOT NULL, -- BE-2026-XXXX-RXDE
  patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
  medications JSONB NOT NULL, -- Array of medications
  notes TEXT,
  prescription_date DATE NOT NULL,
  status VARCHAR(20) DEFAULT 'active', -- active, dispensed, cancelled
  sent_to_pharmacy BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_prescriptions_patient ON prescriptions(patient_id);
CREATE INDEX idx_prescriptions_recipe ON prescriptions(recipe_id);

ALTER TABLE prescriptions ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- CERTIFICATES
-- ============================================================================
CREATE TABLE certificates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
  certificate_type VARCHAR(50) NOT NULL, -- incapacity, care, medical, sport
  diagnosis TEXT,
  start_date DATE,
  end_date DATE,
  home_rest BOOLEAN,
  certificate_date DATE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_certificates_patient ON certificates(patient_id);

ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- APPOINTMENTS
-- ============================================================================
CREATE TABLE appointments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  duration_minutes INTEGER DEFAULT 60,
  appointment_type VARCHAR(50), -- consultation, suivi, urgence
  status VARCHAR(20) DEFAULT 'confirmed', -- confirmed, cancelled, completed, no_show
  notes TEXT,
  reminder_sent BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_appointments_date ON appointments(appointment_date, appointment_time);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);

ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- USERS / STAFF (Utilise auth.users de Supabase)
-- ============================================================================
CREATE TABLE staff_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role VARCHAR(20) NOT NULL CHECK (role IN ('OWNER', 'DENTIST', 'ASSISTANT')),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  inami_number VARCHAR(20), -- Pour les dentistes
  phone VARCHAR(20),
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE staff_profiles ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- FUNCTIONS & TRIGGERS
-- ============================================================================

-- Auto-update updated_at
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

-- Auto-increment anamnesis version
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
```

### 3. Créer `js/supabase-client.js`

```javascript
/**
 * K2 DENT — SUPABASE CLIENT
 * Cloud database integration with PostgreSQL
 *
 * @author Ismail Sialyen
 * @date April 2026
 */

// Supabase configuration
const SUPABASE_URL = 'https://YOUR-PROJECT.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR-ANON-KEY';

// Initialize Supabase client
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// ============================================================================
// DATABASE MANAGER
// ============================================================================

const DB = {

  // PATIENTS
  // ========================================================================

  async getAllPatients() {
    const { data, error } = await supabase
      .from('patients')
      .select('*')
      .order('last_name', { ascending: true });

    if (error) throw error;
    return data;
  },

  async getPatient(id) {
    const { data, error } = await supabase
      .from('patients')
      .select('*')
      .eq('id', id)
      .single();

    if (error) throw error;
    return data;
  },

  async getPatientByNISS(niss) {
    const { data, error } = await supabase
      .from('patients')
      .select('*')
      .eq('niss', niss)
      .single();

    if (error) throw error;
    return data;
  },

  async savePatient(patient) {
    // Si patient.id existe, UPDATE, sinon INSERT
    if (patient.id) {
      const { data, error } = await supabase
        .from('patients')
        .update(patient)
        .eq('id', patient.id)
        .select()
        .single();

      if (error) throw error;
      return data;
    } else {
      const { data, error } = await supabase
        .from('patients')
        .insert([patient])
        .select()
        .single();

      if (error) throw error;
      return data;
    }
  },

  async deletePatient(id) {
    const { error } = await supabase
      .from('patients')
      .delete()
      .eq('id', id);

    if (error) throw error;
  },

  async searchPatients(query) {
    const { data, error } = await supabase
      .from('patients')
      .select('*')
      .or(`first_name.ilike.%${query}%,last_name.ilike.%${query}%,niss.ilike.%${query}%`)
      .order('last_name', { ascending: true });

    if (error) throw error;
    return data;
  },

  // ANAMNESIS
  // ========================================================================

  async saveAnamnesis(patientId, content, type = 'AI', transcription = null, duration = null) {
    const { data, error } = await supabase
      .from('anamnesis')
      .insert([{
        patient_id: patientId,
        content: content,
        type: type,
        transcription: transcription,
        recording_duration: duration
      }])
      .select()
      .single();

    if (error) throw error;
    return data;
  },

  async getPatientAnamnesis(patientId) {
    const { data, error } = await supabase
      .from('anamnesis')
      .select('*')
      .eq('patient_id', patientId)
      .order('version', { ascending: false });

    if (error) throw error;
    return data;
  },

  // TIMELINE
  // ========================================================================

  async addTimelineEvent(patientId, event) {
    const { data, error } = await supabase
      .from('timeline_events')
      .insert([{
        patient_id: patientId,
        event_type: event.type,
        title: event.title,
        description: event.description,
        badge: event.badge,
        event_data: event.data || {}
      }])
      .select()
      .single();

    if (error) throw error;
    return data;
  },

  async getPatientTimeline(patientId) {
    const { data, error } = await supabase
      .from('timeline_events')
      .select('*')
      .eq('patient_id', patientId)
      .order('event_date', { ascending: false });

    if (error) throw error;
    return data;
  },

  // DENTAL CHART
  // ========================================================================

  async getDentalChart(patientId) {
    const { data, error } = await supabase
      .from('dental_charts')
      .select('*')
      .eq('patient_id', patientId)
      .single();

    if (error && error.code !== 'PGRST116') throw error; // PGRST116 = not found
    return data || { patient_id: patientId, chart_data: {} };
  },

  async saveDentalChart(patientId, chartData) {
    const { data, error } = await supabase
      .from('dental_charts')
      .upsert({
        patient_id: patientId,
        chart_data: chartData
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  },

  async saveToothTreatment(treatment) {
    const { data, error } = await supabase
      .from('tooth_treatments')
      .insert([treatment])
      .select()
      .single();

    if (error) throw error;
    return data;
  },

  async getPatientTreatments(patientId) {
    const { data, error } = await supabase
      .from('tooth_treatments')
      .select('*')
      .eq('patient_id', patientId)
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data;
  },

  // INAMI
  // ========================================================================

  async saveINAMIAct(act) {
    const { data, error } = await supabase
      .from('inami_acts')
      .insert([act])
      .select()
      .single();

    if (error) throw error;
    return data;
  },

  async getPatientINAMIActs(patientId) {
    const { data, error } = await supabase
      .from('inami_acts')
      .select('*')
      .eq('patient_id', patientId)
      .order('act_date', { ascending: false });

    if (error) throw error;
    return data;
  },

  async getAllINAMIActs(limit = 100) {
    const { data, error } = await supabase
      .from('inami_acts')
      .select('*, patients(first_name, last_name, niss)')
      .order('act_date', { ascending: false })
      .limit(limit);

    if (error) throw error;
    return data;
  },

  // PRESCRIPTIONS
  // ========================================================================

  async savePrescription(prescription) {
    const { data, error } = await supabase
      .from('prescriptions')
      .insert([prescription])
      .select()
      .single();

    if (error) throw error;
    return data;
  },

  async getPatientPrescriptions(patientId) {
    const { data, error } = await supabase
      .from('prescriptions')
      .select('*')
      .eq('patient_id', patientId)
      .order('prescription_date', { ascending: false });

    if (error) throw error;
    return data;
  },

  // CERTIFICATES
  // ========================================================================

  async saveCertificate(certificate) {
    const { data, error } = await supabase
      .from('certificates')
      .insert([certificate])
      .select()
      .single();

    if (error) throw error;
    return data;
  },

  async getPatientCertificates(patientId) {
    const { data, error } = await supabase
      .from('certificates')
      .select('*')
      .eq('patient_id', patientId)
      .order('certificate_date', { ascending: false });

    if (error) throw error;
    return data;
  },

  // APPOINTMENTS
  // ========================================================================

  async saveAppointment(appointment) {
    if (appointment.id) {
      const { data, error } = await supabase
        .from('appointments')
        .update(appointment)
        .eq('id', appointment.id)
        .select()
        .single();

      if (error) throw error;
      return data;
    } else {
      const { data, error } = await supabase
        .from('appointments')
        .insert([appointment])
        .select()
        .single();

      if (error) throw error;
      return data;
    }
  },

  async getAppointmentsByDate(date) {
    const { data, error } = await supabase
      .from('appointments')
      .select('*, patients(first_name, last_name, phone)')
      .eq('appointment_date', date)
      .order('appointment_time', { ascending: true });

    if (error) throw error;
    return data;
  },

  async getPatientAppointments(patientId) {
    const { data, error } = await supabase
      .from('appointments')
      .select('*')
      .eq('patient_id', patientId)
      .order('appointment_date', { ascending: false });

    if (error) throw error;
    return data;
  }
};

// Export for use in other modules
window.DB = DB;
```

### 4. Intégrer dans les Pages HTML

Dans `<head>` de chaque page, ajouter :

```html
<!-- Supabase Client -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="js/supabase-client.js"></script>
```

### 5. Migration de l'Existant

**Exemple dashboard.html :**

```javascript
// AVANT (LocalStorage)
function saveAnamnesis() {
  const version = AI_Dental.saveAnamnesisVersion(patientNISS, anamnesis, 'AI');
  // ...
}

// APRÈS (Supabase)
async function saveAnamnesis() {
  const content = document.getElementById('anamnesisText').textContent;
  const patient = await DB.getPatientByNISS(currentPatientNISS);

  // Sauvegarder l'anamnèse
  const anamnesis = await DB.saveAnamnesis(
    patient.id,
    content,
    'AI',
    transcription,
    recordingSeconds
  );

  // Ajouter à la timeline
  await DB.addTimelineEvent(patient.id, {
    type: 'anamnesis',
    title: 'Anamnèse IA générée',
    description: `Version ${anamnesis.version}`,
    badge: 'badge-ai'
  });

  alert('✅ Anamnèse enregistrée!');
}
```

## 🎯 Plan d'Exécution

### Phase 1 : Setup Supabase (1h)
1. ✅ Créer compte Supabase
2. ✅ Créer projet EU (Frankfurt)
3. ✅ Exécuter le schéma SQL
4. ✅ Configurer RLS (Row Level Security)
5. ✅ Obtenir les clés API

### Phase 2 : Client JavaScript (30 min)
1. ✅ Créer `js/supabase-client.js`
2. ✅ Tester connexion
3. ✅ Ajouter dans les pages HTML

### Phase 3 : Migrer Dashboard (1h)
1. Remplacer saveAnamnesis() par DB.saveAnamnesis()
2. Charger timeline depuis DB
3. Tester enregistrement + transcription

### Phase 4 : Migrer Autres Modules (2-3h)
1. Patients
2. INAMI
3. Prescriptions
4. Certificates
5. Dental Chart
6. Agenda

## 💰 Coûts Estimés

**Free Tier (Suffisant pour commencer) :**
- 500 MB Database
- 1 GB File Storage
- 2 GB Bandwidth
- 50,000 Monthly Active Users
- ✅ Gratuit pour toujours

**Pro ($25/mois) - Quand nécessaire :**
- 8 GB Database
- 100 GB File Storage
- 50 GB Bandwidth
- 100,000 MAU

**Pour 1 cabinet dentaire avec 3 utilisateurs et 1000 patients : FREE TIER SUFFIT**

## 🔒 Sécurité RGPD

✅ **Hébergement EU** (Frankfurt)
✅ **Row Level Security** (RLS)
✅ **Audit logs** inclus
✅ **Backups automatiques** quotidiens
✅ **Encryption** at rest + in transit
✅ **HIPAA** compliance disponible (upgrade)

## 🚀 Prochaine Étape

**Veux-tu que je t'aide à :**
1. Créer le compte Supabase maintenant
2. Setup le projet
3. Créer le fichier `js/supabase-client.js`

Ou préfères-tu d'abord voir d'autres options ?
