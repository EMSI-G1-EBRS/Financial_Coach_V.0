# 🏗️ WealthPath - Architecture Microservices

## 📋 Vue d'ensemble

Application de coaching financier vocal avec architecture microservices, authentification sécurisée et agent LLM.

```
┌─────────────────────────────────────────────────────────────────┐
│                      FLUTTER MOBILE APP                          │
│  (Login, Register, Chat Vocal, Dashboard, Profile)              │
└────────────────────────┬────────────────────────────────────────┘
                         │ HTTPS/REST + JWT
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    API GATEWAY (Spring Cloud)                    │
│  - Routing                                                       │
│  - JWT Validation                                                │
│  - Rate Limiting                                                 │
│  - Load Balancing                                                │
└──────┬──────────┬──────────┬──────────┬──────────────────────────┘
       │          │          │          │
       ▼          ▼          ▼          ▼
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────────────────┐
│   AUTH   │ │   USER   │ │FINANCIAL │ │  NOTIFICATION  │
│ SERVICE  │ │ SERVICE  │ │  AGENT   │ │    SERVICE     │
│  (Java)  │ │  (Java)  │ │ (Python) │ │     (Java)     │
└────┬─────┘ └────┬─────┘ └────┬─────┘ └────────┬───────┘
     │            │            │                 │
     ▼            ▼            ▼                 ▼
┌──────────┐ ┌──────────┐ ┌──────────┐    ┌──────────┐
│PostgreSQL│ │PostgreSQL│ │  Redis   │    │  Redis   │
│  (Auth)  │ │  (User)  │ │ (Memory) │    │ (Queue)  │
└──────────┘ └──────────┘ └──────────┘    └──────────┘
```

## 🎯 Services Détaillés

### 1. **Auth Service (Spring Boot)** 🔐
**Port:** 8081  
**Base de données:** PostgreSQL

**Responsabilités:**
- Inscription (register) avec validation email
- Connexion (login) avec JWT
- Refresh token
- Logout
- Réinitialisation mot de passe
- Gestion des rôles (USER, ADMIN, COACH)

**Endpoints:**
```
POST   /api/auth/register          - Créer un compte
POST   /api/auth/login             - Se connecter
POST   /api/auth/refresh           - Rafraîchir le token
POST   /api/auth/logout            - Se déconnecter
POST   /api/auth/forgot-password   - Demander reset password
POST   /api/auth/reset-password    - Réinitialiser password
GET    /api/auth/verify-email      - Vérifier email
```

**Modèles:**
```java
- User (id, email, password, roles, enabled, created_at)
- Role (id, name: ROLE_USER, ROLE_ADMIN)
- RefreshToken (id, token, user_id, expiry_date)
- PasswordResetToken (id, token, user_id, expiry_date)
```

---

### 2. **User Service (Spring Boot)** 👤
**Port:** 8082  
**Base de données:** PostgreSQL

**Responsabilités:**
- Gestion du profil utilisateur
- Informations financières (revenus, dépenses)
- Objectifs financiers
- Préférences utilisateur
- Historique des conversations (metadata)

**Endpoints:**
```
GET    /api/users/me               - Profil actuel
PUT    /api/users/me               - Mettre à jour profil
GET    /api/users/{id}             - Profil par ID (admin)
POST   /api/users/me/financial     - Ajouter infos financières
GET    /api/users/me/goals         - Objectifs financiers
POST   /api/users/me/goals         - Créer un objectif
PUT    /api/users/me/goals/{id}    - Modifier un objectif
DELETE /api/users/me/goals/{id}    - Supprimer un objectif
GET    /api/users/me/conversations - Liste des conversations
```

**Modèles:**
```java
- UserProfile (user_id, first_name, last_name, phone, avatar_url)
- FinancialInfo (user_id, monthly_income, monthly_expenses, savings)
- Goal (id, user_id, title, target_amount, current_amount, deadline)
- ConversationMetadata (id, user_id, thread_id, title, created_at)
```

