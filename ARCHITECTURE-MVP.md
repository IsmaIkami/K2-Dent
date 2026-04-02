# K2 DENT — MVP ARCHITECTURE & TECH STACK
**Version:** 1.0 MVP (Production-Ready)
**Target:** Dr. Ekaterina SIALYEN — Cabinet Dentaire, Zaventem/Sterrebeek, Belgium
**INAMI:** 3-02462-81-001
**Date:** April 2, 2026
**Author:** Ismail Sialyen

---

## 🎯 EXECUTIVE SUMMARY

**Goal:** Working dental practice management system in production within 2 weeks
**Compliance:** Belgian healthcare (INAMI, MyCareNet, RGPD/GDPR)
**Expansion:** Modular architecture ready for kinésithérapeutes, médecins généralistes
**Technology:** Progressive Web App (PWA) — no backend required for MVP

---

## 📚 TABLE OF CONTENTS

1. [Tech Stack](#tech-stack)
2. [Architecture Overview](#architecture-overview)
3. [Data Model](#data-model)
4. [Belgian Compliance Requirements](#belgian-compliance-requirements)
5. [Module Specifications](#module-specifications)
6. [Expansion Strategy](#expansion-strategy)
7. [Development Phases](#development-phases)
8. [Deployment Plan](#deployment-plan)

---

## 1. TECH STACK

### Frontend (MVP — No Build Step)
```
├── HTML5 (Semantic)
├── CSS3 (Modern Grid/Flexbox, CSS Variables)
├── JavaScript ES6+ (Vanilla, no frameworks)
├── LocalStorage API (data persistence)
├── IndexedDB (future: large datasets, attachments)
├── Service Worker (PWA, offline capability)
├── Web Crypto API (client-side encryption for sensitive data)
└── Print API (PDF generation via browser print)
```

### Libraries (CDN, No Build)
```
├── Day.js (date handling, lightweight)
├── jsPDF (PDF generation for certificates)
├── html2canvas (document screenshots)
├── QRCode.js (eAttest/Recip-e QR codes)
└── Chart.js (statistics visualization)
```

### Backend (Phase 2 — Future)
```
├── Node.js 20+ / Bun 1.0+
├── Fastify (REST API)
├── PostgreSQL 16+ (structured data, audit logs)
├── MongoDB 7+ (flexible schemas for multi-specialty)
├── Redis 7+ (sessions, cache)
└── MinIO / S3 (document storage)
```

### Belgian Healthcare Integration (Phase 2)
```
├── MyCareNet CIN (eAttest V3, eFact, consultation rights)
├── eHealth Platform (eHealthBox, Recip-e Hub)
├── NISS validation service
└── Mutuelle APIs (CM, Solidaris, etc.)
```

### Infrastructure (Current: GitHub Pages)
```
MVP (Now):
├── GitHub Pages (static hosting, free SSL)
├── Custom domain: k2dent.be (recommended)
└── Cloudflare (CDN, DDoS protection)

Production (Phase 2):
├── AWS / Azure Belgium region (GDPR compliance)
├── Kubernetes (scalability)
├── CloudFlare (CDN + WAF)
└── Let's Encrypt (SSL/TLS)
```

---

## 2. ARCHITECTURE OVERVIEW

### 2.1 Current MVP Architecture (Offline-First PWA)

```
┌─────────────────────────────────────────────────────────────┐
│                      K2 DENT — MVP                          │
│                   Progressive Web App                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
├─────────────────────────────────────────────────────────────┤
│  HTML5 Pages (Multi-language FR/NL/DE/EN)                   │
│  ├── index.html (Landing page)                              │
│  ├── dashboard.html (Main cockpit)                          │
│  ├── patients.html (Patient management)                     │
│  ├── agenda.html (Appointments)                             │
│  ├── inami.html (Belgian nomenclature, eAttest)             │
│  ├── mutuelles.html (Insurance verification)                │
│  ├── certificates.html (Medical certificates)               │
│  └── billing.html (Revenue tracking)                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      BUSINESS LOGIC LAYER                    │
├─────────────────────────────────────────────────────────────┤
│  JavaScript Modules (ES6)                                    │
│  ├── patient.service.js (CRUD, NISS validation)             │
│  ├── agenda.service.js (Calendar logic)                     │
│  ├── inami.service.js (Nomenclature, tariffs)               │
│  ├── mutuelle.service.js (Insurance checks)                 │
│  ├── certificate.service.js (PDF generation)                │
│  ├── billing.service.js (Revenue calculations)              │
│  ├── auth.service.js (Login, session)                       │
│  └── storage.service.js (LocalStorage abstraction)          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        DATA LAYER                            │
├─────────────────────────────────────────────────────────────┤
│  LocalStorage (MVP)                                          │
│  ├── k2dent_patients (encrypted JSON)                       │
│  ├── k2dent_appointments (encrypted JSON)                   │
│  ├── k2dent_acts (INAMI acts performed)                     │
│  ├── k2dent_certificates (generated docs)                   │
│  ├── k2dent_config (settings, tariffs)                      │
│  └── k2dent_session (user auth)                             │
│                                                              │
│  Future: IndexedDB → PostgreSQL → Multi-tenant DB           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    INTEGRATION LAYER (Stubs)                 │
├─────────────────────────────────────────────────────────────┤
│  MyCareNet CIN (Phase 2)                                     │
│  ├── eAttest V3 (same-day mandate)                          │
│  ├── eFact (tiers payant)                                   │
│  └── Consultation Rights (assurabilité)                     │
│                                                              │
│  eHealth Platform (Phase 2)                                  │
│  ├── Recip-e Hub (electronic prescriptions)                 │
│  └── eHealthBox (secure messaging)                          │
│                                                              │
│  MVP: Console.log stubs with realistic data structures      │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Future Architecture (Phase 2: Backend + Real Integrations)

```
┌──────────────────────────────────────────────────────────────┐
│                    FRONTEND (PWA)                             │
│  Next.js 15+ or Pure HTML/CSS/JS (same codebase)             │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼ HTTPS/WSS
┌──────────────────────────────────────────────────────────────┐
│                      API GATEWAY                              │
│  Fastify + tRPC / REST                                        │
│  ├── Authentication (JWT RS256)                              │
│  ├── Rate Limiting                                           │
│  ├── Request Validation                                      │
│  └── CORS / CSRF Protection                                  │
└──────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌──────────────┐    ┌──────────────┐     ┌──────────────┐
│  PATIENT     │    │   AGENDA     │     │    INAMI     │
│  SERVICE     │    │   SERVICE    │     │   SERVICE    │
└──────────────┘    └──────────────┘     └──────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              ▼
┌──────────────────────────────────────────────────────────────┐
│                      DATABASE LAYER                           │
├──────────────────────────────────────────────────────────────┤
│  PostgreSQL (Primary)          MongoDB (Flexible)             │
│  ├── Patients                  ├── Attachments                │
│  ├── Appointments              ├── Images (X-rays)            │
│  ├── Acts (INAMI)              └── Templates                  │
│  ├── Invoices                                                 │
│  ├── Certificates                                             │
│  └── Audit Logs                                               │
│                                                               │
│  Redis (Cache + Sessions)      MinIO/S3 (Files)              │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────┐
│              BELGIAN HEALTHCARE INTEGRATIONS                  │
├──────────────────────────────────────────────────────────────┤
│  MyCareNet CIN                                                │
│  ├── eAttest V3 (SOAP/REST)                                  │
│  ├── eFact (tiers payant)                                    │
│  └── ConsultRN (assurabilité check)                          │
│                                                               │
│  eHealth Platform                                             │
│  ├── Recip-e Hub (prescriptions)                             │
│  ├── eHealthBox (messaging)                                  │
│  └── Sumehr (patient summary)                                │
└──────────────────────────────────────────────────────────────┘
```

---

## 3. DATA MODEL

### 3.1 Patient Entity (MVP)

```javascript
{
  id: "uuid-v4",                     // Unique patient ID
  niss: "85.01.15-123.45",           // Belgian NISS (encrypted)
  firstName: "Marie",
  lastName: "Dupont",
  dateOfBirth: "1985-01-15",         // ISO 8601
  age: 41,                           // Auto-calculated
  gender: "F",                        // M/F/X
  language: "FR",                     // FR/NL/DE/EN

  // Contact
  phone: "+32 2 123 45 67",
  mobile: "+32 475 12 34 56",
  email: "marie.dupont@example.be",
  address: {
    street: "Avenue des Mimosas",
    number: "42",
    box: "3",
    postalCode: "1930",
    city: "Zaventem",
    country: "BE"
  },

  // Insurance
  mutuelle: {
    code: "300",                      // CM/MC
    name: "Mutualité Chrétienne",
    memberNumber: "12345678-901",
    bim: false,                       // Statut BIM (intervention majorée)
    dmg: true,                        // Dossier Médical Global
    dmgDoctor: "Dr. Dubois"
  },

  // Medical
  allergies: ["Pénicilline", "Latex"],
  medicalNotes: "Diabète type 2, HTA sous traitement",
  lastVisit: "2026-03-15T10:30:00Z",

  // Metadata
  createdAt: "2024-06-10T14:23:00Z",
  updatedAt: "2026-04-02T09:15:00Z",
  status: "active"                    // active/inactive/deceased
}
```

### 3.2 Appointment Entity

```javascript
{
  id: "uuid-v4",
  patientId: "uuid-v4",               // FK to Patient
  patientName: "Marie Dupont",        // Denormalized for quick display

  // Scheduling
  date: "2026-04-15",                 // ISO date
  startTime: "14:30",                 // HH:mm
  endTime: "15:00",                   // HH:mm
  duration: 30,                       // minutes

  // Appointment details
  type: "SOIN_CONSERVATEUR",          // Enum: CONTROLE, SOIN_CONSERVATEUR,
                                      // EXTRACTION, DETARTRAGE, URGENCE,
                                      // IMPLANT, ESTHETIQUE, PARODONTOLOGIE
  reason: "Obturation dent 16",
  status: "CONFIRME",                 // CONFIRME, EN_ATTENTE, ANNULE, PRESENT,
                                      // ABSENT, TERMINE

  // Communication
  reminderSent: false,
  reminderDate: null,
  notes: "Patient préfère anesthésie locale sans adrénaline",

  // Metadata
  createdAt: "2026-03-20T11:00:00Z",
  createdBy: "Dr. E. SIALYEN"
}
```

### 3.3 INAMI Act Entity

```javascript
{
  id: "uuid-v4",
  patientId: "uuid-v4",
  appointmentId: "uuid-v4",           // Optional FK

  // INAMI Nomenclature
  code: "311011",                     // INAMI code (7 digits)
  description: "Obturation 1 surface",
  tooth: "16",                        // FDI notation (optional)

  // Tarification
  tariffType: "CONVENTIONNE",         // CONVENTIONNE / NON_CONVENTIONNE
  baseAmount: 28.47,                  // INAMI base tariff (€)
  patientShare: 8.54,                 // Ticket modérateur (€)
  insuranceShare: 19.93,              // Part mutuelle (€)
  supplement: 0.00,                   // Supplément d'honoraires (€)
  totalAmount: 28.47,                 // Total facturé (€)

  // Payment
  paymentStatus: "PAYE",              // PAYE / EN_ATTENTE / TIERS_PAYANT
  paymentMethod: "CASH",              // CASH / CARD / TRANSFER / TIERS_PAYANT
  paidAmount: 8.54,
  paidDate: "2026-04-15",

  // eAttest
  eAttestStatus: "PENDING",           // PENDING / SENT / ACCEPTED / REJECTED
  eAttestId: null,
  eAttestDate: null,

  // Metadata
  performedDate: "2026-04-15",
  performedBy: "Dr. E. SIALYEN",
  inami: "3-02462-81-001",
  createdAt: "2026-04-15T15:05:00Z"
}
```

### 3.4 Certificate Entity

```javascript
{
  id: "uuid-v4",
  patientId: "uuid-v4",
  type: "INCAPACITE_TRAVAIL",         // INCAPACITE_TRAVAIL, SOINS_DONNES,
                                      // MUTUELLE, SCOLAIRE

  // Content
  startDate: "2026-04-15",
  endDate: "2026-04-17",              // null for single-day
  days: 3,
  reason: "Extraction dentaire compliquée",
  additionalNotes: "Repos recommandé",

  // Generated document
  pdfUrl: "blob:...",                 // Blob URL (LocalStorage base64)
  generatedAt: "2026-04-15T15:30:00Z",
  issuedBy: "Dr. Ekaterina SIALYEN",
  inami: "3-02462-81-001",
  signature: "base64-encoded-signature"
}
```

### 3.5 Configuration Entity (Singleton)

```javascript
{
  // Practice Info
  practice: {
    name: "Cabinet Dentaire Dr. SIALYEN",
    dentist: "Dr. Ekaterina SIALYEN",
    inami: "3-02462-81-001",
    type: "Dentiste généraliste",
    riziv: "3-02462-81-001",          // Same as INAMI

    address: {
      street: "...",
      postalCode: "1930/1933",
      city: "Zaventem/Sterrebeek",
      country: "Belgium"
    },

    contact: {
      phone: "+32 2 XXX XX XX",
      email: "contact@k2dent.be",
      website: "https://k2dent.be"
    }
  },

  // INAMI Tariffs (2025-2026)
  tariffs: {
    "101035": { code: "101035", desc: "Consultation ≥19 ans",
                conventionne: 26.86, patientShare: 8.06 },
    "301010": { code: "301010", desc: "Examen buccal annuel",
                conventionne: 26.86, patientShare: 8.06 },
    "303013": { code: "303013", desc: "Détartrage quadrant",
                conventionne: 28.47, patientShare: 8.54 },
    "311011": { code: "311011", desc: "Obturation 1 surface",
                conventionne: 28.47, patientShare: 8.54 },
    // ... all INAMI codes
  },

  // Mutuelles
  mutuelles: [
    { code: "300", name: "CM/MC (Mutualité Chrétienne)" },
    { code: "200", name: "Solidaris" },
    { code: "400", name: "Partenamut" },
    { code: "500", name: "Mutlib (Lib. Vlaams. Mut.)" },
    { code: "600", name: "CAAMI" },
    { code: "900", name: "HR Rail" },
    { code: "100", name: "UNMS (Neutre/Lib.)" }
  ],

  // Working hours (for agenda)
  schedule: {
    monday:    { open: true,  start: "09:00", end: "18:00", lunch: "12:00-13:00" },
    tuesday:   { open: true,  start: "09:00", end: "18:00", lunch: "12:00-13:00" },
    wednesday: { open: true,  start: "09:00", end: "18:00", lunch: "12:00-13:00" },
    thursday:  { open: true,  start: "09:00", end: "18:00", lunch: "12:00-13:00" },
    friday:    { open: true,  start: "09:00", end: "18:00", lunch: "12:00-13:00" },
    saturday:  { open: false, start: null,    end: null,    lunch: null },
    sunday:    { open: false, start: null,    end: null,    lunch: null }
  },

  // App settings
  settings: {
    language: "FR",                   // Default UI language
    theme: "dark",                    // dark/light
    appointmentDuration: 30,          // minutes
    reminderDays: 2,                  // Send reminder X days before
    autoBackup: true,
    lastBackup: "2026-04-02T08:00:00Z"
  }
}
```

---

## 4. BELGIAN COMPLIANCE REQUIREMENTS

### 4.1 Legal Framework

| Requirement | Status | Implementation |
|------------|--------|----------------|
| **GDPR/RGPD** | ✅ Must-have | Client-side encryption (Web Crypto API), data minimization, consent management |
| **INAMI Nomenclature** | ✅ Must-have | Article 5 codes (2025 tariffs), up-to-date database |
| **MyCareNet CIN** | 🔶 Phase 2 | eAttest V3, eFact, ConsultRN stubs (MVP), real integration (Phase 2) |
| **eHealth Platform** | 🔶 Phase 2 | Recip-e, eHealthBox stubs (MVP) |
| **NISS Validation** | ✅ Must-have | Luhn algorithm + format validation (XX.XX.XX-XXX.XX) |
| **Medical Secret** | ✅ Must-have | No cloud storage (MVP), encrypted at rest, HTTPS only |
| **Data Retention** | ✅ Must-have | 30 years for dental records (configurable) |

### 4.2 INAMI Article 5 — Mandatory Acts (2025 Tariffs)

```javascript
const INAMI_CODES_MVP = {
  // Consultations
  "101035": { desc: "Consultation dentiste généraliste ≥19 ans",
              conv: 26.86, patient: 8.06, mutuelle: 18.80 },

  // Préventif
  "301010": { desc: "Examen buccal annuel complet",
              conv: 26.86, patient: 8.06, mutuelle: 18.80 },
  "303013": { desc: "Détartrage supra-gingival (quadrant)",
              conv: 28.47, patient: 8.54, mutuelle: 19.93 },
  "371615": { desc: "Scellement fissures <19 ans (par dent)",
              conv: 17.29, patient: 5.19, mutuelle: 12.10 },

  // Soins conservateurs
  "311011": { desc: "Obturation 1 surface (amalgame/composite)",
              conv: 28.47, patient: 8.54, mutuelle: 19.93 },
  "311033": { desc: "Obturation 2 surfaces",
              conv: 45.96, patient: 13.79, mutuelle: 32.17 },
  "311055": { desc: "Obturation 3 surfaces ou plus",
              conv: 62.60, patient: 18.78, mutuelle: 43.82 },

  // Extractions
  "330031": { desc: "Extraction dent permanente (simple)",
              conv: 26.86, patient: 8.06, mutuelle: 18.80 },
  "330053": { desc: "Extraction dent permanente (compliquée)",
              conv: 52.89, patient: 15.87, mutuelle: 37.02 },

  // Endodontie
  "314012": { desc: "Pulpotomie/pulpectomie (soin urgence)",
              conv: 26.86, patient: 8.06, mutuelle: 18.80 },
  "314034": { desc: "Traitement canalaire monoradiculaire",
              conv: 95.66, patient: 28.70, mutuelle: 66.96 },

  // Urgences
  "373015": { desc: "Consultation urgence (hors heures)",
              conv: 52.89, patient: 15.87, mutuelle: 37.02 }
};
```

### 4.3 NISS Validation (Belgian National ID)

```javascript
/**
 * Validates Belgian NISS (Numéro d'Identification de la Sécurité Sociale)
 * Format: YY.MM.DD-XXX.CC
 * Example: 85.01.15-123.45
 *
 * Rules:
 * - YY: Birth year (00-99)
 * - MM: Birth month (01-12)
 * - DD: Birth day (01-31)
 * - XXX: Counter (001-997 for men born odd days, 002-998 for women born even days)
 * - CC: Check digits (97 - (YYMMDDXXX mod 97))
 *
 * Special case: Born >= 2000, add 2 to first digit of check calculation
 */
function validateNISS(niss) {
  // Remove formatting (dots and dash)
  const cleaned = niss.replace(/[.\-]/g, '');

  if (cleaned.length !== 11) return false;
  if (!/^\d{11}$/.test(cleaned)) return false;

  // Extract parts
  const birthDate = cleaned.substring(0, 6); // YYMMDD
  const counter = cleaned.substring(6, 9);   // XXX
  const checkDigits = parseInt(cleaned.substring(9, 11)); // CC

  // Validate date components
  const yy = parseInt(birthDate.substring(0, 2));
  const mm = parseInt(birthDate.substring(2, 4));
  const dd = parseInt(birthDate.substring(4, 6));

  if (mm < 1 || mm > 12) return false;
  if (dd < 1 || dd > 31) return false;

  // Calculate check digits
  let baseNumber = parseInt(birthDate + counter);

  // For people born >= 2000, add 2000000000
  const currentYear = new Date().getFullYear();
  const fullYear = yy + (yy > currentYear % 100 ? 1900 : 2000);
  if (fullYear >= 2000) {
    baseNumber += 2000000000;
  }

  const calculatedCheck = 97 - (baseNumber % 97);

  return calculatedCheck === checkDigits;
}

// Usage
validateNISS("85.01.15-123.45"); // true/false
```

### 4.4 Mutuelle Codes (Belgian Health Insurance)

```javascript
const MUTUELLES_BELGIQUE = [
  { code: "100", name: "UNMS (Union Nationale des Mutualités Socialistes)",
    regions: ["BRU", "WAL", "VLA"] },
  { code: "200", name: "Solidaris (ex-Mutualités Socialistes Solidaris)",
    regions: ["WAL"] },
  { code: "300", name: "CM/MC (Mutualité Chrétienne / Christelijke Mutualiteit)",
    regions: ["BRU", "WAL", "VLA"] },
  { code: "400", name: "Partenamut (ex-Mutualités Libres)",
    regions: ["BRU", "WAL", "VLA"] },
  { code: "500", name: "Mutlib (Liberale Mutualiteit / Mutualité Libérale Vlaams)",
    regions: ["VLA"] },
  { code: "600", name: "CAAMI (Caisse Auxiliaire d'Assurance Maladie-Invalidité)",
    regions: ["BRU", "WAL", "VLA"] },
  { code: "900", name: "HR Rail (Société Nationale des Chemins de fer Belges)",
    regions: ["BRU", "WAL", "VLA"] }
];
```

---

## 5. MODULE SPECIFICATIONS

### 5.1 Patients Module (`patients.html`)

**Features:**
- ✅ Patient list with search/filter (by name, NISS, mutuelle)
- ✅ Add new patient with Belgian compliance (NISS validation)
- ✅ Edit patient details
- ✅ View patient dossier (history, acts, certificates)
- ✅ Delete patient (with confirmation)
- ✅ Export patient list (CSV)
- ✅ Import patients (CSV)

**Form Fields:**
```
Personal Info:
├── First Name * (required)
├── Last Name *
├── NISS * (Belgian format, validated)
├── Date of Birth * (age auto-calculated)
├── Gender * (M/F/X)
└── Language (FR/NL/DE/EN)

Contact:
├── Phone
├── Mobile
├── Email
└── Address (street, number, box, postal code, city)

Insurance:
├── Mutuelle * (dropdown: CM, Solidaris, etc.)
├── Member Number
├── BIM Status (checkbox)
└── DMG (checkbox + doctor name)

Medical:
├── Allergies (tags)
└── Medical Notes (textarea)
```

**UI/UX:**
- Table view with pagination (25/50/100 per page)
- Quick actions: View | Edit | Delete
- Search bar (real-time filter)
- Color coding: BIM patients (green badge), DMG (blue badge)
- Responsive: Mobile-friendly cards on small screens

### 5.2 Agenda Module (`agenda.html`)

**Features:**
- ✅ Week/Day calendar view
- ✅ Add appointment (patient selector, type, duration)
- ✅ Edit/Cancel appointment
- ✅ Drag-and-drop rescheduling
- ✅ Color-coded by appointment type
- ✅ Status tracking (Confirmé → Présent → Terminé)
- ✅ Print day schedule

**Appointment Types:**
```javascript
const APPOINTMENT_TYPES = {
  CONTROLE:          { duration: 30,  color: '#3B82F6' }, // Blue
  SOIN_CONSERVATEUR: { duration: 45,  color: '#10B981' }, // Green
  EXTRACTION:        { duration: 30,  color: '#EF4444' }, // Red
  DETARTRAGE:        { duration: 45,  color: '#F59E0B' }, // Amber
  URGENCE:           { duration: 20,  color: '#DC2626' }, // Dark Red
  IMPLANT:           { duration: 90,  color: '#8B5CF6' }, // Purple
  ESTHETIQUE:        { duration: 60,  color: '#EC4899' }, // Pink
  PARODONTOLOGIE:    { duration: 60,  color: '#06B6D4' }  // Cyan
};
```

**Calendar View:**
- Time slots: 9:00 → 18:00 (configurable)
- 15-minute grid
- Lunch break highlight (12:00-13:00)
- Weekend days grayed out
- Today highlighted
- Double-click empty slot → New appointment

### 5.3 INAMI Module (`inami.html`)

**Features:**
- ✅ Act selector (searchable INAMI codes)
- ✅ Add act to patient dossier
- ✅ Automatic tariff calculation (conventionné/non-conventionné)
- ✅ Tooth selector (FDI notation: 11-48)
- ✅ eAttest V3 stub (console.log with realistic XML)
- ✅ eFact stub (tiers payant simulation)
- ✅ Daily acts list
- ✅ Export to PDF (justificatif)

**Tariff Calculation:**
```javascript
function calculateTariff(inamiCode, isConventionne, hasBIM) {
  const act = INAMI_CODES[inamiCode];

  if (isConventionne) {
    const baseAmount = act.conv;
    const patientShare = hasBIM ? 0 : act.patient; // BIM = 100% coverage
    const mutuelleShare = baseAmount - patientShare;

    return { baseAmount, patientShare, mutuelleShare, supplement: 0 };
  } else {
    const baseAmount = act.conv * 1.5; // Example: +50% for non-conventionné
    const patientShare = baseAmount;   // Patient pays all
    const mutuelleShare = 0;
    const supplement = baseAmount - act.conv;

    return { baseAmount, patientShare, mutuelleShare, supplement };
  }
}
```

**eAttest V3 Stub (MVP):**
```javascript
function sendEAttest(patientNISS, inamiCode, date) {
  const xml = `
    <?xml version="1.0" encoding="UTF-8"?>
    <eAttest version="3.0">
      <header>
        <sender>${PRACTICE_INAMI}</sender>
        <recipient>MyCareNet</recipient>
        <timestamp>${new Date().toISOString()}</timestamp>
      </header>
      <body>
        <patient>
          <niss>${patientNISS}</niss>
        </patient>
        <act>
          <code>${inamiCode}</code>
          <date>${date}</date>
          <provider>${PRACTICE_INAMI}</provider>
        </act>
      </body>
    </eAttest>
  `;

  console.log('[MVP STUB] eAttest V3 would be sent:', xml);
  return { success: true, attestId: 'MVP-' + Date.now() };
}
```

### 5.4 Mutuelles Module (`mutuelles.html`)

**Features:**
- ✅ Patient selector
- ✅ Assurabilité check stub (MyCareNet ConsultRN)
- ✅ Display mutuelle info, BIM status, coverage rights
- ✅ DMG verification
- ✅ Manual mutuelle entry (if API unavailable)

**ConsultRN Stub (MVP):**
```javascript
function checkAssurabilite(patientNISS, date) {
  console.log(`[MVP STUB] ConsultRN for NISS ${patientNISS} on ${date}`);

  // Simulated response
  return {
    success: true,
    data: {
      niss: patientNISS,
      mutuelle: { code: "300", name: "CM/MC" },
      bim: false,
      coverageActive: true,
      dmg: { active: true, doctor: "Dr. Dubois", inami: "1-12345-67-890" },
      rights: ["AMBULATORY", "DENTAL"],
      validUntil: "2026-12-31"
    }
  };
}
```

### 5.5 Certificates Module (`certificates.html`)

**Features:**
- ✅ Certificate templates (Incapacité de travail, Soins donnés, Mutuelle)
- ✅ Patient auto-fill
- ✅ Date range picker
- ✅ Reason field
- ✅ PDF generation (jsPDF + html2canvas)
- ✅ Print preview
- ✅ Save to patient dossier

**Certificate Template (Incapacité de travail):**
```
┌────────────────────────────────────────────────────────┐
│  CERTIFICAT MÉDICAL D'INCAPACITÉ DE TRAVAIL            │
│                                                        │
│  Dentiste: Dr. Ekaterina SIALYEN                      │
│  INAMI: 3-02462-81-001                                 │
│  Adresse: [Cabinet Address]                            │
│  Téléphone: [Phone]                                    │
│                                                        │
│  Je soussigné(e), certifie avoir examiné ce jour:     │
│                                                        │
│  Nom: [Patient Last Name]                              │
│  Prénom: [Patient First Name]                          │
│  NISS: [Patient NISS]                                  │
│  Né(e) le: [Date of Birth]                             │
│                                                        │
│  et constate que son état de santé nécessite un repos │
│  de [X] jours, du [Start Date] au [End Date] inclus.  │
│                                                        │
│  Motif: [Reason]                                       │
│                                                        │
│  Fait à Zaventem, le [Issue Date]                     │
│                                                        │
│  Signature: ________________                           │
│             Dr. E. SIALYEN                             │
│             INAMI: 3-02462-81-001                      │
└────────────────────────────────────────────────────────┘
```

### 5.6 Billing Module (`billing.html`)

**Features:**
- ✅ Daily revenue summary
- ✅ Monthly revenue chart
- ✅ Payment status tracking (Payé / En attente)
- ✅ Filter by date range, patient, mutuelle
- ✅ Export to CSV (for accounting)
- ✅ Statistics: Average per visit, most frequent acts

**Revenue Calculation:**
```javascript
function calculateDailyRevenue(date) {
  const acts = getActsByDate(date);

  const summary = {
    totalActs: acts.length,
    totalRevenue: 0,
    paidAmount: 0,
    pendingAmount: 0,
    mutuelleAmount: 0,
    byType: {}
  };

  acts.forEach(act => {
    summary.totalRevenue += act.totalAmount;
    summary.mutuelleAmount += act.insuranceShare;

    if (act.paymentStatus === 'PAYE') {
      summary.paidAmount += act.paidAmount;
    } else {
      summary.pendingAmount += act.patientShare;
    }

    if (!summary.byType[act.code]) {
      summary.byType[act.code] = { count: 0, revenue: 0 };
    }
    summary.byType[act.code].count++;
    summary.byType[act.code].revenue += act.totalAmount;
  });

  return summary;
}
```

### 5.7 Dashboard (`dashboard.html`)

**Features:**
- ✅ Today's agenda (upcoming appointments)
- ✅ Quick stats (patients, appointments, revenue)
- ✅ Recent acts
- ✅ Pending tasks (unpaid invoices, certificates to send)
- ✅ Quick actions (New patient, New appointment, New act)

**Widgets:**
```
┌─────────────────────────────────────────────────────────┐
│  TODAY — [Date]                          Dr. E. SIALYEN │
├─────────────────────────────────────────────────────────┤
│  📅 Next Appointment: 14:30 — Marie Dupont (Détartrage) │
│  📊 Today: 8 RDV | 6 Done | 2 Pending | €450 revenue    │
└─────────────────────────────────────────────────────────┘

┌──────────────┬──────────────┬──────────────┬────────────┐
│  📊 PATIENTS │  📅 RDV      │  💰 REVENUE  │  📄 ACTS   │
│     247      │  This week   │  This month  │  Today     │
│              │     42       │    €12,450   │     18     │
└──────────────┴──────────────┴──────────────┴────────────┘

┌─────────────────────────────────────────────────────────┐
│  RECENT ACTS (Last 5)                                   │
├─────────────────────────────────────────────────────────┤
│  • 14:30 — M. Dupont — Détartrage (303013) — €28.47    │
│  • 11:00 — J. Martin — Obturation (311011) — €28.47    │
│  • 10:30 — S. Bernard — Consultation (101035) — €26.86 │
│  ...                                                    │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  PENDING TASKS                                          │
├─────────────────────────────────────────────────────────┤
│  ⚠️  3 unpaid invoices (€85.41 total)                   │
│  📧  2 certificates to email                            │
│  📞  5 appointment reminders to send (tomorrow)         │
└─────────────────────────────────────────────────────────┘
```

---

## 6. EXPANSION STRATEGY (Multi-Specialty)

### 6.1 Specialty Modules Architecture

The app is designed to be **specialty-agnostic** at the core, with specialty-specific modules plugged in:

```
CORE (Shared by all specialties)
├── Patient Management
├── Agenda
├── Billing
├── Certificates
├── Settings
└── Dashboard

SPECIALTY MODULES (Pluggable)
├── DENTAL (Current MVP)
│   ├── INAMI Codes (Article 5)
│   ├── Tooth selector (FDI)
│   ├── Dental chart
│   └── Recip-e (prescriptions)
│
├── PHYSIOTHERAPY (Phase 3)
│   ├── INAMI Codes (Article 7)
│   ├── Treatment zones selector
│   ├── Treatment plans (60 sessions)
│   └── Prescription validator (médecin prescripteur)
│
└── GENERAL MEDICINE (Phase 4)
    ├── INAMI Codes (Article 1-3)
    ├── DMG management
    ├── Pathology codes (ICD-10)
    └── Lab prescriptions
```

### 6.2 Data Model Extensions

**Patient Entity Extensions:**
```javascript
{
  // Core (all specialties)
  id, niss, firstName, lastName, dateOfBirth, ...

  // Specialty-specific (stored in flexible "specialty" object)
  specialty: {
    dental: {
      lastDentalExam: "2026-03-15",
      dentalChart: { /* FDI tooth states */ },
      perioChart: { /* probing depths */ }
    },
    physio: {
      referringDoctor: { name: "Dr. X", inami: "..." },
      prescriptionDate: "2026-01-10",
      pathology: "Lombalgie chronique",
      sessionsAuthorized: 60,
      sessionsUsed: 12
    },
    generalMedicine: {
      dmg: { enrolled: true, date: "2020-05-10" },
      chronicConditions: ["Diabète T2", "HTA"],
      vaccinations: [/* vaccine records */]
    }
  }
}
```

### 6.3 INAMI Code System (Multi-Specialty)

```javascript
const INAMI_BY_SPECIALTY = {
  DENTAL: {
    article: 5,
    prefix: "3",  // All dental codes start with 3
    codes: { /* Article 5 codes */ }
  },

  PHYSIO: {
    article: 7,
    prefix: "5",  // All physio codes start with 5
    codes: {
      "560670": { desc: "Séance individuelle ≤30min (Fb/Fb)",
                  conv: 21.31, patient: 6.39 },
      "560692": { desc: "Séance individuelle >30min (Fb/Fb)",
                  conv: 32.48, patient: 9.74 },
      // ... Article 7 codes
    }
  },

  GENERAL_MEDICINE: {
    article: [1, 2, 3],
    prefix: "1",
    codes: {
      "101032": { desc: "Consultation médecin généraliste",
                  conv: 26.86, patient: 8.06 },
      "101054": { desc: "Visite au domicile",
                  conv: 37.69, patient: 11.31 },
      // ... Articles 1-3 codes
    }
  }
};
```

### 6.4 UI Adaptation Strategy

**Specialty Selector (Multi-Practice Support):**
```html
<!-- Dashboard top bar -->
<select id="specialtySwitch">
  <option value="dental">🦷 Dentaire</option>
  <option value="physio" disabled>🏃 Kinésithérapie (Bientôt)</option>
  <option value="generalMed" disabled>🩺 Médecine Générale (Bientôt)</option>
</select>
```

**Module Visibility:**
```javascript
const MODULE_VISIBILITY = {
  dental: {
    visible: ['patients', 'agenda', 'inami', 'mutuelles', 'certificates',
              'billing', 'dental-chart'],
    hidden: ['physio-zones', 'prescription-validator']
  },
  physio: {
    visible: ['patients', 'agenda', 'inami', 'mutuelles', 'certificates',
              'billing', 'physio-zones', 'prescription-validator'],
    hidden: ['dental-chart']
  }
};
```

---

## 7. DEVELOPMENT PHASES

### Phase 1: MVP — Working Dental Practice (2 weeks)

**Sprint 1 (Week 1):**
- ✅ Day 1-2: Architecture setup, data model, LocalStorage service
- ✅ Day 3-4: Patients module (NISS validation, CRUD)
- ✅ Day 5-7: Agenda module (calendar, appointments)

**Sprint 2 (Week 2):**
- ✅ Day 8-9: INAMI module (codes, tariffs, stubs)
- ✅ Day 10-11: Certificates module (templates, PDF)
- ✅ Day 12-13: Billing module (revenue tracking)
- ✅ Day 14: Dashboard, testing, bug fixes

**Deliverables:**
- ✅ Fully functional offline PWA
- ✅ Belgian-compliant (NISS, INAMI, Mutuelles)
- ✅ Deployed to GitHub Pages (k2dent.be)
- ✅ User manual (FR/NL)

### Phase 2: Backend + Real Integrations (1-2 months)

**Sprint 3-4:**
- Backend API (Fastify + PostgreSQL)
- Authentication (JWT, user management)
- Data migration (LocalStorage → PostgreSQL)
- MyCareNet CIN sandbox integration
- eAttest V3 real implementation
- eFact real implementation
- ConsultRN (assurabilité check)

**Sprint 5:**
- eHealth Platform sandbox
- Recip-e Hub integration
- eHealthBox (secure messaging)
- Document storage (MinIO/S3)
- Backup & restore

**Deliverables:**
- ✅ Backend API deployed (AWS/Azure Belgium)
- ✅ Real MyCareNet/eHealth integrations
- ✅ Multi-user support
- ✅ Audit logs & compliance reporting

### Phase 3: Physiotherapy Module (1 month)

**Sprint 6:**
- INAMI Article 7 codes
- Treatment zones selector
- Prescription validator
- Session tracking (60-session plans)
- Referring doctor management

**Deliverables:**
- ✅ K2 Physio module
- ✅ Multi-specialty support
- ✅ Shared patient base

### Phase 4: General Medicine Module (1 month)

**Sprint 7:**
- INAMI Articles 1-3 codes
- DMG management
- ICD-10 pathology codes
- Lab prescriptions
- Vaccination tracking

**Deliverables:**
- ✅ K2 Med module
- ✅ Full multi-specialty platform
- ✅ Belgian healthcare ecosystem coverage

---

## 8. DEPLOYMENT PLAN

### 8.1 MVP Deployment (GitHub Pages)

**Domain Setup:**
```bash
# 1. Register domain
Domain: k2dent.be (recommended)
Registrar: Combell, OVH, or Gandi

# 2. GitHub Pages setup
Repository: https://github.com/IsmaIkami/K2-Dent
Branch: main
Custom domain: k2dent.be
HTTPS: Enabled (Let's Encrypt)

# 3. DNS Configuration (CNAME)
k2dent.be → ismaikami.github.io
www.k2dent.be → ismaikami.github.io
```

**PWA Manifest (`manifest.json`):**
```json
{
  "name": "K2 Dent — Cabinet Dentaire Pro",
  "short_name": "K2 Dent",
  "description": "Gestion de cabinet dentaire conforme INAMI",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#1A1D29",
  "theme_color": "#0066FF",
  "icons": [
    {
      "src": "/assets/icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/assets/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ],
  "orientation": "portrait-primary",
  "lang": "fr-BE",
  "dir": "ltr"
}
```

**Service Worker (`sw.js` — Offline Support):**
```javascript
const CACHE_NAME = 'k2dent-v1.0';
const ASSETS = [
  '/',
  '/index.html',
  '/dashboard.html',
  '/patients.html',
  '/agenda.html',
  '/inami.html',
  '/mutuelles.html',
  '/certificates.html',
  '/billing.html',
  '/assets/app.css',
  '/assets/app.js',
  '/assets/patient.service.js',
  // ... all critical assets
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

### 8.2 Production Deployment (Phase 2)

**Infrastructure:**
```
AWS Belgium (eu-central-1 — Frankfurt, closest to Belgium)

Compute:
├── ECS Fargate (API containers)
├── Application Load Balancer (HTTPS, WAF)
└── Auto-scaling (2-10 instances)

Database:
├── RDS PostgreSQL 16 (Multi-AZ)
├── ElastiCache Redis (Cluster mode)
└── S3 (Document storage, versioned)

Networking:
├── VPC (isolated network)
├── CloudFront (CDN, Belgium edge location)
└── Route 53 (DNS)

Security:
├── ACM (SSL certificates)
├── WAF (DDoS protection, rate limiting)
├── Secrets Manager (API keys, DB credentials)
└── CloudTrail (audit logs)

Monitoring:
├── CloudWatch (metrics, logs)
├── X-Ray (tracing)
└── SNS (alerts)

Estimated costs: €200-400/month (low traffic)
```

**CI/CD Pipeline:**
```yaml
# .github/workflows/deploy.yml
name: Deploy K2 Dent

on:
  push:
    branches: [main, staging]

jobs:
  deploy-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./
          cname: k2dent.be

  deploy-backend:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-central-1
      - name: Deploy to ECS
        run: |
          aws ecs update-service \
            --cluster k2dent-cluster \
            --service k2dent-api \
            --force-new-deployment
```

---

## 9. SECURITY & COMPLIANCE

### 9.1 Data Encryption

**Client-Side (MVP):**
```javascript
// Web Crypto API for sensitive data
async function encryptData(data, password) {
  const enc = new TextEncoder();
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
      salt: enc.encode("k2dent-salt-v1"), // In production: random salt per user
      iterations: 100000,
      hash: "SHA-256"
    },
    keyMaterial,
    { name: "AES-GCM", length: 256 },
    false,
    ["encrypt", "decrypt"]
  );

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

// Usage: Encrypt NISS before storing in LocalStorage
const patient = { niss: "85.01.15-123.45", ... };
const encrypted = await encryptData(patient.niss, userPassword);
localStorage.setItem('k2dent_patient_123', JSON.stringify({
  ...patient,
  niss: encrypted
}));
```

### 9.2 GDPR/RGPD Compliance

**Data Protection:**
- ✅ Data minimization (only collect necessary fields)
- ✅ Encryption at rest (LocalStorage encrypted)
- ✅ No third-party analytics (MVP)
- ✅ Right to erasure (delete patient feature)
- ✅ Data export (CSV export)
- ✅ Consent management (terms acceptance on first use)
- ✅ Audit logs (Phase 2: all actions logged)

**Privacy Policy (Required):**
- Location: `/privacy.html`
- Languages: FR, NL, DE
- Content: Data collected, purpose, retention, user rights

### 9.3 Backup Strategy

**MVP (LocalStorage):**
```javascript
// Auto-backup every 24h
function autoBackup() {
  const data = {
    patients: JSON.parse(localStorage.getItem('k2dent_patients') || '[]'),
    appointments: JSON.parse(localStorage.getItem('k2dent_appointments') || '[]'),
    acts: JSON.parse(localStorage.getItem('k2dent_acts') || '[]'),
    certificates: JSON.parse(localStorage.getItem('k2dent_certificates') || '[]'),
    config: JSON.parse(localStorage.getItem('k2dent_config') || '{}'),
    timestamp: new Date().toISOString()
  };

  // Download as JSON file
  const blob = new Blob([JSON.stringify(data, null, 2)],
                        { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `k2dent-backup-${data.timestamp}.json`;
  a.click();

  console.log('[BACKUP] Created:', a.download);
}

// Run every 24h
setInterval(autoBackup, 24 * 60 * 60 * 1000);
```

**Production (Phase 2):**
- PostgreSQL automated backups (AWS RDS: daily snapshots, 30-day retention)
- S3 versioning (document history)
- Point-in-time recovery (5-minute RPO)
- Cross-region replication (disaster recovery)

---

## 10. SUCCESS METRICS

### 10.1 MVP Success Criteria

**Technical:**
- ✅ 100% offline functionality
- ✅ < 2s page load time
- ✅ Mobile responsive (tested on iOS/Android)
- ✅ Zero console errors
- ✅ NISS validation accuracy: 100%
- ✅ PWA installable (Add to Home Screen works)

**Functional:**
- ✅ Add 10 test patients (NISS validated)
- ✅ Create 20 test appointments
- ✅ Log 15 INAMI acts (various codes)
- ✅ Generate 5 certificates (PDF export)
- ✅ Calculate revenue for 1 week

**User Acceptance (Dr. Sialyen):**
- ✅ Can manage full day without paper
- ✅ Certificate generation < 2 minutes
- ✅ Patient lookup < 5 seconds
- ✅ Appointment scheduling intuitive
- ✅ INAMI act logging faster than manual

### 10.2 Phase 2 Success Criteria

**Integration:**
- ✅ eAttest V3: 95% acceptance rate
- ✅ ConsultRN: < 3s response time
- ✅ Recip-e: QR code validated by pharmacy

**Performance:**
- ✅ API response time: < 200ms (p95)
- ✅ Database queries: < 50ms
- ✅ Concurrent users: 10+ (multi-dentist practice)
- ✅ Uptime: 99.5%

---

## 11. RISKS & MITIGATION

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| **MyCareNet API changes** | Medium | High | Abstract integration layer, version handling |
| **INAMI tariff updates** | High | Medium | Config-driven tariffs, easy updates |
| **LocalStorage data loss** | Low | High | Auto-backup, export feature, user education |
| **NISS format changes** | Low | Medium | Regex-based validation, easy to update |
| **GDPR non-compliance** | Low | Critical | Legal review, privacy by design |
| **Browser compatibility** | Low | Medium | Polyfills, progressive enhancement, testing |

---

## 12. NEXT STEPS (After Approval)

1. **Review & Approve Architecture** ✋ (You are here)
2. Clone K2-Dent repository
3. Create feature branch: `feature/mvp-refactor`
4. Implement Phase 1 (2 weeks)
5. User acceptance testing (Dr. Sialyen)
6. Deploy to production (k2dent.be)
7. Plan Phase 2 kickoff

---

## APPENDICES

### A. File Structure (MVP)

```
K2-Dent/
├── index.html                  # Landing page
├── dashboard.html              # Main cockpit
├── patients.html               # Patient management
├── agenda.html                 # Appointments
├── inami.html                  # INAMI acts
├── mutuelles.html              # Insurance
├── certificates.html           # Medical certificates
├── billing.html                # Revenue tracking
├── manifest.json               # PWA manifest
├── sw.js                       # Service worker
├── privacy.html                # Privacy policy
│
├── assets/
│   ├── css/
│   │   ├── app.css            # Main styles
│   │   ├── variables.css      # CSS variables (theme)
│   │   └── print.css          # Print styles
│   │
│   ├── js/
│   │   ├── app.js             # Main app logic
│   │   ├── patient.service.js # Patient CRUD
│   │   ├── agenda.service.js  # Appointments
│   │   ├── inami.service.js   # INAMI logic
│   │   ├── mutuelle.service.js# Insurance
│   │   ├── certificate.service.js # Certificates
│   │   ├── billing.service.js # Revenue
│   │   ├── storage.service.js # LocalStorage wrapper
│   │   ├── auth.service.js    # Login/session
│   │   ├── utils.js           # NISS validation, formatters
│   │   └── config.js          # INAMI codes, mutuelles
│   │
│   ├── icons/
│   │   ├── icon-192.png
│   │   └── icon-512.png
│   │
│   └── vendor/                # CDN fallbacks
│       ├── dayjs.min.js
│       ├── jspdf.min.js
│       ├── html2canvas.min.js
│       ├── qrcode.min.js
│       └── chart.min.js
│
├── backups/                   # Auto-generated backups
│   └── backup-YYYYMMDD-HHMMSS/
│
├── docs/
│   ├── ARCHITECTURE-MVP.md    # This document
│   ├── USER-MANUAL-FR.md      # User guide (French)
│   ├── USER-MANUAL-NL.md      # User guide (Dutch)
│   └── API-DOCS.md            # API docs (Phase 2)
│
├── .github/
│   └── workflows/
│       └── deploy.yml         # CI/CD pipeline
│
├── README.md
├── LICENSE
└── .gitignore
```

### B. Browser Compatibility

| Browser | Version | Status |
|---------|---------|--------|
| **Chrome** | 90+ | ✅ Fully supported |
| **Edge** | 90+ | ✅ Fully supported |
| **Firefox** | 88+ | ✅ Fully supported |
| **Safari** | 14+ | ✅ Supported (with polyfills) |
| **iOS Safari** | 14+ | ✅ Supported |
| **Android Chrome** | 90+ | ✅ Fully supported |

**Required APIs:**
- LocalStorage ✅ (all browsers)
- Web Crypto API ✅ (all browsers)
- Service Workers ✅ (all browsers)
- IndexedDB ✅ (Phase 2)

### C. Belgian Healthcare Resources

**Official Documentation:**
- INAMI: https://www.inami.fgov.be/
- MyCareNet: https://www.mycarenet.be/
- eHealth Platform: https://www.ehealth.fgov.be/
- GDPR Belgium: https://www.autoriteprotectiondonnees.be/

**INAMI Nomenclature:**
- Article 5 (Dental): https://www.inami.fgov.be/fr/professionnels/sante/dentistes
- 2025-2026 Tariffs: https://www.inami.fgov.be/fr/professionnels/sante/dentistes/tarifs

**MyCareNet Technical Docs:**
- eAttest V3: https://www.mycarenet.be/eattest
- eFact: https://www.mycarenet.be/efact
- ConsultRN: https://www.mycarenet.be/consultrn

---

## DOCUMENT APPROVAL

**Author:** Ismail Sialyen
**Date:** April 2, 2026
**Version:** 1.0 MVP Architecture

**Approvals Required:**
- [ ] Dr. Ekaterina SIALYEN (End User) — Functional requirements
- [ ] Ismail SIALYEN (Developer) — Technical feasibility
- [ ] Legal/Compliance (if applicable) — GDPR/RGPD compliance

**Status:** ✋ **PENDING APPROVAL**

---

**Once approved, development begins immediately.**
**Estimated MVP delivery: April 16, 2026 (2 weeks from now)**

---

