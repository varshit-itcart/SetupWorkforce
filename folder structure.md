# Backend Folder Structure - Node.js + TypeScript + Next.js API

```
backend/
├── src/
│   ├── index.ts                          # Application entry point
│   ├── server.ts                         # Express server setup
│   │
│   ├── config/                           # Configuration files
│   │   ├── database.ts                   # PostgreSQL connection config
│   │   ├── jwt.ts                        # JWT configuration
│   │   ├── websocket.ts                  # Socket.io configuration
│   │   ├── storage.ts                    # File storage configuration (S3/local)
│   │   ├── cors.ts                       # CORS settings
│   │   └── env.ts                        # Environment variables validation
│   │
│   ├── middleware/                       # Express middleware
│   │   ├── auth.middleware.ts            # JWT authentication
│   │   ├── rbac.middleware.ts            # Role-based access control
│   │   ├── validation.middleware.ts      # Request validation
│   │   ├── error.middleware.ts           # Global error handler
│   │   ├── audit.middleware.ts           # Audit logging
│   │   ├── rate-limit.middleware.ts      # Rate limiting
│   │   ├── upload.middleware.ts          # File upload handler
│   │   └── pagination.middleware.ts      # Pagination helper
│   │
│   ├── controllers/                      # Route controllers
│   │   ├── auth.controller.ts            # Authentication endpoints
│   │   ├── user.controller.ts            # User management
│   │   ├── employee.controller.ts        # Employee operations
│   │   ├── case.controller.ts            # Case management
│   │   ├── decision.controller.ts        # Decision operations
│   │   ├── policy.controller.ts          # Policy management
│   │   ├── analytics.controller.ts       # Analytics endpoints
│   │   ├── governance.controller.ts      # Governance operations
│   │   ├── notification.controller.ts    # Notifications
│   │   ├── task.controller.ts            # Task management
│   │   ├── onboarding.controller.ts      # Onboarding workflows
│   │   ├── integration.controller.ts     # Integration management
│   │   ├── settings.controller.ts        # Settings operations
│   │   ├── activity.controller.ts        # Activity feed
│   │   └── file.controller.ts            # File operations
│   │
│   ├── routes/                           # API routes
│   │   ├── index.ts                      # Route aggregator
│   │   ├── auth.routes.ts
│   │   ├── user.routes.ts
│   │   ├── employee.routes.ts
│   │   ├── case.routes.ts
│   │   ├── decision.routes.ts
│   │   ├── policy.routes.ts
│   │   ├── analytics.routes.ts
│   │   ├── governance.routes.ts
│   │   ├── notification.routes.ts
│   │   ├── task.routes.ts
│   │   ├── onboarding.routes.ts
│   │   ├── integration.routes.ts
│   │   ├── settings.routes.ts
│   │   ├── activity.routes.ts
│   │   └── file.routes.ts
│   │
│   ├── services/                         # Business logic layer
│   │   ├── auth.service.ts               # Authentication logic
│   │   ├── user.service.ts               # User operations
│   │   ├── employee.service.ts           # Employee business logic
│   │   ├── case.service.ts               # Case operations
│   │   ├── decision.service.ts           # Decision logic
│   │   ├── policy.service.ts             # Policy operations
│   │   ├── analytics.service.ts          # Analytics calculations
│   │   ├── governance.service.ts         # Governance logic
│   │   ├── notification.service.ts       # Notification handling
│   │   ├── task.service.ts               # Task operations
│   │   ├── onboarding.service.ts         # Onboarding logic
│   │   ├── integration.service.ts        # Integration handlers
│   │   ├── settings.service.ts           # Settings management
│   │   ├── activity.service.ts           # Activity tracking
│   │   ├── file.service.ts               # File storage operations
│   │   ├── email.service.ts              # Email notifications
│   │   ├── sla.service.ts                # SLA monitoring
│   │   └── audit.service.ts              # Audit logging
│   │
│   ├── models/                           # Database models (TypeORM/Prisma)
│   │   ├── index.ts                      # Model exports
│   │   ├── User.model.ts
│   │   ├── RefreshToken.model.ts
│   │   ├── Employee.model.ts
│   │   ├── Case.model.ts
│   │   ├── CaseTimeline.model.ts
│   │   ├── CaseFile.model.ts
│   │   ├── CaseInvestigationTask.model.ts
│   │   ├── Decision.model.ts
│   │   ├── Policy.model.ts
│   │   ├── PolicyVersion.model.ts
│   │   ├── PolicyCitation.model.ts
│   │   ├── Notification.model.ts
│   │   ├── Activity.model.ts
│   │   ├── Task.model.ts
│   │   ├── AnalyticsMetric.model.ts
│   │   ├── AuditLog.model.ts
│   │   ├── GovernanceAuthorityMatrix.model.ts
│   │   ├── Integration.model.ts
│   │   ├── OnboardingWorkflow.model.ts
│   │   ├── OnboardingTask.model.ts
│   │   ├── Setting.model.ts
│   │   └── AIPersonaConfig.model.ts
│   │
│   ├── repositories/                     # Data access layer (optional)
│   │   ├── user.repository.ts
│   │   ├── employee.repository.ts
│   │   ├── case.repository.ts
│   │   ├── decision.repository.ts
│   │   ├── policy.repository.ts
│   │   └── ... (other repositories)
│   │
│   ├── validators/                       # Request validation schemas
│   │   ├── auth.validator.ts             # Zod/Joi schemas for auth
│   │   ├── user.validator.ts
│   │   ├── employee.validator.ts
│   │   ├── case.validator.ts
│   │   ├── decision.validator.ts
│   │   ├── policy.validator.ts
│   │   └── ... (other validators)
│   │
│   ├── types/                            # TypeScript type definitions
│   │   ├── index.ts                      # Type exports
│   │   ├── express.d.ts                  # Express extensions
│   │   ├── user.types.ts
│   │   ├── employee.types.ts
│   │   ├── case.types.ts
│   │   ├── decision.types.ts
│   │   ├── policy.types.ts
│   │   ├── notification.types.ts
│   │   ├── api.types.ts                  # API request/response types
│   │   └── common.types.ts               # Shared types
│   │
│   ├── utils/                            # Utility functions
│   │   ├── logger.ts                     # Winston/Pino logger
│   │   ├── hash.ts                       # Password hashing (bcrypt)
│   │   ├── jwt.ts                        # JWT utilities
│   │   ├── encryption.ts                 # Data encryption
│   │   ├── validators.ts                 # Common validators
│   │   ├── formatters.ts                 # Data formatters
│   │   ├── pagination.ts                 # Pagination helpers
│   │   ├── date.ts                       # Date utilities
│   │   ├── file.ts                       # File utilities
│   │   ├── constants.ts                  # App constants
│   │   └── errors.ts                     # Custom error classes
│   │
│   ├── websocket/                        # WebSocket handlers
│   │   ├── index.ts                      # Socket.io setup
│   │   ├── auth.handler.ts               # WebSocket authentication
│   │   ├── notification.handler.ts       # Notification events
│   │   ├── case.handler.ts               # Case real-time updates
│   │   ├── decision.handler.ts           # Decision events
│   │   └── metrics.handler.ts            # Real-time metrics
│   │
│   ├── jobs/                             # Background jobs (Bull/Agenda)
│   │   ├── index.ts                      # Job queue setup
│   │   ├── sla-monitor.job.ts            # SLA monitoring
│   │   ├── notification.job.ts           # Notification queue
│   │   ├── analytics.job.ts              # Analytics calculations
│   │   ├── email.job.ts                  # Email queue
│   │   └── cleanup.job.ts                # Data cleanup
│   │
│   ├── database/                         # Database related
│   │   ├── migrations/                   # Database migrations
│   │   │   ├── 001_create_users.sql
│   │   │   ├── 002_create_employees.sql
│   │   │   ├── 003_create_cases.sql
│   │   │   └── ... (other migrations)
│   │   ├── seeds/                        # Seed data
│   │   │   ├── users.seed.ts
│   │   │   ├── settings.seed.ts
│   │   │   └── policies.seed.ts
│   │   └── connection.ts                 # Database connection
│   │
│   └── tests/                            # Test files
│       ├── unit/                         # Unit tests
│       │   ├── services/
│       │   ├── utils/
│       │   └── validators/
│       ├── integration/                  # Integration tests
│       │   ├── auth.test.ts
│       │   ├── cases.test.ts
│       │   └── ... (other tests)
│       ├── e2e/                          # End-to-end tests
│       │   └── api.test.ts
│       └── fixtures/                     # Test fixtures
│           └── mockData.ts
│
├── uploads/                              # Local file storage (dev)
│   ├── cases/
│   ├── profiles/
│   └── temp/
│
├── logs/                                 # Application logs
│   ├── error.log
│   ├── combined.log
│   └── access.log
│
├── .env                                  # Environment variables
├── .env.example                          # Environment template
├── .gitignore
├── package.json
├── tsconfig.json                         # TypeScript configuration
├── nodemon.json                          # Nodemon configuration
├── jest.config.js                        # Jest test configuration
├── docker-compose.yml                    # Docker setup
├── Dockerfile
└── README.md
```