---

### 3. **Financial Agent Service (Python/Flask)** 🤖
**Port:** 5000  
**Stockage:** Redis (mémoire conversationnelle)

**Responsabilités:**
- Chat avec l'agent LLM (existant)
- Gestion de la mémoire conversationnelle
- Analyse financière personnalisée
- Conseils basés sur le profil utilisateur

**Endpoints:**
```
POST   /api/agent/chat             - Envoyer un message
GET    /api/agent/history/{thread} - Historique conversation
DELETE /api/agent/history/{thread} - Supprimer historique
POST   /api/agent/analyze          - Analyse financière
```

**Sécurité:**
- Validation JWT via API Gateway
- Récupération du user_id depuis le JWT

---

### 4. **Notification Service (Spring Boot)** 📬
**Port:** 8084  
**Stockage:** Redis (queue)

**Responsabilités:**
- Notifications push (Firebase Cloud Messaging)
- Notifications email
- Rappels pour objectifs
- Alertes budgétaires

**Endpoints:**
```
POST   /api/notifications/send     - Envoyer notification
GET    /api/notifications/me       - Mes notifications
PUT    /api/notifications/{id}/read - Marquer comme lu
```

---

### 5. **API Gateway (Spring Cloud Gateway)** 🌐
**Port:** 8080

**Responsabilités:**
- Point d'entrée unique
- Validation JWT centralisée
- Routage vers les microservices
- Rate limiting
- CORS
- Logging centralisé

**Configuration de routage:**
```yaml
routes:
  - id: auth-service
    uri: lb://AUTH-SERVICE
    predicates:
      - Path=/api/auth/**
    filters:
      - StripPrefix=0
      
  - id: user-service
    uri: lb://USER-SERVICE
    predicates:
      - Path=/api/users/**
    filters:
      - JwtAuthenticationFilter
      
  - id: agent-service
    uri: lb://FINANCIAL-AGENT-SERVICE
    predicates:
      - Path=/api/agent/**
    filters:
      - JwtAuthenticationFilter
      
  - id: notification-service
    uri: lb://NOTIFICATION-SERVICE
    predicates:
      - Path=/api/notifications/**
    filters:
      - JwtAuthenticationFilter
```

---

## 🔒 Sécurité

### JWT Token Structure
```json
{
  "sub": "user@example.com",
  "userId": "123e4567-e89b-12d3-a456-426614174000",
  "roles": ["ROLE_USER"],
  "iat": 1699000000,
  "exp": 1699003600
}
```

### Flux d'authentification
```
1. User → Login → Auth Service
2. Auth Service → Generate JWT + Refresh Token
3. Flutter App → Store tokens securely
4. Request → API Gateway → Validate JWT
5. API Gateway → Forward request with userId header
6. Microservice → Process request with authenticated user
```

---

## 📱 Frontend Flutter

### Structure des dossiers
```
lib/
├── main.dart
├── core/
│   ├── config/
│   │   └── api_config.dart
│   ├── constants/
│   │   └── app_constants.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── jwt_interceptor.dart
│   │   └── refresh_token_interceptor.dart
│   └── storage/
│       └── secure_storage.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── services/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   └── forgot_password_page.dart
│   │       ├── widgets/
│   │       └── providers/
│   ├── chat/
│   │   └── ... (existant)
│   ├── profile/
│   │   └── ...
│   └── goals/
│       └── ...
└── shared/
    ├── widgets/
    └── utils/
```

---

## 🗄️ Base de données

