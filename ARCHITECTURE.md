# DentalCockpit Pro - Architecture Technique Détaillée

**Version:** 2.0
**Date:** 12/11/2025
**Auteur:** Ismail Sialyen
**Powered by:** RCE (Relational Cognitive Engine)

---

## 📋 Table des Matières

1. [Vue d'Ensemble](#vue-densemble)
2. [Principes d'Architecture](#principes-darchitecture)
3. [Stack Technologique](#stack-technologique)
4. [Architecture Frontend](#architecture-frontend)
5. [Architecture Backend](#architecture-backend)
6. [Architecture RCE AI Engine](#architecture-rce-ai-engine)
7. [Architecture Base de Données](#architecture-base-de-données)
8. [Architecture Streaming & Temps Réel](#architecture-streaming--temps-réel)
9. [Architecture Scalabilité](#architecture-scalabilité)
10. [Sécurité & Conformité](#sécurité--conformité)
11. [Monitoring & Observabilité](#monitoring--observabilité)
12. [Déploiement & Infrastructure](#déploiement--infrastructure)
13. [Plan de Développement](#plan-de-développement)

---

## 🏗️ Vue d'Ensemble

### Vision Architecturale

DentalCockpit Pro est une plateforme SaaS de gestion de cabinet dentaire alimentée par l'IA, conçue pour :
- **Haute Performance** : Réactivité < 100ms, streaming temps réel
- **Scalabilité Massive** : 10K+ utilisateurs concurrent
- **Disponibilité** : 99.9% uptime (SLA)
- **Intelligence Artificielle** : RCE orchestrant GPT-4, Claude, Gemini
- **Multi-tenant** : Isolation complète par cabinet

### Métriques Cibles

```
Performance:
├─ API Response Time: < 100ms (p95)
├─ Streaming Latency: < 50ms
├─ Voice Transcription: < 2s (real-time)
├─ AI Analysis: < 3s
└─ Page Load: < 1.5s (FCP)

Scalabilité:
├─ Concurrent Users: 10,000+
├─ Requests/sec: 50,000+
├─ AI Requests/sec: 1,000+
├─ WebSocket Connections: 10,000+
└─ Storage: Unlimited (S3)

Disponibilité:
├─ Uptime: 99.9% (SLA)
├─ RTO (Recovery Time): < 1h
├─ RPO (Data Loss): < 5min
└─ Backup Frequency: Real-time
```

---

## 🎯 Principes d'Architecture

### 1. **Event-Driven Architecture (EDA)**
- Communication asynchrone via messages
- Découplage total des composants
- Scalabilité horizontale native

### 2. **Microservices Architecture**
- Services indépendants et déployables
- Responsabilité unique par service
- API Gateway centralisé

### 3. **CQRS (Command Query Responsibility Segregation)**
- Séparation lecture/écriture
- Optimisation requêtes complexes
- Event Sourcing pour audit trail

### 4. **Reactive Programming**
- Streams de données (RxJS)
- Backpressure handling
- Non-blocking I/O partout

### 5. **Zero-Trust Security**
- Authentification à chaque hop
- Encryption end-to-end
- Principe du moindre privilège

---

## 🛠️ Stack Technologique

### Frontend

```typescript
Framework Principal:
├─ Next.js 14+ (App Router, React Server Components)
├─ TypeScript 5+ (strict mode)
├─ React 18+ (Concurrent Features, Suspense)
└─ Turborepo (monorepo management)

State Management:
├─ Zustand (global state, lightweight)
├─ TanStack Query v5 (server state, caching)
├─ Jotai (atomic state)
└─ RxJS 7+ (reactive streams)

UI & Styling:
├─ Tailwind CSS 4+ (JIT, custom design system)
├─ Radix UI (accessible primitives)
├─ Framer Motion (animations)
├─ Shadcn/ui (component library)
└─ CSS Modules (scoped styles)

Real-time & Streaming:
├─ Socket.io Client (WebSocket)
├─ Server-Sent Events (SSE)
├─ WebRTC (peer-to-peer video)
└─ EventSource (streaming)

Data Visualization:
├─ D3.js (dental charts, graphs)
├─ Recharts (analytics dashboards)
├─ Three.js (3D dental models)
└─ Canvas API (drawing tools)

Voice & Media:
├─ Web Audio API (voice recording)
├─ MediaRecorder API (audio capture)
├─ WebRTC (real-time communication)
└─ Audio Worklet (processing)

Testing:
├─ Vitest (unit tests)
├─ Playwright (e2e tests)
├─ Testing Library (component tests)
└─ MSW (API mocking)
```

### Backend

```yaml
Runtime & Framework:
├─ Node.js 20+ LTS (V8 engine)
├─ Bun 1.0+ (performance critical services)
├─ Fastify (HTTP framework, 2x faster than Express)
├─ tRPC (type-safe API, end-to-end TypeScript)
└─ GraphQL (Apollo Server v4)

API Layer:
├─ REST API (Fastify + OpenAPI)
├─ GraphQL (Apollo Federation)
├─ gRPC (service-to-service)
├─ WebSocket (Socket.io)
└─ Server-Sent Events (streaming)

Message Queue & Streaming:
├─ Apache Kafka (event streaming, main bus)
├─ Redis Streams (real-time updates)
├─ BullMQ (job queue, Redis-based)
└─ RabbitMQ (task distribution, backup)

Background Jobs:
├─ BullMQ (scheduled tasks)
├─ Node-cron (periodic jobs)
├─ Temporal.io (workflow orchestration)
└─ Agenda (MongoDB-based jobs)

Validation & Security:
├─ Zod (schema validation)
├─ Helmet (security headers)
├─ Rate-limiter-flexible (rate limiting)
└─ bcrypt / Argon2 (password hashing)
```

### Databases

```yaml
Primary Database (NoSQL):
├─ MongoDB 7+ (main data store)
│   ├─ Sharding enabled (horizontal scaling)
│   ├─ Replica Set (3+ nodes, high availability)
│   ├─ Change Streams (real-time sync)
│   └─ Time Series Collections (metrics)

Vector Database:
├─ Pinecone / Weaviate / Qdrant
│   ├─ Embeddings storage (1536 dimensions)
│   ├─ Semantic search (similar cases)
│   ├─ RAG (Retrieval Augmented Generation)
│   └─ Medical knowledge base

Cache Layer:
├─ Redis 7+ (primary cache)
│   ├─ Redis Cluster (distributed cache)
│   ├─ Redis Streams (event streaming)
│   ├─ Pub/Sub (real-time messaging)
│   └─ RedisJSON (complex objects)
│
├─ KeyDB (Redis fork, multithreading)
└─ Memcached (simple key-value)

Search Engine:
├─ Elasticsearch 8+ / Meilisearch
│   ├─ Full-text search (patients, cases)
│   ├─ Aggregations (analytics)
│   ├─ Real-time indexing
│   └─ Typo-tolerance

Time Series:
├─ TimescaleDB (PostgreSQL extension)
│   ├─ Metrics storage
│   ├─ Patient vitals over time
│   ├─ System monitoring data
│   └─ Automatic aggregation

Relational (Backup/Compliance):
├─ PostgreSQL 16+ (audit logs, invoicing)
│   ├─ JSONB support
│   ├─ Row-level security
│   ├─ Logical replication
│   └─ Point-in-time recovery
```

### RCE AI Engine

```yaml
Orchestration Layer:
├─ Custom RCE Engine (Node.js/Python hybrid)
│   ├─ Model Router (intelligent selection)
│   ├─ Load Balancer (distributed requests)
│   ├─ Cache Layer (response caching)
│   ├─ Fallback Handler (failover logic)
│   └─ Cost Optimizer (cheapest model selection)

AI Models Integration:
├─ OpenAI GPT-4 Turbo / GPT-4o
│   ├─ API: REST (streaming)
│   ├─ Use: Text generation, transcription
│   ├─ Latency: ~1-2s
│   └─ Cost: $0.01/1K tokens (input)
│
├─ Anthropic Claude 3.5 Sonnet
│   ├─ API: REST (streaming)
│   ├─ Use: Medical analysis, reasoning
│   ├─ Latency: ~1-2s
│   └─ Cost: $0.003/1K tokens
│
├─ Google Gemini Pro 1.5
│   ├─ API: REST (streaming)
│   ├─ Use: Vision, multimodal analysis
│   ├─ Latency: ~1-2s
│   └─ Cost: $0.002/1K tokens
│
└─ Whisper (OpenAI)
    ├─ API: REST
    ├─ Use: Voice transcription (real-time)
    ├─ Latency: < 2s
    └─ Cost: $0.006/minute

Embeddings:
├─ OpenAI text-embedding-3-large (1536 dim)
├─ Cohere Embed v3
└─ Local: Sentence-Transformers (fallback)

Fine-tuning:
├─ GPT-4o Fine-tuning (dental terminology)
├─ Domain-specific models (parodontology, orthodontics)
└─ Custom embeddings (medical KB)

Vector Operations:
├─ Pinecone / Weaviate (vector DB)
├─ FAISS (local similarity search)
└─ LangChain (RAG orchestration)
```

### Infrastructure & DevOps

```yaml
Cloud Provider:
├─ AWS (primary)
│   ├─ ECS/EKS (container orchestration)
│   ├─ Lambda (serverless functions)
│   ├─ S3 (object storage)
│   ├─ CloudFront (CDN)
│   ├─ RDS (managed PostgreSQL)
│   ├─ ElastiCache (managed Redis)
│   ├─ DocumentDB (managed MongoDB)
│   └─ SQS/SNS (messaging)
│
└─ Multi-cloud (disaster recovery)
    ├─ Cloudflare (CDN, DDoS protection)
    └─ Vercel (frontend hosting)

Container Orchestration:
├─ Kubernetes (K8s) 1.28+
│   ├─ EKS (AWS managed)
│   ├─ Horizontal Pod Autoscaler (HPA)
│   ├─ Vertical Pod Autoscaler (VPA)
│   ├─ Cluster Autoscaler
│   └─ Karpenter (node provisioning)

Service Mesh:
├─ Istio / Linkerd
│   ├─ Traffic management
│   ├─ Load balancing
│   ├─ Circuit breaking
│   ├─ mTLS (mutual TLS)
│   └─ Observability

CI/CD:
├─ GitHub Actions (primary)
├─ ArgoCD (GitOps, K8s deployments)
├─ Docker (containerization)
└─ Terraform (Infrastructure as Code)

Monitoring & Observability:
├─ Datadog / New Relic (APM)
├─ Prometheus + Grafana (metrics)
├─ Loki (logs aggregation)
├─ Jaeger (distributed tracing)
└─ Sentry (error tracking)

Security:
├─ AWS WAF (Web Application Firewall)
├─ AWS Shield (DDoS protection)
├─ Cloudflare (CDN + security)
├─ HashiCorp Vault (secrets management)
└─ Snyk (vulnerability scanning)
```

---

## 🎨 Architecture Frontend

### Architecture Applicative

```
┌─────────────────────────────────────────────────────────┐
│                    Browser Client                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐       │
│  │   Pages    │  │  Components │  │   Hooks    │       │
│  │  (Routes)  │  │  (Shared)   │  │  (Logic)   │       │
│  └─────┬──────┘  └─────┬───────┘  └─────┬──────┘       │
│        │               │                 │              │
│  ┌─────▼───────────────▼─────────────────▼──────┐       │
│  │         State Management Layer               │       │
│  │  (Zustand, TanStack Query, Jotai, RxJS)     │       │
│  └─────┬────────────────────────────────────────┘       │
│        │                                                 │
│  ┌─────▼────────────────────────────────────────┐       │
│  │          API Communication Layer             │       │
│  │  (tRPC, GraphQL, WebSocket, SSE)            │       │
│  └─────┬────────────────────────────────────────┘       │
│        │                                                 │
└────────┼─────────────────────────────────────────────────┘
         │
         ▼
   [ API Gateway ]
```

### Modules Frontend

```typescript
/apps
  /web-app                    # Main Next.js application
    /app
      /(auth)                # Auth routes (login, register)
      /(dashboard)           # Dashboard routes (protected)
        /patients            # Patient management
        /dental-chart        # Dental charting
        /paro                # Periodontology
        /ortho               # Orthodontics
        /prescriptions       # Prescriptions
        /imaging             # Medical imaging
        /ai                  # AI features
        /admin               # Administration
      /api                   # API routes (Next.js API)
    /components
      /ui                    # Base UI components (Shadcn)
      /features              # Feature-specific components
      /layouts               # Layout components
    /lib
      /api                   # API clients (tRPC, GraphQL)
      /hooks                 # Custom React hooks
      /utils                 # Utility functions
      /stores                # Zustand stores
    /styles
      /globals.css           # Global styles
      /themes                # Theme configuration

  /landing-page              # Marketing site (separate app)
    /[locale]                # i18n routes (fr, nl, en, de)

/packages
  /ui                        # Shared UI components
  /config                    # Shared configs
  /tsconfig                  # TypeScript configs
  /eslint-config             # ESLint configs
```

### State Management Strategy

```typescript
// 1. Server State (TanStack Query)
// - API data, caching, refetching
import { useQuery, useMutation } from '@tanstack/react-query'

const usePatients = () => {
  return useQuery({
    queryKey: ['patients'],
    queryFn: fetchPatients,
    staleTime: 5 * 60 * 1000, // 5 min
  })
}

// 2. Global Client State (Zustand)
// - User preferences, UI state
import { create } from 'zustand'

const useAppStore = create((set) => ({
  theme: 'dark',
  sidebarOpen: true,
  toggleSidebar: () => set((s) => ({ sidebarOpen: !s.sidebarOpen }))
}))

// 3. Atomic State (Jotai)
// - Granular, composable state
import { atom, useAtom } from 'jotai'

const selectedToothAtom = atom<number | null>(null)

// 4. Reactive Streams (RxJS)
// - Real-time updates, complex async flows
import { fromEvent } from 'rxjs'
import { debounceTime, switchMap } from 'rxjs/operators'

const search$ = fromEvent(input, 'input').pipe(
  debounceTime(300),
  switchMap(e => searchPatients(e.target.value))
)
```

### Real-time Communication

```typescript
// WebSocket Connection (Socket.io)
import io from 'socket.io-client'

const socket = io('wss://api.dentalcockpit.pro', {
  auth: { token: 'jwt-token' },
  transports: ['websocket'],
  reconnection: true,
  reconnectionDelay: 1000,
  reconnectionAttempts: 5
})

// Subscribe to real-time events
socket.on('patient:updated', (data) => {
  queryClient.invalidateQueries(['patients', data.id])
})

socket.on('ai:transcription', (chunk) => {
  setTranscription(prev => prev + chunk.text)
})

// Server-Sent Events (SSE) for streaming
const eventSource = new EventSource('/api/ai/stream')

eventSource.onmessage = (event) => {
  const data = JSON.parse(event.data)
  setStreamData(prev => [...prev, data])
}
```

### Performance Optimizations

```typescript
// 1. Code Splitting (Dynamic Imports)
const DentalChart = dynamic(() => import('@/components/DentalChart'), {
  loading: () => <Skeleton />,
  ssr: false
})

// 2. Image Optimization (Next.js Image)
import Image from 'next/image'

<Image
  src="/xray.jpg"
  alt="X-ray"
  width={800}
  height={600}
  loading="lazy"
  placeholder="blur"
/>

// 3. React Server Components
// app/patients/page.tsx
async function PatientsPage() {
  const patients = await fetchPatients() // Server-side
  return <PatientList patients={patients} />
}

// 4. Suspense Boundaries
<Suspense fallback={<Loading />}>
  <PatientDetails id={id} />
</Suspense>

// 5. Virtual Scrolling (react-window)
import { FixedSizeList } from 'react-window'

<FixedSizeList
  height={600}
  itemCount={1000}
  itemSize={50}
  width="100%"
>
  {Row}
</FixedSizeList>
```

---

## ⚙️ Architecture Backend

### Microservices Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      API Gateway                             │
│              (Kong / AWS API Gateway)                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │   Auth   │  │   Rate   │  │  Load    │                  │
│  │          │  │  Limit   │  │ Balance  │                  │
│  └──────────┘  └──────────┘  └──────────┘                  │
└───────────────────────┬─────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
┌───────▼──────┐ ┌──────▼──────┐ ┌─────▼──────┐
│   Patient    │ │   Imaging   │ │     AI     │
│   Service    │ │   Service   │ │  Service   │
└───────┬──────┘ └──────┬──────┘ └─────┬──────┘
        │               │               │
┌───────▼──────┐ ┌──────▼──────┐ ┌─────▼──────┐
│  Prescription│ │   Billing   │ │  Analytics │
│   Service    │ │   Service   │ │  Service   │
└───────┬──────┘ └──────┬──────┘ └─────┬──────┘
        │               │               │
        └───────────────┼───────────────┘
                        │
                ┌───────▼────────┐
                │  Event Bus     │
                │   (Kafka)      │
                └────────────────┘
```

### Core Services

#### 1. **Patient Service**

```typescript
Responsabilités:
├─ CRUD patients
├─ Timeline patient
├─ Documents médicaux
├─ Rendez-vous
└─ Historique modifications

Technologies:
├─ Fastify + tRPC
├─ MongoDB (patient data)
├─ Redis (cache)
├─ Kafka (events)
└─ Elasticsearch (search)

Endpoints:
├─ GET    /patients
├─ POST   /patients
├─ GET    /patients/:id
├─ PATCH  /patients/:id
├─ DELETE /patients/:id
├─ GET    /patients/:id/timeline
└─ WS     /patients/:id/live

Événements Émis:
├─ patient.created
├─ patient.updated
├─ patient.deleted
└─ patient.visit_started
```

#### 2. **AI Service (RCE Engine)**

```typescript
Responsabilités:
├─ Orchestration modèles IA
├─ Transcription vocale (Whisper)
├─ Génération anamnèse (GPT-4)
├─ Analyse images (Gemini)
├─ Diagnostic assistant (Claude)
└─ Semantic search (embeddings)

Technologies:
├─ Fastify + GraphQL
├─ Python (ML tasks)
├─ Redis (queue + cache)
├─ Kafka (streaming)
├─ Pinecone (vector DB)
├─ LangChain (RAG)
└─ OpenAI/Anthropic/Google APIs

Endpoints:
├─ POST   /ai/transcribe (streaming)
├─ POST   /ai/anamnesis
├─ POST   /ai/analyze-image
├─ POST   /ai/diagnose
├─ POST   /ai/search-similar
├─ WS     /ai/stream
└─ SSE    /ai/transcribe/stream

Model Router Logic:
┌──────────────────┐
│  Request Input   │
└────────┬─────────┘
         │
    ┌────▼─────┐
    │ Analyzer │ (task type, urgency, cost)
    └────┬─────┘
         │
    ┌────▼─────────────────┐
    │  Model Selection     │
    │  ├─ Transcription → Whisper
    │  ├─ Text Gen → GPT-4 / Claude
    │  ├─ Vision → Gemini
    │  └─ Cheap → GPT-3.5
    └────┬─────────────────┘
         │
    ┌────▼─────────────┐
    │  Load Balancer   │ (rate limits, quotas)
    └────┬─────────────┘
         │
    ┌────▼─────────────┐
    │   API Call       │
    └────┬─────────────┘
         │
    ┌────▼─────────────┐
    │  Cache Result    │ (Redis, 1h TTL)
    └────┬─────────────┘
         │
    ┌────▼─────────────┐
    │  Return Result   │
    └──────────────────┘
```

#### 3. **Imaging Service**

```typescript
Responsabilités:
├─ Upload images (X-ray, 3D scans, photos)
├─ Image processing (resize, compress)
├─ DICOM handling
├─ AI analysis trigger
└─ Annotations & measurements

Technologies:
├─ Fastify
├─ Sharp (image processing)
├─ DICOM parser
├─ S3 (storage)
├─ CloudFront (CDN)
├─ Redis (metadata cache)
└─ Kafka (events)

Storage Strategy:
├─ Original: S3 Standard (hot)
├─ Processed: S3 Standard (hot)
├─ Archive: S3 Glacier (cold, >1 year)
└─ CDN: CloudFront (edge locations)

Endpoints:
├─ POST   /imaging/upload
├─ GET    /imaging/:id
├─ POST   /imaging/:id/analyze
├─ POST   /imaging/:id/annotate
├─ GET    /imaging/:id/thumbnail
└─ DELETE /imaging/:id
```

#### 4. **Prescription Service**

```typescript
Responsabilités:
├─ Création prescriptions
├─ Intégration Recip-e (Belgique)
├─ Vérification interactions médicamenteuses
├─ Base médicamenteuse
├─ Historique prescriptions
└─ Signatures électroniques

Technologies:
├─ Fastify + tRPC
├─ PostgreSQL (prescriptions, audit)
├─ MongoDB (médicaments DB)
├─ Redis (cache DB médicaments)
├─ Recip-e API (e-Health Belgium)
└─ Kafka (events)

Workflow:
┌──────────────────┐
│ Create Rx        │
└────────┬─────────┘
         │
    ┌────▼─────────────────┐
    │ Check Interactions   │ (drug database)
    └────┬─────────────────┘
         │
    ┌────▼─────────────────┐
    │ AI Suggestions       │ (RCE + patient history)
    └────┬─────────────────┘
         │
    ┌────▼─────────────────┐
    │ Generate Recip-e     │ (QR code, e-Health)
    └────┬─────────────────┘
         │
    ┌────▼─────────────────┐
    │ Digital Signature    │ (eID, PKCS#11)
    └────┬─────────────────┘
         │
    ┌────▼─────────────────┐
    │ Send to Patient      │ (Email/SMS)
    └──────────────────────┘
```

#### 5. **Billing Service**

```typescript
Responsabilités:
├─ Facturation patients
├─ Intégration INAMI
├─ Gestion mutuelles
├─ Attestations électroniques
├─ Paiements (Stripe, Mollie)
└─ Rapports comptables

Technologies:
├─ Fastify + tRPC
├─ PostgreSQL (invoices, transactions)
├─ Stripe API (payments)
├─ INAMI API (Belgian healthcare)
├─ Redis (cache rates)
├─ Kafka (events)
└─ PDF generation (Puppeteer)

Endpoints:
├─ POST   /billing/invoice
├─ POST   /billing/inami/attestation
├─ GET    /billing/invoices
├─ POST   /billing/payment
├─ GET    /billing/reports
└─ POST   /billing/export
```

#### 6. **Analytics Service**

```typescript
Responsabilités:
├─ KPIs temps réel
├─ Prévisions IA (revenus, taux remplissage)
├─ Rapports personnalisés
├─ Data warehouse
└─ Business Intelligence

Technologies:
├─ Node.js + GraphQL
├─ TimescaleDB (time-series)
├─ ClickHouse (analytics DB)
├─ Apache Superset (BI)
├─ Python (ML predictions)
├─ Redis (cache)
└─ Kafka (streaming analytics)

Métriques Trackées:
├─ Patients actifs
├─ Taux remplissage agenda
├─ Revenus (jour/semaine/mois)
├─ No-shows rate
├─ Analyses IA utilisées
├─ Temps moyen consultation
└─ Satisfaction patient (NPS)
```

---

## 🧠 Architecture RCE AI Engine

### RCE Orchestration Layer

```python
# rce_engine/orchestrator.py

from dataclasses import dataclass
from enum import Enum
from typing import Optional, List

class ModelProvider(Enum):
    OPENAI = "openai"
    ANTHROPIC = "anthropic"
    GOOGLE = "google"

class TaskType(Enum):
    TRANSCRIPTION = "transcription"
    TEXT_GENERATION = "text_generation"
    IMAGE_ANALYSIS = "image_analysis"
    DIAGNOSIS = "diagnosis"
    SEMANTIC_SEARCH = "semantic_search"

@dataclass
class ModelCapability:
    provider: ModelProvider
    model_name: str
    task_types: List[TaskType]
    cost_per_1k: float
    latency_ms: int
    quality_score: float
    max_tokens: int

class RCEOrchestrator:
    """
    RCE (Relational Cognitive Engine) Orchestrator
    Intelligently routes requests to optimal AI model
    """

    def __init__(self):
        self.models = self._init_models()
        self.cache = RedisCache()
        self.rate_limiter = RateLimiter()
        self.load_balancer = LoadBalancer()

    def _init_models(self) -> List[ModelCapability]:
        return [
            # OpenAI Models
            ModelCapability(
                provider=ModelProvider.OPENAI,
                model_name="gpt-4-turbo",
                task_types=[TaskType.TEXT_GENERATION, TaskType.DIAGNOSIS],
                cost_per_1k=0.01,
                latency_ms=1500,
                quality_score=0.95,
                max_tokens=128000
            ),
            ModelCapability(
                provider=ModelProvider.OPENAI,
                model_name="whisper-1",
                task_types=[TaskType.TRANSCRIPTION],
                cost_per_1k=0.006,
                latency_ms=2000,
                quality_score=0.98,
                max_tokens=None
            ),

            # Anthropic Models
            ModelCapability(
                provider=ModelProvider.ANTHROPIC,
                model_name="claude-3-5-sonnet",
                task_types=[TaskType.TEXT_GENERATION, TaskType.DIAGNOSIS],
                cost_per_1k=0.003,
                latency_ms=1200,
                quality_score=0.97,
                max_tokens=200000
            ),

            # Google Models
            ModelCapability(
                provider=ModelProvider.GOOGLE,
                model_name="gemini-pro-1.5",
                task_types=[TaskType.IMAGE_ANALYSIS, TaskType.TEXT_GENERATION],
                cost_per_1k=0.002,
                latency_ms=1000,
                quality_score=0.92,
                max_tokens=1000000
            ),
        ]

    async def route_request(
        self,
        task_type: TaskType,
        input_data: dict,
        priority: str = "balanced",  # "cost", "speed", "quality", "balanced"
        user_id: str = None
    ) -> dict:
        """
        Intelligently route request to optimal model
        """

        # 1. Check cache
        cache_key = self._generate_cache_key(task_type, input_data)
        cached = await self.cache.get(cache_key)
        if cached:
            return {"source": "cache", "result": cached}

        # 2. Select optimal model
        model = self._select_model(task_type, priority, user_id)

        # 3. Check rate limits
        if not await self.rate_limiter.check(user_id, model.provider):
            # Fallback to cheaper model
            model = self._select_fallback_model(task_type)

        # 4. Execute request with load balancing
        try:
            result = await self.load_balancer.execute(
                model=model,
                input_data=input_data
            )

            # 5. Cache result
            await self.cache.set(cache_key, result, ttl=3600)

            # 6. Log metrics
            await self._log_metrics(model, result)

            return {
                "source": "ai",
                "model": model.model_name,
                "provider": model.provider.value,
                "result": result
            }

        except Exception as e:
            # Fallback chain
            return await self._execute_fallback(task_type, input_data)

    def _select_model(
        self,
        task_type: TaskType,
        priority: str,
        user_id: str
    ) -> ModelCapability:
        """
        Select optimal model based on task and priority
        """
        candidates = [m for m in self.models if task_type in m.task_types]

        if priority == "cost":
            return min(candidates, key=lambda m: m.cost_per_1k)
        elif priority == "speed":
            return min(candidates, key=lambda m: m.latency_ms)
        elif priority == "quality":
            return max(candidates, key=lambda m: m.quality_score)
        else:  # balanced
            # Weighted score
            return max(candidates, key=lambda m: (
                m.quality_score * 0.5 +
                (1 - m.cost_per_1k / 0.01) * 0.3 +
                (1 - m.latency_ms / 3000) * 0.2
            ))

    async def stream_response(
        self,
        task_type: TaskType,
        input_data: dict,
        callback: callable
    ):
        """
        Stream responses in real-time (for transcription, text generation)
        """
        model = self._select_model(task_type, "speed", None)

        async for chunk in self._stream_from_model(model, input_data):
            await callback(chunk)
```

### Streaming Architecture

```typescript
// Real-time AI Transcription Streaming

// Backend: ai-service/streaming.ts
import { EventEmitter } from 'events'

class TranscriptionStream extends EventEmitter {
  private whisperClient: WhisperClient
  private buffer: Buffer[] = []

  async startStream(audioStream: ReadableStream) {
    const reader = audioStream.getReader()

    while (true) {
      const { done, value } = await reader.read()
      if (done) break

      this.buffer.push(value)

      // Send chunks every 500ms for real-time transcription
      if (this.buffer.length >= 10) {
        const chunk = Buffer.concat(this.buffer)
        this.buffer = []

        const transcription = await this.whisperClient.transcribe(chunk)

        // Emit to all connected clients via Kafka
        await kafka.send({
          topic: 'transcription-stream',
          messages: [{
            key: sessionId,
            value: JSON.stringify({
              text: transcription.text,
              timestamp: Date.now(),
              confidence: transcription.confidence
            })
          }]
        })
      }
    }
  }
}

// Frontend: hooks/useAITranscription.ts
import { useEffect, useState } from 'react'

export const useAITranscription = (sessionId: string) => {
  const [transcription, setTranscription] = useState('')
  const [isRecording, setIsRecording] = useState(false)

  useEffect(() => {
    const eventSource = new EventSource(
      `/api/ai/transcribe/stream?session=${sessionId}`
    )

    eventSource.onmessage = (event) => {
      const data = JSON.parse(event.data)
      setTranscription(prev => prev + ' ' + data.text)
    }

    return () => eventSource.close()
  }, [sessionId])

  const startRecording = async () => {
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
    const mediaRecorder = new MediaRecorder(stream)

    mediaRecorder.ondataavailable = async (event) => {
      // Send audio chunk to backend
      await fetch('/api/ai/transcribe/chunk', {
        method: 'POST',
        body: event.data
      })
    }

    mediaRecorder.start(500) // chunk every 500ms
    setIsRecording(true)
  }

  return { transcription, isRecording, startRecording }
}
```

---

## 💾 Architecture Base de Données

### Data Model (MongoDB)

```typescript
// Patient Collection
{
  _id: ObjectId,
  tenantId: ObjectId,  // Multi-tenant isolation
  personalInfo: {
    firstName: string,
    lastName: string,
    dateOfBirth: Date,
    gender: "M" | "F" | "X",
    nationalRegister: string,  // Encrypted
    email: string,
    phone: string,
    address: {
      street: string,
      city: string,
      postalCode: string,
      country: string
    }
  },
  medicalInfo: {
    allergies: string[],
    medications: string[],
    conditions: string[],
    bloodType: string,
    insuranceNumber: string  // Encrypted
  },
  dentalHistory: {
    lastVisit: Date,
    nextAppointment: Date,
    treatments: [{
      date: Date,
      toothNumber: number,
      treatmentType: string,
      notes: string,
      cost: number
    }],
    currentStatus: {
      teeth: {
        [toothNumber: number]: {
          status: "healthy" | "caries" | "filled" | "crown" | "missing",
          lastUpdated: Date,
          notes: string
        }
      }
    }
  },
  timeline: [{
    _id: ObjectId,
    timestamp: Date,
    type: "visit" | "treatment" | "note" | "image" | "prescription",
    data: object,
    createdBy: ObjectId
  }],
  aiData: {
    embeddings: number[],  // 1536 dimensions
    riskScores: {
      caries: number,
      periodontal: number,
      orthodontic: number
    },
    predictions: object
  },
  metadata: {
    createdAt: Date,
    updatedAt: Date,
    createdBy: ObjectId,
    lastModifiedBy: ObjectId,
    version: number  // Optimistic locking
  }
}

// Indexes
db.patients.createIndex({ tenantId: 1, "personalInfo.lastName": 1 })
db.patients.createIndex({ tenantId: 1, "personalInfo.email": 1 }, { unique: true })
db.patients.createIndex({ "timeline.timestamp": -1 })
db.patients.createIndex({ "dentalHistory.nextAppointment": 1 })

// Sharding Key
sh.shardCollection("dentalcockpit.patients", { tenantId: 1, _id: 1 })
```

```typescript
// Medical Images Collection
{
  _id: ObjectId,
  tenantId: ObjectId,
  patientId: ObjectId,
  type: "xray" | "scan3d" | "photo" | "camera",
  s3Key: string,  // S3 object key
  s3Bucket: string,
  cdnUrl: string,  // CloudFront URL
  metadata: {
    width: number,
    height: number,
    size: number,
    mimeType: string,
    captureDate: Date,
    device: string,
    dicomData: object  // If DICOM
  },
  aiAnalysis: {
    analyzed: boolean,
    analysisDate: Date,
    model: string,
    results: {
      detections: [{
        type: "caries" | "bone-loss" | "crown" | "filling",
        confidence: number,
        boundingBox: { x, y, width, height },
        toothNumber: number
      }],
      recommendations: string[],
      riskScore: number
    }
  },
  annotations: [{
    userId: ObjectId,
    timestamp: Date,
    type: "measurement" | "note" | "marker",
    data: object
  }],
  createdAt: Date,
  updatedAt: Date
}

// Indexes
db.medicalImages.createIndex({ tenantId: 1, patientId: 1, createdAt: -1 })
db.medicalImages.createIndex({ "aiAnalysis.analyzed": 1 })
```

### Vector Database (Pinecone)

```python
# Semantic Search & RAG

# Store patient case embeddings
{
  "id": "case_123456",
  "values": [0.1, 0.2, ...],  # 1536 dimensions
  "metadata": {
    "tenantId": "tenant_abc",
    "patientId": "patient_xyz",
    "diagnosis": "Severe periodontitis",
    "treatment": "Scaling and root planing",
    "outcome": "Successful",
    "date": "2025-01-15",
    "symptoms": ["bleeding gums", "tooth mobility"],
    "age": 45,
    "gender": "F"
  }
}

# Query similar cases
query_embedding = openai.embeddings.create(
    model="text-embedding-3-large",
    input="Patient with bleeding gums and tooth pain"
)

results = index.query(
    vector=query_embedding.data[0].embedding,
    filter={
        "tenantId": {"$eq": "tenant_abc"},
        "age": {"$gte": 40, "$lte": 50}
    },
    top_k=10,
    include_metadata=True
)

# Use results for RAG (Retrieval Augmented Generation)
context = "\n\n".join([r.metadata["diagnosis"] for r in results])
prompt = f"Based on similar cases:\n{context}\n\nSuggest treatment for: {patient_symptoms}"
```

### Caching Strategy (Redis)

```typescript
// Multi-layer caching

// L1: Application Memory Cache (LRU)
const memCache = new LRUCache({ max: 1000, ttl: 60000 })

// L2: Redis Cache (Distributed)
const redis = new Redis.Cluster([...nodes])

// L3: Database (MongoDB)

// Cache-aside pattern
async function getPatient(id: string) {
  // L1: Check memory
  let patient = memCache.get(id)
  if (patient) return patient

  // L2: Check Redis
  patient = await redis.get(`patient:${id}`)
  if (patient) {
    memCache.set(id, patient)
    return JSON.parse(patient)
  }

  // L3: Query database
  patient = await db.patients.findOne({ _id: id })
  if (patient) {
    await redis.setex(`patient:${id}`, 300, JSON.stringify(patient))
    memCache.set(id, patient)
  }

  return patient
}

// Cache invalidation on updates
async function updatePatient(id: string, data: any) {
  await db.patients.updateOne({ _id: id }, { $set: data })

  // Invalidate all cache layers
  memCache.delete(id)
  await redis.del(`patient:${id}`)

  // Publish cache invalidation event
  await redis.publish('cache:invalidate', JSON.stringify({ type: 'patient', id }))
}
```

### Event Sourcing (Audit Trail)

```typescript
// Event Store (MongoDB)
{
  _id: ObjectId,
  aggregateId: ObjectId,  // Patient ID
  aggregateType: "patient",
  eventType: "patient_updated" | "treatment_added" | "image_uploaded",
  eventData: {
    before: object,
    after: object,
    changes: string[]
  },
  metadata: {
    userId: ObjectId,
    ipAddress: string,
    userAgent: string,
    timestamp: Date
  },
  version: number  // Event version for ordering
}

// Replay events to rebuild state
async function rebuildPatientState(patientId: string, upToVersion?: number) {
  const events = await db.events.find({
    aggregateId: patientId,
    ...(upToVersion && { version: { $lte: upToVersion } })
  }).sort({ version: 1 })

  let state = {}
  for (const event of events) {
    state = applyEvent(state, event)
  }

  return state
}
```

---

## 🔄 Architecture Streaming & Temps Réel

### WebSocket Architecture (Socket.io)

```typescript
// Backend: websocket-server.ts
import { Server } from 'socket.io'
import { RedisAdapter } from '@socket.io/redis-adapter'

const io = new Server(httpServer, {
  cors: { origin: process.env.FRONTEND_URL },
  adapter: RedisAdapter  // Multi-server support
})

// Namespace per tenant for isolation
io.of(/^\/tenant-\w+$/).on('connection', async (socket) => {
  const tenantId = socket.nsp.name.replace('/tenant-', '')

  // Authenticate
  const user = await authenticateSocket(socket.handshake.auth.token)
  if (!user || user.tenantId !== tenantId) {
    socket.disconnect()
    return
  }

  // Join tenant room
  socket.join(`tenant:${tenantId}`)

  // Join personal room
  socket.join(`user:${user.id}`)

  // Subscribe to patient updates
  socket.on('subscribe:patient', (patientId) => {
    if (hasPermission(user, 'read', 'patient', patientId)) {
      socket.join(`patient:${patientId}`)
    }
  })

  // Real-time collaboration on dental chart
  socket.on('dentalChart:update', async (data) => {
    // Save to DB
    await db.patients.updateOne(
      { _id: data.patientId },
      { $set: { [`dentalHistory.currentStatus.teeth.${data.toothNumber}`]: data.status } }
    )

    // Broadcast to all users viewing this patient
    socket.to(`patient:${data.patientId}`).emit('dentalChart:updated', {
      toothNumber: data.toothNumber,
      status: data.status,
      updatedBy: user.id,
      timestamp: Date.now()
    })
  })

  // AI transcription streaming
  socket.on('ai:startTranscription', async (sessionId) => {
    const stream = transcriptionStreams.get(sessionId)

    stream.on('chunk', (text) => {
      socket.emit('ai:transcriptionChunk', { text, sessionId })
    })

    stream.on('complete', (fullText) => {
      socket.emit('ai:transcriptionComplete', { fullText, sessionId })
    })
  })
})

// Kafka consumer for broadcasting events
kafka.consumer.on('message', (message) => {
  const event = JSON.parse(message.value)

  // Broadcast to relevant rooms
  io.of(`/tenant-${event.tenantId}`)
    .to(`patient:${event.patientId}`)
    .emit(event.type, event.data)
})
```

### Server-Sent Events (SSE)

```typescript
// Backend: sse-controller.ts
app.get('/api/ai/stream/:sessionId', async (req, res) => {
  const { sessionId } = req.params

  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive',
    'X-Accel-Buffering': 'no'  // Nginx buffering off
  })

  // Subscribe to Kafka topic
  const consumer = kafka.consumer({ groupId: `sse-${sessionId}` })
  await consumer.subscribe({ topic: `ai-stream-${sessionId}` })

  await consumer.run({
    eachMessage: async ({ message }) => {
      const data = JSON.parse(message.value.toString())

      // Send SSE event
      res.write(`data: ${JSON.stringify(data)}\n\n`)
    }
  })

  // Cleanup on client disconnect
  req.on('close', async () => {
    await consumer.disconnect()
    res.end()
  })
})
```

### Kafka Event Streaming

```yaml
Topics:
  patient-events:
    partitions: 12
    replication: 3
    retention: 7 days
    consumers:
      - analytics-service
      - notification-service
      - audit-service

  ai-transcription-stream:
    partitions: 6
    replication: 3
    retention: 1 hour
    consumers:
      - frontend-sse-gateway
      - transcription-archive

  dental-chart-updates:
    partitions: 12
    replication: 3
    retention: 30 days
    consumers:
      - websocket-gateway
      - audit-service
      - analytics-service

Producers:
  - patient-service
  - ai-service
  - dental-chart-service
  - imaging-service

Consumer Groups:
  - real-time (low latency)
  - analytics (batch processing)
  - audit (all events)
```

---

## 📈 Architecture Scalabilité

### Horizontal Scaling

```yaml
Auto-Scaling Configuration:

API Services (ECS/EKS):
  min_instances: 3
  max_instances: 50
  target_cpu: 70%
  target_memory: 80%
  scale_up_cooldown: 60s
  scale_down_cooldown: 300s

AI Service:
  min_instances: 5
  max_instances: 100
  target_cpu: 80%
  gpu_instances: true (Tesla T4)
  queue_depth_threshold: 100

WebSocket Service:
  min_instances: 3
  max_instances: 20
  connections_per_instance: 5000
  sticky_sessions: true

Database:
  MongoDB:
    shards: 3
    replica_set_per_shard: 3
    max_shards: 12

  Redis:
    cluster_nodes: 6
    replicas_per_node: 2
    max_memory_policy: allkeys-lru

  PostgreSQL:
    read_replicas: 3
    max_connections: 1000
    connection_pooling: PgBouncer (10,000 pool)
```

### Load Balancing Strategy

```
┌─────────────────────────────────────────┐
│   CloudFlare (DDoS Protection + CDN)    │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│   AWS Application Load Balancer (ALB)   │
│   ├─ Health Checks (every 5s)          │
│   ├─ SSL Termination                   │
│   ├─ Sticky Sessions (WebSocket)       │
│   └─ Request Routing                   │
└──────────────────┬──────────────────────┘
                   │
      ┌────────────┼────────────┐
      │            │            │
┌─────▼────┐ ┌────▼─────┐ ┌───▼──────┐
│ API Pod  │ │ API Pod  │ │ API Pod  │
│   #1     │ │   #2     │ │   #3     │
└──────────┘ └──────────┘ └──────────┘

Load Balancing Algorithms:
├─ API Services: Round Robin
├─ WebSocket: Sticky Session (based on user ID)
├─ AI Services: Least Connections
└─ Read Queries: Weighted Round Robin (replicas)
```

### Database Sharding Strategy

```typescript
// MongoDB Sharding (Tenant-based)

// Shard Key: { tenantId: 1, _id: 1 }
// - tenantId ensures tenant isolation
// - _id ensures uniqueness

// Shard Distribution:
// Shard 1: tenantId hash 0x00000000 - 0x55555555
// Shard 2: tenantId hash 0x55555556 - 0xAAAAAAAA
// Shard 3: tenantId hash 0xAAAAAAAAAB - 0xFFFFFFFF

// Query Routing:
// With tenantId → Single shard (fast)
db.patients.find({ tenantId: "abc123", lastName: "Smith" })
// Routed to shard containing "abc123"

// Without tenantId → Scatter-gather (slow, avoid!)
db.patients.find({ lastName: "Smith" })
// Queries all shards, merges results

// Best Practices:
// 1. Always include tenantId in queries
// 2. Pre-split chunks for even distribution
// 3. Monitor shard balance monthly
// 4. Use compound indexes with tenantId prefix
```

### Caching & CDN Strategy

```
┌──────────────────────────────────────────────────┐
│              Client Browser                       │
│  ├─ Service Worker (offline cache)              │
│  └─ IndexedDB (local patient data)              │
└───────────────────┬──────────────────────────────┘
                    │
┌───────────────────▼──────────────────────────────┐
│         CloudFront CDN (Edge Locations)          │
│  ├─ Static Assets (JS, CSS, Images)             │
│  ├─ Medical Images (X-rays, 3D scans)           │
│  ├─ TTL: 1 year (immutable assets)              │
│  └─ Cache-Control headers                       │
└───────────────────┬──────────────────────────────┘
                    │
┌───────────────────▼──────────────────────────────┐
│           Redis Cluster (L1 Cache)               │
│  ├─ Hot data (frequently accessed)              │
│  ├─ TTL: 5 minutes - 1 hour                     │
│  ├─ Pub/Sub for cache invalidation              │
│  └─ 100GB RAM per node                          │
└───────────────────┬──────────────────────────────┘
                    │
┌───────────────────▼──────────────────────────────┐
│        MongoDB (Primary Database)                │
│  └─ Persistent storage                          │
└──────────────────────────────────────────────────┘

Cache Layers:
1. Browser (Service Worker): 24h - 1 year
2. CDN (CloudFront): 1 hour - 1 year
3. Redis (Distributed): 5 min - 1 hour
4. MongoDB: Source of truth
```

### Rate Limiting

```typescript
// Multi-layer rate limiting

// 1. CloudFlare (DDoS protection)
// - 1000 req/min per IP
// - Automatic challenge for suspicious traffic

// 2. API Gateway (Kong)
import rateLimit from 'express-rate-limit'

const apiLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: async (req) => {
    const user = req.user

    // Different limits per plan
    switch (user.plan) {
      case 'starter': return 100
      case 'professional': return 500
      case 'enterprise': return 2000
      default: return 60  // Free tier
    }
  },
  standardHeaders: true,
  legacyHeaders: false,
  store: new RedisStore({
    client: redis,
    prefix: 'rl:'
  })
})

// 3. AI Service (Token-based)
const aiLimiter = {
  starter: { tokens: 10000, period: 'month' },
  professional: { tokens: 100000, period: 'month' },
  enterprise: { tokens: -1 }  // unlimited
}

// 4. WebSocket (Connection limit)
const wsLimiter = {
  maxConnectionsPerUser: 5,
  maxMessagesPerSecond: 10,
  banDuration: 300  // 5 minutes if exceeded
}
```

---

## 🔒 Sécurité & Conformité

### Authentification & Autorisation

```typescript
// Auth Architecture

// 1. OAuth 2.0 + OpenID Connect (OIDC)
// 2. JWT (Access Token + Refresh Token)
// 3. RBAC (Role-Based Access Control)

// JWT Structure
{
  // Header
  "alg": "RS256",
  "typ": "JWT",

  // Payload
  "sub": "user_123",
  "tenantId": "tenant_abc",
  "role": "dentist",
  "permissions": ["patient:read", "patient:write", "treatment:write"],
  "plan": "professional",
  "iat": 1700000000,
  "exp": 1700003600,  // 1 hour

  // Signature (RS256)
}

// Roles & Permissions
const roles = {
  admin: {
    permissions: ["*:*"]  // All permissions
  },
  dentist: {
    permissions: [
      "patient:*",
      "treatment:*",
      "prescription:*",
      "imaging:*",
      "ai:*",
      "billing:read"
    ]
  },
  assistant: {
    permissions: [
      "patient:read",
      "patient:write",
      "imaging:read",
      "imaging:upload",
      "agenda:*"
    ]
  },
  receptionist: {
    permissions: [
      "patient:read",
      "agenda:*",
      "billing:*"
    ]
  }
}

// Permission Check Middleware
const requirePermission = (resource: string, action: string) => {
  return async (req, res, next) => {
    const user = req.user

    // Check if user has permission
    if (!hasPermission(user.permissions, resource, action)) {
      return res.status(403).json({ error: 'Forbidden' })
    }

    // Check tenant isolation
    if (req.params.tenantId && req.params.tenantId !== user.tenantId) {
      return res.status(403).json({ error: 'Access denied' })
    }

    next()
  }
}

// Usage
app.get('/patients/:id',
  authenticate,
  requirePermission('patient', 'read'),
  getPatient
)
```

### Encryption

```yaml
Encryption at Rest:
  MongoDB:
    - Field-level encryption (sensitive fields)
    - Storage engine: WiredTiger with encryption
    - Keys: AWS KMS (rotation every 90 days)

  S3:
    - SSE-KMS (Server-Side Encryption with KMS)
    - Bucket policy: enforce encryption
    - Keys: AWS KMS (automatic rotation)

  PostgreSQL:
    - Transparent Data Encryption (TDE)
    - Backup encryption
    - Keys: AWS KMS

Encryption in Transit:
  - TLS 1.3 (minimum TLS 1.2)
  - Strong ciphers only (AES-256-GCM)
  - Certificate pinning (mobile apps)
  - mTLS for service-to-service

Encryption in Application:
  - Sensitive fields (NationalRegister, InsuranceNumber)
  - AES-256-GCM
  - Unique IV per record
  - Key management: HashiCorp Vault
```

### RGPD / GDPR Compliance

```typescript
// GDPR Implementation

// 1. Consent Management
interface Consent {
  userId: string
  consentType: 'marketing' | 'analytics' | 'medical'
  granted: boolean
  timestamp: Date
  ipAddress: string
  version: string  // Consent policy version
}

// 2. Right to Access (Data Export)
async function exportUserData(userId: string) {
  const patient = await db.patients.findOne({ _id: userId })
  const images = await db.images.find({ patientId: userId })
  const prescriptions = await db.prescriptions.find({ patientId: userId })
  const invoices = await db.invoices.find({ patientId: userId })

  // Generate PDF/ZIP with all data
  return {
    personalInfo: patient.personalInfo,
    medicalInfo: patient.medicalInfo,
    dentalHistory: patient.dentalHistory,
    images: images.map(i => i.cdnUrl),
    prescriptions,
    invoices,
    exportDate: new Date(),
    format: 'JSON'
  }
}

// 3. Right to Erasure (Delete)
async function deleteUserData(userId: string) {
  // Soft delete (for legal retention)
  await db.patients.updateOne(
    { _id: userId },
    {
      $set: {
        deleted: true,
        deletedAt: new Date(),
        'personalInfo.firstName': '[DELETED]',
        'personalInfo.lastName': '[DELETED]',
        'personalInfo.email': `deleted_${userId}@deleted.com`,
        'personalInfo.phone': '[DELETED]'
      }
    }
  )

  // Anonymize in event logs
  await db.events.updateMany(
    { 'metadata.userId': userId },
    { $set: { 'metadata.userId': 'ANONYMIZED' } }
  )

  // Schedule hard delete after retention period (7 years)
  await scheduleJob({
    type: 'hard_delete_user',
    userId,
    executeAt: addYears(new Date(), 7)
  })
}

// 4. Data Breach Notification (within 72h)
async function notifyDataBreach(breach: DataBreach) {
  // Notify DPA (Data Protection Authority)
  await notifyDPA(breach)

  // Notify affected users
  const affectedUsers = await getAffectedUsers(breach)
  for (const user of affectedUsers) {
    await sendEmail(user.email, 'data_breach', {
      breachType: breach.type,
      dataAffected: breach.dataTypes,
      actionTaken: breach.mitigationSteps
    })
  }

  // Log notification
  await db.breaches.insertOne({
    ...breach,
    notifiedAt: new Date(),
    notifiedUsers: affectedUsers.length
  })
}

// 5. Audit Logging (all data access)
async function logDataAccess(access: DataAccess) {
  await db.auditLogs.insertOne({
    userId: access.userId,
    resource: access.resource,
    action: access.action,
    timestamp: new Date(),
    ipAddress: access.ipAddress,
    userAgent: access.userAgent,
    dataAccessed: access.fields,
    justification: access.reason
  })
}
```

### Belgian Healthcare Compliance (INAMI/e-Health)

```typescript
// INAMI Integration

// 1. eID Authentication (Belgian eID)
import { verifyEID } from 'beid-middleware'

async function authenticateWithEID(cardData: Buffer) {
  const certificate = await verifyEID(cardData)

  // Verify with INAMI registry
  const practitioner = await inami.verifyPractitioner(certificate.nationalNumber)

  if (!practitioner.active) {
    throw new Error('Practitioner not registered with INAMI')
  }

  return {
    userId: practitioner.id,
    nationalNumber: practitioner.nationalNumber,
    specialization: practitioner.specialization,
    inamiNumber: practitioner.inamiNumber
  }
}

// 2. Recip-e Prescription (e-Health)
import { RecipeClient } from '@ehealth/recipe'

async function createRecipePrescription(prescription: Prescription) {
  const recipeClient = new RecipeClient({
    endpoint: 'https://services.recipe.be',
    certificate: await getCertificate(),
    key: await getPrivateKey()
  })

  // Create prescription in Recip-e system
  const recipe = await recipeClient.createPrescription({
    patientSSIN: prescription.patientSSIN,
    practitionerNIHII: prescription.practitionerNIHII,
    medications: prescription.medications.map(med => ({
      code: med.cnkCode,  // Belgian CNK code
      quantity: med.quantity,
      dosage: med.dosage,
      duration: med.duration
    })),
    validUntil: addDays(new Date(), 90)
  })

  // Generate QR code
  const qrCode = await generateQRCode(recipe.prescriptionId)

  // Send to patient (email/SMS)
  await sendPrescription(prescription.patientId, {
    prescriptionId: recipe.prescriptionId,
    qrCode,
    deliveryUrl: recipe.deliveryUrl
  })

  return recipe
}

// 3. MyCareNet (Attestation électronique)
import { MyCareNetClient } from '@mycarenet/sdk'

async function sendAttestation(attestation: Attestation) {
  const mcnClient = new MyCareNetClient({
    endpoint: 'https://mycarenet.be',
    certificate: await getCertificate()
  })

  // Send attestation to insurance
  const response = await mcnClient.sendAttestation({
    practitionerNIHII: attestation.practitionerNIHII,
    patientSSIN: attestation.patientSSIN,
    prestationCode: attestation.prestationCode,
    date: attestation.date,
    amount: attestation.amount,
    insurance: attestation.insurance
  })

  // Store response
  await db.attestations.updateOne(
    { _id: attestation._id },
    {
      $set: {
        status: response.accepted ? 'accepted' : 'rejected',
        myCareNetResponse: response,
        processedAt: new Date()
      }
    }
  )

  return response
}
```

---

## 📊 Monitoring & Observabilité

### Metrics Collection

```typescript
// Prometheus Metrics

import { register, Counter, Histogram, Gauge } from 'prom-client'

// HTTP Requests
const httpRequestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route', 'status_code']
})

const httpRequestTotal = new Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status_code']
})

// AI Requests
const aiRequestDuration = new Histogram({
  name: 'ai_request_duration_seconds',
  help: 'AI request duration in seconds',
  labelNames: ['model', 'task_type']
})

const aiRequestCost = new Counter({
  name: 'ai_request_cost_dollars',
  help: 'AI request cost in dollars',
  labelNames: ['model', 'tenant_id']
})

// Database Queries
const dbQueryDuration = new Histogram({
  name: 'db_query_duration_seconds',
  help: 'Database query duration in seconds',
  labelNames: ['collection', 'operation']
})

// WebSocket Connections
const wsConnections = new Gauge({
  name: 'websocket_connections',
  help: 'Active WebSocket connections',
  labelNames: ['tenant_id']
})

// Middleware to track metrics
app.use((req, res, next) => {
  const start = Date.now()

  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000

    httpRequestDuration.labels(req.method, req.route?.path, res.statusCode).observe(duration)
    httpRequestTotal.labels(req.method, req.route?.path, res.statusCode).inc()
  })

  next()
})
```

### Distributed Tracing (Jaeger)

```typescript
// OpenTelemetry + Jaeger

import { NodeTracerProvider } from '@opentelemetry/sdk-trace-node'
import { JaegerExporter } from '@opentelemetry/exporter-jaeger'
import { registerInstrumentations } from '@opentelemetry/instrumentation'
import { HttpInstrumentation } from '@opentelemetry/instrumentation-http'
import { MongoDBInstrumentation } from '@opentelemetry/instrumentation-mongodb'

const provider = new NodeTracerProvider()

provider.addSpanProcessor(
  new BatchSpanProcessor(
    new JaegerExporter({
      endpoint: 'http://jaeger:14268/api/traces'
    })
  )
)

provider.register()

registerInstrumentations({
  instrumentations: [
    new HttpInstrumentation(),
    new MongoDBInstrumentation(),
    new RedisInstrumentation()
  ]
})

// Custom span
const tracer = provider.getTracer('dental-api')

async function getPatient(id: string) {
  const span = tracer.startSpan('getPatient')
  span.setAttribute('patient.id', id)

  try {
    const patient = await db.patients.findOne({ _id: id })
    span.setAttribute('patient.found', !!patient)
    return patient
  } catch (error) {
    span.recordException(error)
    throw error
  } finally {
    span.end()
  }
}
```

### Alerting (Prometheus Alertmanager)

```yaml
# Alerting Rules

groups:
  - name: api_alerts
    interval: 30s
    rules:
      # High Error Rate
      - alert: HighErrorRate
        expr: |
          rate(http_requests_total{status_code=~"5.."}[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value }} (threshold: 0.05)"

      # Slow Response Time
      - alert: SlowResponseTime
        expr: |
          histogram_quantile(0.95, http_request_duration_seconds) > 1
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Slow response time detected"
          description: "P95 latency is {{ $value }}s (threshold: 1s)"

      # Database Connection Pool Exhausted
      - alert: DBConnectionPoolExhausted
        expr: |
          mongodb_connections_current >= mongodb_connections_max * 0.9
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "DB connection pool nearly exhausted"

      # High AI Cost
      - alert: HighAICost
        expr: |
          rate(ai_request_cost_dollars[1h]) > 100
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High AI costs detected"
          description: "AI cost is ${{ $value }}/hour"

      # WebSocket Connections Limit
      - alert: HighWebSocketConnections
        expr: |
          websocket_connections > 8000
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High WebSocket connection count"

  - name: infrastructure_alerts
    interval: 30s
    rules:
      # High CPU
      - alert: HighCPUUsage
        expr: |
          avg by (instance) (rate(container_cpu_usage_seconds_total[5m])) > 0.8
        for: 10m
        labels:
          severity: warning

      # High Memory
      - alert: HighMemoryUsage
        expr: |
          container_memory_usage_bytes / container_spec_memory_limit_bytes > 0.9
        for: 5m
        labels:
          severity: critical

      # Disk Space Low
      - alert: DiskSpaceLow
        expr: |
          (node_filesystem_avail_bytes / node_filesystem_size_bytes) < 0.1
        for: 5m
        labels:
          severity: critical
```

### Logging (Loki + Grafana)

```typescript
// Structured Logging

import pino from 'pino'

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  transport: {
    target: 'pino-loki',
    options: {
      host: 'http://loki:3100',
      labels: {
        app: 'dentalcockpit',
        environment: process.env.NODE_ENV
      }
    }
  }
})

// Log with context
logger.info({
  userId: '123',
  tenantId: 'abc',
  action: 'patient_updated',
  patientId: '456',
  duration: 150
}, 'Patient record updated')

// Error logging
try {
  await updatePatient(id, data)
} catch (error) {
  logger.error({
    err: error,
    userId: req.user.id,
    patientId: id
  }, 'Failed to update patient')
}

// Performance logging
const start = Date.now()
const result = await expensiveOperation()
logger.info({
  operation: 'expensive_operation',
  duration: Date.now() - start
}, 'Operation completed')
```

---

## 🚀 Déploiement & Infrastructure

### Kubernetes Configuration

```yaml
# kubernetes/deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-service
  namespace: dentalcockpit
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api-service
  template:
    metadata:
      labels:
        app: api-service
    spec:
      containers:
      - name: api
        image: dentalcockpit/api:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        - name: MONGODB_URI
          valueFrom:
            secretKeyRef:
              name: db-secrets
              key: mongodb-uri
        - name: REDIS_URI
          valueFrom:
            secretKeyRef:
              name: cache-secrets
              key: redis-uri
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5

---

apiVersion: v1
kind: Service
metadata:
  name: api-service
  namespace: dentalcockpit
spec:
  selector:
    app: api-service
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
  type: ClusterIP

---

apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-service-hpa
  namespace: dentalcockpit
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-service
  minReplicas: 3
  maxReplicas: 50
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/deploy.yml

name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test

      - name: Run E2E tests
        run: npm run test:e2e

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Build Docker image
        run: docker build -t dentalcockpit/api:${{ github.sha }} .

      - name: Push to ECR
        run: |
          aws ecr get-login-password | docker login --username AWS --password-stdin ${{ secrets.ECR_REGISTRY }}
          docker tag dentalcockpit/api:${{ github.sha }} ${{ secrets.ECR_REGISTRY }}/api:${{ github.sha }}
          docker push ${{ secrets.ECR_REGISTRY }}/api:${{ github.sha }}

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to EKS
        run: |
          aws eks update-kubeconfig --name dentalcockpit-prod
          kubectl set image deployment/api-service api=${{ secrets.ECR_REGISTRY }}/api:${{ github.sha }}
          kubectl rollout status deployment/api-service

      - name: Verify deployment
        run: |
          kubectl get pods -l app=api-service
          kubectl logs -l app=api-service --tail=100
```

### Infrastructure as Code (Terraform)

```hcl
# terraform/main.tf

# EKS Cluster
resource "aws_eks_cluster" "dentalcockpit" {
  name     = "dentalcockpit-prod"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.28"

  vpc_config {
    subnet_ids              = aws_subnet.private[*].id
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

# Node Group
resource "aws_eks_node_group" "dentalcockpit" {
  cluster_name    = aws_eks_cluster.dentalcockpit.name
  node_group_name = "dentalcockpit-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = aws_subnet.private[*].id

  scaling_config {
    desired_size = 3
    max_size     = 50
    min_size     = 3
  }

  instance_types = ["t3.large"]
}

# MongoDB Atlas
resource "mongodbatlas_cluster" "dentalcockpit" {
  project_id = var.mongodb_project_id
  name       = "dentalcockpit-prod"

  provider_name               = "AWS"
  provider_region_name        = "EU_WEST_1"
  provider_instance_size_name = "M30"

  cluster_type = "SHARDED"
  num_shards   = 3

  replication_specs {
    num_shards = 3
    regions_config {
      region_name     = "EU_WEST_1"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }

  backup_enabled = true
  auto_scaling_disk_gb_enabled = true
}

# Redis Cluster (ElastiCache)
resource "aws_elasticache_replication_group" "dentalcockpit" {
  replication_group_id       = "dentalcockpit-redis"
  replication_group_description = "Redis cluster for DentalCockpit"
  engine                     = "redis"
  engine_version             = "7.0"
  node_type                  = "cache.r6g.xlarge"
  number_cache_clusters      = 6
  automatic_failover_enabled = true
  multi_az_enabled           = true

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = var.redis_auth_token
}

# S3 Bucket (Images)
resource "aws_s3_bucket" "medical_images" {
  bucket = "dentalcockpit-medical-images"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3.arn
      }
    }
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 365
      storage_class = "GLACIER"
    }
  }
}
```

---

## 📅 Plan de Développement

### Phase 1: MVP (3 mois)

```
Mois 1: Infrastructure & Core Services
├─ Semaine 1-2: Setup infrastructure (K8s, MongoDB, Redis)
├─ Semaine 3-4: Auth service + Patient service
└─ Deliverables:
    ├─ Infrastructure as Code (Terraform)
    ├─ CI/CD pipeline
    ├─ Auth system (JWT, RBAC)
    └─ Patient CRUD API

Mois 2: Frontend & Core Features
├─ Semaine 1-2: Next.js setup + UI components
├─ Semaine 3-4: Dental chart + Patient management
└─ Deliverables:
    ├─ Landing page (4 langues)
    ├─ Dashboard layout
    ├─ Dental charting interface
    └─ Patient list + details

Mois 3: AI Integration
├─ Semaine 1-2: RCE engine + Whisper transcription
├─ Semaine 3-4: GPT-4 anamnesis + Testing
└─ Deliverables:
    ├─ Voice recording + transcription
    ├─ AI anamnesis generation
    ├─ RCE orchestration layer
    └─ MVP ready for beta testing
```

### Phase 2: Advanced Features (3 mois)

```
Mois 4: Imaging & AI Analysis
├─ Image upload (X-ray, 3D scans)
├─ DICOM support
├─ Gemini vision analysis
└─ Annotations & measurements

Mois 5: Prescriptions & Billing
├─ Prescription creation
├─ Recip-e integration (Belgian e-Health)
├─ INAMI integration
└─ Stripe payments

Mois 6: Analytics & Reports
├─ Dashboard KPIs
├─ AI predictions (revenue, no-shows)
├─ Custom reports
└─ Data export (GDPR)
```

### Phase 3: Scale & Optimize (3 mois)

```
Mois 7: Performance & Scalability
├─ Load testing (10K+ concurrent users)
├─ Database sharding
├─ CDN optimization
└─ Caching strategy refinement

Mois 8: Security & Compliance
├─ Penetration testing
├─ GDPR audit
├─ INAMI certification
└─ SOC 2 compliance

Mois 9: Polish & Launch
├─ Mobile apps (React Native)
├─ Advanced AI features
├─ Multi-tenant management
└─ Production launch 🚀
```

---

## 🎯 Technologies Stack Summary

```
Frontend:
├─ Next.js 14+ (React 18+, TypeScript 5+)
├─ Zustand + TanStack Query + RxJS
├─ Tailwind CSS + Radix UI + Framer Motion
├─ Socket.io + SSE + WebRTC
└─ D3.js + Three.js

Backend:
├─ Node.js 20+ / Bun 1.0+
├─ Fastify + tRPC + GraphQL
├─ MongoDB 7+ (sharded) + Redis 7+ (cluster)
├─ Pinecone/Weaviate (vectors)
├─ Kafka + BullMQ
└─ PostgreSQL 16+ (audit)

AI:
├─ RCE Engine (custom orchestrator)
├─ OpenAI (GPT-4, Whisper)
├─ Anthropic (Claude 3.5 Sonnet)
├─ Google (Gemini Pro 1.5)
└─ LangChain + FAISS

Infrastructure:
├─ AWS EKS (Kubernetes 1.28+)
├─ CloudFront + S3
├─ Istio (service mesh)
├─ Terraform (IaC)
└─ GitHub Actions (CI/CD)

Monitoring:
├─ Datadog / New Relic (APM)
├─ Prometheus + Grafana
├─ Loki (logs)
├─ Jaeger (tracing)
└─ Sentry (errors)
```

---

**Auteur:** Ismail Sialyen
**Powered by:** RCE (Relational Cognitive Engine)
**Version:** 2.0
**Date:** 12/11/2025