## Key Technology Stack

### Core
- **Runtime**: Node.js 18+
- **Language**: TypeScript
- **Framework**: Express.js
- **Database**: PostgreSQL 15+
- **ORM**: Prisma or TypeORM

### Authentication & Security
- **JWT**: jsonwebtoken
- **Password Hashing**: bcrypt
- **Encryption**: crypto-js or node-crypto
- **CORS**: cors
- **Helmet**: helmet (security headers)
- **Rate Limiting**: express-rate-limit

### Real-time & Background
- **WebSocket**: Socket.io
- **Job Queue**: Bull or Agenda
- **Redis**: ioredis (for Bull queue)

### File Storage
- **Local**: multer
- **Cloud**: aws-sdk (S3) or @google-cloud/storage

### Validation & Utilities
- **Validation**: Zod or Joi
- **Date**: date-fns or dayjs
- **Logger**: Winston or Pino
- **Environment**: dotenv
- **UUID**: uuid

### Testing
- **Framework**: Jest
- **API Testing**: Supertest
- **Mocking**: jest-mock

### Development
- **Hot Reload**: nodemon
- **Linting**: ESLint
- **Formatting**: Prettier
- **Git Hooks**: husky

## Environment Variables (.env)

```env
# Server
NODE_ENV=development
PORT=8000
API_VERSION=v1

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/aixworkforce360
DB_HOST=localhost
DB_PORT=5432
DB_NAME=aixworkforce360
DB_USER=postgres
DB_PASSWORD=password

# JWT
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=1h
REFRESH_TOKEN_SECRET=your-refresh-token-secret
REFRESH_TOKEN_EXPIRES_IN=7d

# SSO (Optional)
SSO_INTERNAL_ENABLED=true
SSO_GOOGLE_CLIENT_ID=
SSO_GOOGLE_CLIENT_SECRET=
SSO_AZURE_CLIENT_ID=
SSO_AZURE_TENANT_ID=

# Redis (for job queue)
REDIS_URL=redis://localhost:6379
REDIS_HOST=localhost
REDIS_PORT=6379

# File Storage
STORAGE_TYPE=local # local | s3 | gcs
UPLOAD_MAX_SIZE=10485760 # 10MB
UPLOAD_DIR=./uploads

# AWS S3 (if using S3)
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=us-east-1
AWS_S3_BUCKET=aixworkforce360-files

# Email
EMAIL_ENABLED=true
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=
SMTP_PASSWORD=
EMAIL_FROM=noreply@aixworkforce360.com

# WebSocket
WS_ENABLED=true
WS_CORS_ORIGIN=http://localhost:3000

# Monitoring & Logging
LOG_LEVEL=info # error | warn | info | debug
SENTRY_DSN= # Optional error tracking

# CORS
CORS_ORIGIN=http://localhost:3000,https://yourdomain.com

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000 # 15 minutes
RATE_LIMIT_MAX_REQUESTS=100

# Application
APP_NAME=AiXWorkForce360
APP_URL=http://localhost:3000
FRONTEND_URL=http://localhost:3000
```

