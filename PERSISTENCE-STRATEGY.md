# K2 Dent - Stratégie de Persistence LocalStorage

## 🎯 Objectif
Rendre tous les modules opérationnels avec persistence des données sans toucher aux UI existantes.

## 📊 Structure LocalStorage

### 1. **Patients** (Déjà créé avec login.html)
```javascript
k2dent_patients = [
  {
    id: "patient-123",
    firstName: "Marie",
    lastName: "Dubois",
    niss: "85.07.30-123.45",
    dateOfBirth: "1985-07-30",
    gender: "F",
    phone: "+32 2 123 45 67",
    email: "marie@example.be",
    mutuelleCode: "300",
    bim: false,
    allergies: "Pénicilline",
    medicalNotes: "Diabète Type 2",
    createdAt: "2026-04-03T10:00:00Z",
    updatedAt: "2026-04-03T10:00:00Z"
  }
]
```

### 2. **Anamnèses** (Déjà dans ai-dental.js)
```javascript
k2dent_anamnesis_[NISS] = [
  {
    version: 1,
    content: "...",
    type: "AI", // ou "MODIFIED"
    createdAt: "2026-04-03T10:00:00Z",
    createdBy: "ekaterina"
  }
]
```

### 3. **Timeline / Événements** (À AJOUTER)
```javascript
k2dent_timeline_[NISS] = [
  {
    id: "event-123",
    type: "anamnesis", // anamnesis, prescription, xray, certificate, inami
    badge: "badge-ai",
    title: "Anamnèse IA générée",
    description: "...",
    date: "2026-04-03T10:00:00Z",
    data: {} // données spécifiques
  }
]
```

### 4. **Enregistrements Audio** (À AJOUTER - Metadata seulement)
```javascript
k2dent_recordings_[NISS] = [
  {
    id: "rec-123",
    duration: 180, // secondes
    transcription: "...",
    date: "2026-04-03T10:00:00Z",
    anamnesisGenerated: true
  }
]
```

### 5. **Schéma Dentaire / Traitements** (À AJOUTER)
```javascript
k2dent_dental_chart_[NISS] = {
  teeth: {
    "11": {
      status: "carie", // healthy, carie, missing, implant, couronne
      treatments: [
        {
          id: "tr-123",
          type: "obturation",
          date: "2026-04-03",
          notes: "Composite",
          surface: "DO"
        }
      ],
      notes: "..."
    },
    // ... pour chaque dent 11-48
  },
  lastUpdate: "2026-04-03T10:00:00Z"
}
```

### 6. **INAMI Acts** (Déjà créé avec inami.html opérationnel)
```javascript
k2dent_acts = [
  {
    id: "act-123",
    patientId: "patient-123",
    patientNISS: "85.07.30-123.45",
    actCode: "371114",
    tooth: "16",
    quantity: 1,
    date: "2026-04-03",
    honoraire: 25.50,
    partMutuelle: 20.40,
    ticketModerateur: 5.10,
    hasBIM: false,
    createdAt: "2026-04-03T10:00:00Z"
  }
]
```

### 7. **Prescriptions Recip-e** (Déjà créé)
```javascript
k2dent_prescriptions = [
  {
    id: "rx-123",
    recipeId: "BE-2026-1234-RXDE",
    patientId: "patient-123",
    medications: [...],
    date: "2026-04-03",
    createdBy: "ekaterina"
  }
]
```

### 8. **Certificats** (Déjà créé)
```javascript
k2dent_certificates = [...]
```

### 9. **Agenda / Rendez-vous** (À AJOUTER)
```javascript
k2dent_appointments = [
  {
    id: "apt-123",
    patientId: "patient-123",
    patientName: "Marie Dubois",
    date: "2026-04-10",
    time: "14:00",
    duration: 60, // minutes
    type: "consultation", // consultation, suivi, urgence
    status: "confirmed", // confirmed, cancelled, completed
    notes: "...",
    createdAt: "2026-04-03T10:00:00Z"
  }
]
```

### 10. **Auth Session** (Déjà créé)
```javascript
k2dent_session = {
  user: {...},
  loginTime: "...",
  expiresAt: "..."
}
```

## 🔧 Fichiers à Créer/Modifier

### ✅ Déjà Fait
- `js/auth-rbac.js` - Auth + permissions
- `js/ai-dental.js` - Anamnèse + prescriptions IA
- `js/belgium.js` - Belgian compliance
- `login.html` - Opérationnel

### 📝 À Faire (Sans Remplacer l'Existant)

#### 1. **Créer `js/storage-manager.js`**
Module central pour gérer toute la persistence :
```javascript
const StorageManager = {
  // Patients
  getPatient(id),
  getAllPatients(),
  savePatient(patient),
  deletePatient(id),

  // Timeline
  addTimelineEvent(patientNISS, event),
  getTimeline(patientNISS),

  // Recordings
  saveRecording(patientNISS, recording),
  getRecordings(patientNISS),

  // Dental Chart
  getDentalChart(patientNISS),
  saveDentalChart(patientNISS, chart),
  updateTooth(patientNISS, toothNumber, data),

  // Appointments
  saveAppointment(appointment),
  getAppointments(date),
  getPatientAppointments(patientId),

  // ... etc
}
```

#### 2. **Modifier `dashboard.html`**
Ajouter les appels à StorageManager :
- Ligne ~2008 `saveAnamnesis()` → Ajouter `StorageManager.addTimelineEvent()`
- Ligne ~1915 `stopRecording()` → Ajouter `StorageManager.saveRecording()`
- Charger la timeline au load de la page

#### 3. **Modifier `dental-chart.html`**
Ajouter persistence des traitements :
- Charger le schéma dentaire au load
- Sauvegarder chaque modification de dent
- Intégrer avec patients

#### 4. **Créer `agenda.html` opérationnel**
Nouvelle création avec persistence depuis le début

## 🚀 Plan d'Exécution (Étape par Étape)

### Phase 1 : Infrastructure (30 min)
1. Créer `js/storage-manager.js`
2. Tester la persistence basique

### Phase 2 : Dashboard (1h)
1. Intégrer StorageManager dans dashboard.html
2. Persister timeline
3. Persister metadata des enregistrements
4. Connecter avec patients

### Phase 3 : Dental Chart (1h)
1. Ajouter persistence dans dental-chart.html
2. Sauvegarder les traitements
3. Historique des modifications

### Phase 4 : Agenda (1h)
1. Rendre agenda.html opérationnel
2. Calendrier avec rendez-vous
3. Notifications

### Phase 5 : Intégration (30 min)
1. Tester tous les workflows
2. Vérifier les liens entre modules
3. Documentation

## 📊 Capacité LocalStorage

- Limite : ~5-10 MB par domaine
- Estimation :
  - 1000 patients : ~500 KB
  - 10,000 événements timeline : ~1 MB
  - 50 schémas dentaires : ~500 KB
  - **TOTAL : ~2-3 MB = OK pour MVP**

## 🔄 Migration Future

Pour passer à PostgreSQL plus tard :
1. Exporter toutes les données en JSON
2. Script de migration vers DB
3. API backend pour remplacer LocalStorage
4. Zero downtime grâce aux mêmes structures de données

## 🎯 Prochaine Étape

**Commencer par créer `js/storage-manager.js` ?**

Cela permettra d'avoir une base solide pour tous les modules.
