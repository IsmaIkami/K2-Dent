# K2 DENT — DATA STORAGE STRATEGY
**MVP & Sandbox Demo Architecture**
**Date:** April 3, 2026
**Author:** Ismail Sialyen

---

## 🎯 OBJECTIVE

For the **MVP (Minimum Viable Product)** and **Sandbox Demo**, K2 Dent uses a **100% client-side, zero-backend architecture**. This allows:
- ✅ Immediate deployment (GitHub Pages)
- ✅ Zero infrastructure costs
- ✅ Offline-first capability (PWA)
- ✅ GDPR-compliant (data stays on device)
- ✅ Rapid prototyping and testing

---

## 📊 DATA STORAGE TECHNOLOGIES (MVP)

### 1. **LocalStorage** (Primary Data Store)

**Technology:** Browser Web Storage API
**Capacity:** ~5-10 MB per domain
**Persistence:** Permanent (until cleared)
**Access:** Synchronous JavaScript API

#### What We Store in LocalStorage:

```javascript
// PATIENT DATA
localStorage.setItem('k2dent_patients', JSON.stringify([
  {
    id: "uuid-v4",
    niss: "83.03.05-123.45", // Encrypted in production
    firstName: "Marie",
    lastName: "Dubois",
    dateOfBirth: "1983-03-05",
    mutuelle: { code: "300", name: "MC" },
    bim: false,
    allergies: ["Pénicilline"],
    medications: [],
    // ... full patient schema
  }
]));

// APPOINTMENTS
localStorage.setItem('k2dent_appointments', JSON.stringify([
  {
    id: "uuid-v4",
    patientId: "uuid-v4",
    date: "2026-04-15",
    startTime: "14:30",
    type: "SOIN_CONSERVATEUR",
    status: "CONFIRME"
  }
]));

// INAMI ACTS (Billing)
localStorage.setItem('k2dent_acts', JSON.stringify([
  {
    id: "uuid-v4",
    patientId: "uuid-v4",
    code: "311011", // Obturation 1 surface
    tariff: 36.30,
    patientShare: 7.26,
    mutuelleShare: 29.04,
    performedDate: "2026-04-15",
    eAttestStatus: "PENDING"
  }
]));

// AI ANAMNESIS HISTORY
localStorage.setItem('k2dent_anamnesis_8303051234', JSON.stringify([
  {
    version: 1,
    content: "## Motif de consultation...",
    timestamp: "2026-04-03T10:30:00Z",
    author: "IA Claude Sonnet 4.5",
    type: "AI"
  },
  {
    version: 2,
    content: "## Motif de consultation (modifié)...",
    timestamp: "2026-04-03T10:35:00Z",
    author: "Dr. E. Sialyen",
    type: "MODIFIED"
  }
]));

// PRESCRIPTIONS
localStorage.setItem('k2dent_prescriptions_8303051234', JSON.stringify([
  {
    id: "px1234567890",
    content: "### Amoxicilline 500mg...",
    timestamp: "2026-04-03T10:40:00Z",
    status: "VALIDATED",
    validatedBy: "Dr. E. Sialyen",
    validatedMeds: ["CNK 0067-407"]
  }
]));

// CERTIFICATES
localStorage.setItem('k2dent_certificates', JSON.stringify([
  {
    id: "uuid-v4",
    type: "INCAPACITE_TRAVAIL",
    patientId: "uuid-v4",
    startDate: "2026-04-15",
    endDate: "2026-04-17",
    pdfBase64: "data:application/pdf;base64,..."
  }
]));

// CONFIGURATION
localStorage.setItem('k2dent_config', JSON.stringify({
  practice: {
    name: "Cabinet Dentaire Dr. SIALYEN",
    dentist: "Dr. Ekaterina SIALYEN",
    inami: "3-02462-81-001"
  },
  tariffs: { /* INAMI 2025-2026 */ },
  schedule: { /* Working hours */ }
}));

// API KEY (Encrypted in production)
localStorage.setItem('anthropic_api_key', 'sk-ant-...');
```