## Package.json Scripts

```json
{
  \"scripts\": {
    \"dev\": \"nodemon\",
    \"build\": \"tsc\",
    \"start\": \"node dist/index.js\",
    \"start:prod\": \"NODE_ENV=production node dist/index.js\",
    \"migrate\": \"prisma migrate deploy\",
    \"migrate:dev\": \"prisma migrate dev\",
    \"seed\": \"ts-node src/database/seeds/index.ts\",
    \"test\": \"jest\",
    \"test:watch\": \"jest --watch\",
    \"test:coverage\": \"jest --coverage\",
    \"lint\": \"eslint src --ext .ts\",
    \"lint:fix\": \"eslint src --ext .ts --fix\",
    \"format\": \"prettier --write 'src/**/*.ts'\",
    \"typecheck\": \"tsc --noEmit\",
    \"prepare\": \"husky install\"
  }
}
```

## API Route Structure (src/routes/index.ts)

```typescript
import { Router } from 'express';
import authRoutes from './auth.routes';
import userRoutes from './user.routes';
import employeeRoutes from './employee.routes';
import caseRoutes from './case.routes';
import decisionRoutes from './decision.routes';
import policyRoutes from './policy.routes';
import analyticsRoutes from './analytics.routes';
import governanceRoutes from './governance.routes';
import notificationRoutes from './notification.routes';
import taskRoutes from './task.routes';
import onboardingRoutes from './onboarding.routes';
import integrationRoutes from './integration.routes';
import settingsRoutes from './settings.routes';
import activityRoutes from './activity.routes';
import fileRoutes from './file.routes';

const router = Router();

// Mount routes
router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/employees', employeeRoutes);
router.use('/cases', caseRoutes);
router.use('/decisions', decisionRoutes);
router.use('/policies', policyRoutes);
router.use('/analytics', analyticsRoutes);
router.use('/governance', governanceRoutes);
router.use('/notifications', notificationRoutes);
router.use('/tasks', taskRoutes);
router.use('/onboarding', onboardingRoutes);
router.use('/integrations', integrationRoutes);
router.use('/settings', settingsRoutes);
router.use('/activities', activityRoutes);
router.use('/files', fileRoutes);

export default router;
```

## Database ORM Options

### Option 1: Prisma (Recommended)
```prisma
// schema.prisma
generator client {
  provider = \"prisma-client-js\"
}

datasource db {
  provider = \"postgresql\"
  url      = env(\"DATABASE_URL\")
}

model User {
  id            String    @id @default(uuid())
  email         String    @unique
  passwordHash  String?
  firstName     String
  lastName      String
  role          String
  // ... other fields
  
  @@index([email])
  @@index([role])
}
```

### Option 2: TypeORM
```typescript
// User.model.ts
import { Entity, PrimaryGeneratedColumn, Column, Index, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  @Index()
  email: string;

  @Column({ nullable: true })
  passwordHash: string;

  @Column()
  firstName: string;

  @Column()
  lastName: string;

  @Column()
  @Index()
  role: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

## Deployment Structure

```
production/
├── docker-compose.prod.yml
├── nginx.conf                    # Reverse proxy
├── pm2.config.js                 # PM2 process manager
└── kubernetes/                   # K8s deployment (optional)
    ├── deployment.yaml
    ├── service.yaml
    └── ingress.yaml
```

This structure provides a scalable, maintainable, and production-ready backend architecture for the AiXWorkForce360 application.