# 🚀 K2 Dent - Guide de Setup Supabase (5 Minutes)

## Étape 1 : Créer le Projet Supabase (2 min)

### 1.1 Créer un compte
1. Aller sur https://supabase.com
2. Cliquer sur **"Start your project"**
3. Se connecter avec GitHub (recommandé)

### 1.2 Créer le projet
1. Cliquer sur **"New Project"**
2. Remplir :
   - **Name** : `k2-dent-production`
   - **Database Password** : Générer un mot de passe fort (GARDER EN SÉCURITÉ !)
   - **Region** : **Europe West (Frankfurt)** ← IMPORTANT pour RGPD 🇪🇺
   - **Pricing Plan** : Free

3. Cliquer sur **"Create new project"**
4. Attendre 1-2 minutes (préparation de la base de données)

---

## Étape 2 : Exécuter le Schéma SQL (2 min)

### 2.1 Ouvrir l'éditeur SQL
1. Dans le menu gauche, cliquer sur **"SQL Editor"** (icône ⚡)
2. Cliquer sur **"New query"**

### 2.2 Copier-coller le schéma
1. Ouvrir le fichier `supabase/schema.sql` de ce projet
2. Copier TOUT le contenu
3. Coller dans l'éditeur SQL de Supabase
4. Cliquer sur **"Run"** (en bas à droite)

✅ Vous devriez voir : **"Success. No rows returned"**

### 2.3 Vérifier les tables
1. Dans le menu gauche, cliquer sur **"Table Editor"**
2. Vous devriez voir toutes les tables :
   - `patients`
   - `anamnesis`
   - `timeline_events`
   - `dental_charts`
   - `tooth_treatments`
   - `inami_acts`
   - `prescriptions`
   - `certificates`
   - `appointments`
   - `staff_profiles`
   - `xrays`

---

## Étape 3 : Obtenir les Clés API (1 min)

### 3.1 Copier les clés
1. Dans le menu gauche, cliquer sur **"Settings"** (icône ⚙️)
2. Cliquer sur **"API"**
3. Copier les valeurs suivantes :

```
Project URL: https://xxxxx.supabase.co
anon/public key: eyJhbGciOiJ...
```

### 3.2 Configurer le client JavaScript
1. Ouvrir le fichier `js/supabase-client.js`
2. Ligne 15, remplacer :

```javascript
const SUPABASE_CONFIG = {
  url: 'https://VOTRE-PROJET.supabase.co', // ← Coller votre Project URL
  anonKey: 'eyJhbGciOiJ...', // ← Coller votre anon key
  // ...
}
```

3. Sauvegarder le fichier

---

## Étape 4 : Ajouter Supabase dans les Pages HTML

### 4.1 Dans toutes les pages HTML, ajouter AVANT `</head>` :

```html
<!-- Supabase Client -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="js/supabase-client.js"></script>
```

### 4.2 Fichiers à modifier :
- ✅ `dashboard.html`
- ✅ `patients.html`
- ✅ `inami.html`
- ✅ `prescriptions.html`
- ✅ `certificates.html`
- ✅ `dental-chart.html`
- ✅ `agenda.html`

---

## Étape 5 : Tester la Connexion

### 5.1 Ouvrir la console du navigateur
1. Ouvrir `dashboard.html` dans le navigateur
2. Appuyer sur F12 (ouvrir les DevTools)
3. Aller dans l'onglet **Console**

### 5.2 Vérifier les messages
Vous devriez voir :
```
✅ Supabase initialized successfully
📦 K2 Dent - Supabase Client loaded
```

Si erreur, vérifier :
- URL et anon key sont bien renseignées dans `js/supabase-client.js`
- Pas d'erreur dans la console
- Internet fonctionne

---

## ✅ Setup Terminé !

Votre base de données cloud est maintenant prête. Toutes les données seront automatiquement sauvegardées dans Supabase.

---

## 🧪 Tester avec des Données

### Test 1 : Créer un patient
Dans la console du navigateur, exécuter :