#### Advantages:
- ✅ **Instant access** (synchronous, no network delay)
- ✅ **Offline-first** (works without internet)
- ✅ **Zero server costs**
- ✅ **GDPR-compliant** (data stays on user's device)
- ✅ **Simple API** (no ORM, no migrations)

#### Limitations:
- ⚠️ **5-10 MB limit** (enough for ~1000 patients with full history)
- ⚠️ **Single device** (no sync between computers)
- ⚠️ **Browser-dependent** (clearing cache = data loss)

---

### 2. **IndexedDB** (Future: Large Files)

**Technology:** Browser IndexedDB API
**Capacity:** ~50 MB - 1 GB (browser-dependent)
**Persistence:** Permanent
**Access:** Asynchronous (promises)

#### Use Cases (Phase 2):
```javascript
// LARGE FILES (X-rays, CBCT scans, photos)
const db = await openDB('k2dent', 1, {
  upgrade(db) {
    db.createObjectStore('xrays', { keyPath: 'id' });
    db.createObjectStore('photos', { keyPath: 'id' });
    db.createObjectStore('documents', { keyPath: 'id' });
  }
});

// Store X-ray image (5-10 MB each)
await db.put('xrays', {
  id: 'xray-123',
  patientId: 'uuid-v4',
  type: 'panoramic',
  imageBlob: blobData, // Binary data
  date: '2026-04-15',
  aiAnalysis: { caries: [...], lesions: [...] }
});
```

#### When to Use:
- Large binary files (images, PDFs, DICOM)
- Advanced querying (indexes, cursors)
- Transactions (atomic operations)

---

### 3. **Service Worker Cache** (Offline Assets)

**Technology:** Cache API (PWA)
**Capacity:** ~50-100 MB
**Persistence:** Permanent
**Purpose:** Offline functionality

#### What We Cache:
```javascript
// service-worker.js
const CACHE_NAME = 'k2dent-v1.0';
const ASSETS = [
  '/',
  '/index.html',
  '/dashboard.html',
  '/patients.html',
  '/js/belgium.js',
  '/js/ai-dental.js',
  // All HTML, CSS, JS files
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS))
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request);
    })
  );
});
```

#### Benefits:
- ✅ App works 100% offline
- ✅ Instant page loads (no network)
- ✅ Installable as native app (PWA)

---

### 4. **SessionStorage** (Temporary Data)

**Technology:** Browser Session Storage API
**Capacity:** ~5 MB
**Persistence:** Session only (tab close = data cleared)

#### Use Cases:
```javascript
// TEMPORARY FORM DATA (navigation)
sessionStorage.setItem('currentPatient', JSON.stringify({
  id: 'uuid-v4',
  name: 'Marie Dubois'
}));

// MULTI-STEP FORM STATE
sessionStorage.setItem('newAppointmentStep', '2');
```

---

## 🔐 DATA SECURITY (MVP)

### Client-Side Encryption

For sensitive data (NISS, medical info):

```javascript
// Web Crypto API (built-in browser encryption)
async function encryptData(data, password) {
  const enc = new TextEncoder();

  // Derive key from password
  const keyMaterial = await crypto.subtle.importKey(
    "raw",
    enc.encode(password),
    "PBKDF2",
    false,
    ["deriveBits", "deriveKey"]
  );

  const key = await crypto.subtle.deriveKey(
    {
      name: "PBKDF2",
      salt: enc.encode("k2dent-salt-v1"),
      iterations: 100000,
      hash: "SHA-256"
    },
    keyMaterial,
    { name: "AES-GCM", length: 256 },
    false,
    ["encrypt", "decrypt"]
  );

  // Encrypt
  const iv = crypto.getRandomValues(new Uint8Array(12));
  const encrypted = await crypto.subtle.encrypt(
    { name: "AES-GCM", iv },
    key,
    enc.encode(JSON.stringify(data))
  );

  return {
    iv: Array.from(iv),
    data: Array.from(new Uint8Array(encrypted))
  };
}

// Usage
const patient = { niss: "83.03.05-123.45", ... };
const encrypted = await encryptData(patient.niss, userPassword);
localStorage.setItem('patient_123_niss', JSON.stringify(encrypted));
```

**Algorithm:** AES-256-GCM (military-grade)
**Key Derivation:** PBKDF2 (100,000 iterations)
**Compliance:** GDPR/RGPD compliant

---

## 💾 BACKUP & RESTORE

### Auto-Backup (Daily)

```javascript
function autoBackup() {
  const data = {
    patients: JSON.parse(localStorage.getItem('k2dent_patients') || '[]'),
    appointments: JSON.parse(localStorage.getItem('k2dent_appointments') || '[]'),
    acts: JSON.parse(localStorage.getItem('k2dent_acts') || '[]'),
    certificates: JSON.parse(localStorage.getItem('k2dent_certificates') || '[]'),
    config: JSON.parse(localStorage.getItem('k2dent_config') || '{}'),
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  };

  // Download as JSON
  const blob = new Blob([JSON.stringify(data, null, 2)],
                        { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `k2dent-backup-${data.timestamp}.json`;
  a.click();
}

// Run every 24h
setInterval(autoBackup, 24 * 60 * 60 * 1000);
```

### Manual Export/Import

```javascript
// EXPORT
function exportAllData() {
  const allData = {};
  for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i);
    if (key.startsWith('k2dent_')) {
      allData[key] = localStorage.getItem(key);
    }
  }
  return JSON.stringify(allData, null, 2);
}

// IMPORT
function importData(jsonString) {
  const data = JSON.parse(jsonString);
  for (const [key, value] of Object.entries(data)) {
    localStorage.setItem(key, value);
  }
  alert('✅ Data imported successfully!');
  location.reload();
}
```

---

## 🌐 SANDBOX DEMO ENVIRONMENT

### GitHub Pages Deployment

**URL:** https://ismaikami.github.io/K2-Dent/

**Architecture:**
```
┌─────────────────────────────────────────┐
│      GitHub Pages (Static Hosting)      │
│  ┌─────────────────────────────────┐   │
│  │  index.html (Landing)           │   │
│  │  dashboard.html (Main App)      │   │
│  │  patients.html, inami.html...   │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  js/belgium.js (Compliance)     │   │
│  │  js/ai-dental.js (Claude API)   │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
           ↓
    User's Browser
    ┌──────────────────────────┐
    │  LocalStorage (5-10 MB)  │ ← Data stored here
    │  ├─ Patients             │
    │  ├─ Appointments         │
    │  ├─ INAMI Acts           │
    │  ├─ Anamnesis History    │
    │  └─ Prescriptions        │
    └──────────────────────────┘
           ↓
    Claude API (Anthropic)
    ┌──────────────────────────┐
    │  https://api.anthropic.  │
    │  com/v1/messages         │
    │  ├─ Anamnesis Gen        │
    │  └─ Prescription Gen     │
    └──────────────────────────┘
```

### Demo Data Pre-loaded

```javascript
// On first load, populate with demo data
if (!localStorage.getItem('k2dent_patients')) {
  const demoData = {
    patients: [
      {
        id: "demo-001",
        firstName: "Marie",
        lastName: "Dubois",
        niss: "83.03.05-123.45",
        mutuelle: { code: "300", name: "MC" },
        bim: false,
        allergies: ["Pénicilline"],
        // ... full demo patient
      },
      {
        id: "demo-002",
        firstName: "Jean",
        lastName: "Martin",
        niss: "75.06.12-456.78",
        mutuelle: { code: "200", name: "Solidaris" },
        bim: true,
        allergies: [],
      }
    ],
    appointments: [
      {
        id: "demo-apt-001",
        patientId: "demo-001",
        date: "2026-04-15",
        startTime: "14:30",
        type: "SOIN_CONSERVATEUR",
        status: "CONFIRME"
      }
    ]
  };

  localStorage.setItem('k2dent_patients', JSON.stringify(demoData.patients));
  localStorage.setItem('k2dent_appointments', JSON.stringify(demoData.appointments));

  console.log('✅ Demo data loaded');
}
```

### Sandbox vs Production

| Feature | Sandbox (MVP) | Production (Phase 2) |
|---------|---------------|----------------------|
| **Data Storage** | LocalStorage | PostgreSQL + Redis |
| **File Storage** | Base64 in LocalStorage | S3 / MinIO |
| **API Backend** | None (client-only) | Fastify REST API |
| **Database** | Browser (5-10 MB) | Cloud DB (unlimited) |
| **Multi-user** | ❌ Single device | ✅ Multi-dentist |
| **Sync** | ❌ No sync | ✅ Real-time sync |
| **MyCareNet** | Stubs (console.log) | Real API integration |
| **eAttest** | Mock XML generation | Real eAttest V3 |
| **Backup** | Manual export/import | Automated cloud backup |
| **Cost** | €0 (GitHub Pages) | €200-400/mo (AWS) |

---

## 🚀 MIGRATION PATH (MVP → Production)

### Phase 1: MVP (Now)
```
Browser LocalStorage → All data client-side
GitHub Pages → Free hosting
Claude API → Direct from browser
```

### Phase 2: Backend (Month 2-3)
```javascript
// Add backend API
const API_URL = 'https://api.k2dent.be';

// Sync LocalStorage → PostgreSQL
async function migrateToBackend() {
  const patients = JSON.parse(localStorage.getItem('k2dent_patients'));

  for (const patient of patients) {
    await fetch(`${API_URL}/patients`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${userToken}`
      },
      body: JSON.stringify(patient)
    });
  }

  console.log('✅ Migration complete');
}
```

### Phase 3: Cloud (Month 4-6)
```
AWS EKS (Kubernetes) → Scalable infrastructure
PostgreSQL RDS → Primary database
Redis ElastiCache → Sessions & cache
S3 → Document storage
CloudFront → CDN
```

---

## 📈 STORAGE CAPACITY ESTIMATES

### MVP (LocalStorage - 5-10 MB)

```
Patient Records:
- 1 patient = ~2 KB (full data)
- 1000 patients = 2 MB ✅