### Auth Service Database (PostgreSQL)
```sql
-- users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    enabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- roles table
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- user_roles table
CREATE TABLE user_roles (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role_id INT REFERENCES roles(id),
    PRIMARY KEY (user_id, role_id)
);

-- refresh_tokens table
CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token VARCHAR(500) UNIQUE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    expiry_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- password_reset_tokens table
CREATE TABLE password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token VARCHAR(500) UNIQUE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    expiry_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### User Service Database (PostgreSQL)
```sql
-- user_profiles table
CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    avatar_url TEXT,
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- financial_info table
CREATE TABLE financial_info (
    user_id UUID PRIMARY KEY,
    monthly_income DECIMAL(12, 2),
    monthly_expenses DECIMAL(12, 2),
    current_savings DECIMAL(12, 2),
    currency VARCHAR(3) DEFAULT 'EUR',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- goals table
CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    target_amount DECIMAL(12, 2) NOT NULL,
    current_amount DECIMAL(12, 2) DEFAULT 0,
    deadline DATE,
    status VARCHAR(20) DEFAULT 'IN_PROGRESS',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- conversation_metadata table
CREATE TABLE conversation_metadata (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    thread_id VARCHAR(255) NOT NULL,
    title VARCHAR(255),
    last_message_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🚀 Déploiement

### Docker Compose (Développement)
```yaml
version: '3.8'

services:
  postgres-auth:
    image: postgres:15
    environment:
      POSTGRES_DB: auth_db
      POSTGRES_USER: auth_user
      POSTGRES_PASSWORD: auth_pass
    ports:
      - "5432:5432"
      
  postgres-user:
    image: postgres:15
    environment:
      POSTGRES_DB: user_db
      POSTGRES_USER: user_user
      POSTGRES_PASSWORD: user_pass
    ports:
      - "5433:5432"
      
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
      
  api-gateway:
    build: ./api-gateway
    ports:
      - "8080:8080"
    environment:
      - EUREKA_CLIENT_ENABLED=false
      
  auth-service:
    build: ./auth-service
    ports:
      - "8081:8081"
    depends_on:
      - postgres-auth
      
  user-service:
    build: ./user-service
    ports:
      - "8082:8082"
    depends_on:
      - postgres-user
      
  financial-agent:
    build: ./financial-agent
    ports:
      - "5000:5000"
    depends_on:
      - redis
```

---

## 📦 Technologies

### Backend
- **Java:** Spring Boot 3.2, Spring Security, Spring Data JPA
- **Python:** Flask, LangChain, LangGraph
- **Database:** PostgreSQL 15
- **Cache/Memory:** Redis 7
- **API Gateway:** Spring Cloud Gateway
- **Auth:** JWT (jjwt library)

### Frontend
- **Framework:** Flutter 3.x
- **State Management:** Provider / Riverpod
- **HTTP:** Dio
- **Secure Storage:** flutter_secure_storage
- **Voice:** speech_to_text, flutter_tts

---

## 🔄 Communication entre services

### Synchrone (REST)
- User Service → Auth Service (validate token)
- Financial Agent → User Service (get user profile)

### Asynchrone (Events - Future)
- Auth Service → Notification Service (send welcome email)
- Goal Service → Notification Service (goal deadline reminder)

---

## 📊 Monitoring & Observabilité (Future)

- **Logs:** ELK Stack (Elasticsearch, Logstash, Kibana)
- **Metrics:** Prometheus + Grafana
- **Tracing:** Zipkin / Jaeger
- **Health Checks:** Spring Actuator

---

## 🎯 Roadmap d'implémentation

### Phase 1: Foundation (Semaine 1-2)
- [x] Auth Service avec JWT
- [x] User Service basique
- [x] API Gateway avec routing
- [x] Base de données PostgreSQL

### Phase 2: Integration (Semaine 3)
- [ ] Intégration Financial Agent avec JWT
- [ ] Flutter: Écrans Auth (Login/Register)
- [ ] Secure Storage des tokens
- [ ] HTTP interceptors

### Phase 3: Features (Semaine 4-5)
- [ ] User Profile complet
- [ ] Goals Management
- [ ] Notification Service
- [ ] Dashboard Flutter

### Phase 4: Polish (Semaine 6)
- [ ] Tests unitaires & intégration
- [ ] Documentation API (Swagger)
- [ ] Docker Compose setup
- [ ] CI/CD pipeline