```javascript
const patient = await DB.savePatient({
  first_name: 'Test',
  last_name: 'Patient',
  niss: '85.07.30-999.99',
  date_of_birth: '1985-07-30',
  gender: 'F',
  phone: '+32 2 123 45 67',
  email: 'test@example.be',
  mutuelle_code: '300',
  bim: false,
  allergies: 'Aucune'
});

console.log('Patient créé:', patient);
```

### Test 2 : Récupérer tous les patients
```javascript
const patients = await DB.getAllPatients();
console.log('Tous les patients:', patients);
```

### Test 3 : Ajouter un événement timeline
```javascript
await DB.addTimelineEvent(patient.id, {
  type: 'anamnesis',
  title: 'Test anamnèse',
  description: 'Première anamnèse de test',
  badge: 'badge-ai'
});

const timeline = await DB.getPatientTimeline(patient.id);
console.log('Timeline:', timeline);
```

✅ Si ces commandes fonctionnent, tout est OK !

---

## 🔧 Configuration Avancée (Optionnel)

### Ajouter votre profil utilisateur

1. Dans Supabase Dashboard, aller dans **Authentication** > **Users**
2. Cliquer sur **"Add user"** > **"Create new user"**
3. Remplir :
   - Email: `ekaterina@k2dent.be`
   - Password: (mot de passe fort)
   - Confirm: Oui

4. Copier l'**User ID** (format UUID)

5. Dans **SQL Editor**, exécuter :

```sql
INSERT INTO staff_profiles (id, role, first_name, last_name, inami_number, email, active)
VALUES
  ('COLLER-USER-ID-ICI', 'DENTIST', 'Ekaterina', 'SIALYEN', '3-02462-81-001', 'ekaterina@k2dent.be', true);
```

Répéter pour :
- Ismail (OWNER)
- Katja (OWNER)
- Marie (ASSISTANT)

---

## 📊 Monitoring & Backups

### Voir l'usage de la base de données
1. **Dashboard** > **Settings** > **Database**
2. Voir : Taille DB, nombre de connexions, etc.

### Backups automatiques
✅ Activés par défaut :
- **Daily backups** (7 jours de retention)
- **Point-in-Time Recovery** (PITR)

Pour restaurer un backup :
1. **Database** > **Backups**
2. Sélectionner une date
3. **Restore**

---

## 🔒 Sécurité

### Row Level Security (RLS)
✅ Déjà activé dans le schéma SQL

Les utilisateurs peuvent uniquement :
- Voir les données auxquelles ils ont accès
- Modifier uniquement leurs propres créations
- Les OWNERS ont accès complet

### HTTPS / Encryption
✅ Automatique :
- TLS 1.3 pour toutes les connexions
- AES-256 encryption at rest
- Toutes les données chiffrées

---

## 💰 Monitoring des Coûts

### Voir l'usage actuel
1. **Settings** > **Billing**
2. Voir : Database size, Bandwidth, Storage

### Alertes
Configurer des alertes si vous approchez des limites :
1. **Settings** > **Billing** > **Alerts**
2. Activer les notifications par email

**Limite Free Tier :**
- 500 MB Database ← Suffisant pour 1000 patients
- 1 GB File Storage ← Pour radios/images
- 2 GB Bandwidth/mois

---

## 🆘 Troubleshooting

### Erreur : "Failed to fetch"
→ Vérifier que l'URL et la clé API sont corrects dans `js/supabase-client.js`

### Erreur : "Row Level Security policy violation"
→ Vous devez être authentifié. Vérifier que l'utilisateur est connecté.

### Erreur : "relation does not exist"
→ Le schéma SQL n'a pas été exécuté. Retourner à l'Étape 2.

### Les données ne se sauvegardent pas
→ Ouvrir la console (F12) et vérifier les erreurs
→ Vérifier que Supabase est bien initialisé (`initSupabase()` appelé)

---

## 📞 Support

**Documentation Supabase :**
https://supabase.com/docs

**Community Discord :**
https://discord.supabase.com

**K2 Dent - Issues :**
Créer un issue sur GitHub si problème spécifique à K2 Dent

---

## 🎉 Prochaines Étapes

1. ✅ Intégrer Supabase dans `dashboard.html`
2. ✅ Migrer les autres modules
3. ✅ Tester avec de vraies données
4. ✅ Déployer en production

**Bon développement ! 🚀**