Appointments:
- 1 appointment = ~500 bytes
- 5000 appointments = 2.5 MB ✅

INAMI Acts:
- 1 act = ~300 bytes
- 10,000 acts = 3 MB ✅

Anamnesis History:
- 1 anamnesis = ~3 KB
- 1000 anamnesis = 3 MB ✅

TOTAL: ~10 MB for:
✅ 1000 patients
✅ 5000 appointments
✅ 10,000 INAMI acts
✅ 1000 anamnesis versions

This covers:
- 1-2 years of solo dentist practice
- ~15-20 patients/day × 250 days/year = 3750-5000 consultations
```

### When to Migrate to Backend:

**Triggers:**
- ⚠️ LocalStorage > 80% full (8 MB used)
- ⚠️ Need multi-device access
- ⚠️ Team collaboration (multiple dentists)
- ⚠️ Real MyCareNet integration required
- ⚠️ > 2000 patients

**Timeline:**
- Month 1-2: MVP with LocalStorage (Dr. Sialyen solo practice)
- Month 3-4: Backend API development
- Month 5-6: Migration to cloud infrastructure

---

## 🎯 ADVANTAGES FOR DEMO

### Why LocalStorage for Sandbox:

1. **Instant Setup** ✅
   - No database to configure
   - No server to deploy
   - Copy files → works immediately

2. **Zero Costs** ✅
   - GitHub Pages: Free
   - No backend hosting: €0/month
   - Only Claude API costs: pay-per-use

3. **Privacy-First** ✅
   - Data never leaves device
   - GDPR-compliant by design
   - No data breach risk (no server to hack)

4. **Offline-First** ✅
   - Works without internet
   - Perfect for clinics with poor WiFi
   - No "server down" issues

5. **Easy Demo** ✅
   - Send link → anyone can test
   - No account creation needed
   - Pre-loaded demo data

---

## 🔧 DEVELOPER TOOLS

### Inspect LocalStorage (Chrome DevTools)

```
1. Open K2 Dent app
2. Right-click → Inspect
3. Application tab → Storage → Local Storage
4. https://ismaikami.github.io
5. See all k2dent_* keys
```

### Clear All Data (Reset Demo)

```javascript
// Console command
Object.keys(localStorage)
  .filter(key => key.startsWith('k2dent_'))
  .forEach(key => localStorage.removeItem(key));

location.reload();
```

### Export Data (Backup)

```javascript
// Console command
const data = {};
Object.keys(localStorage).forEach(key => {
  if (key.startsWith('k2dent_')) data[key] = localStorage.getItem(key);
});
console.log(JSON.stringify(data, null, 2));
// Copy output → save to file
```

---

## 📋 SUMMARY

**Current MVP Architecture:**
- ✅ **100% client-side** (no backend)
- ✅ **LocalStorage** for all data (5-10 MB)
- ✅ **GitHub Pages** for hosting (free)
- ✅ **Claude API** for AI features (direct calls)
- ✅ **Service Worker** for offline mode
- ✅ **Web Crypto API** for encryption

**Capacity:**
- ✅ 1000 patients with full history
- ✅ 5000 appointments
- ✅ 10,000 INAMI acts
- ✅ 1-2 years of solo practice

**Migration:**
- 🔶 Phase 2 (Month 3-4): Add backend API
- 🔶 Phase 3 (Month 5-6): Cloud infrastructure

**Status:** ✅ **PRODUCTION-READY FOR MVP**

---

**Author:** Ismail Sialyen
**Date:** April 3, 2026
**Version:** 1.0 MVP
