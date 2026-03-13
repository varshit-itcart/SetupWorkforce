# AiXWorkForce360 Backend Specification - Complete Summary

## Project Overview

**Application**: AiXWorkForce360 - Workforce Decision OS  
**Type**: Enterprise HR Case Management & Decision Governance Platform  
**Tech Stack**: Node.js + TypeScript + Express + PostgreSQL + Next.js API Routes  
**Authentication**: JWT with SSO support (Internal/Google/Azure)

---

## 📊 Complete Data Models (22 Tables)

### Core Entities
1. **users** - User accounts and authentication
2. **refresh_tokens** - JWT refresh token management
3. **employees** - Employee directory and profiles
4. **cases** - HR case management
5. **case_timeline** - Case event history
6. **case_files** - Case document attachments
7. **case_investigation_tasks** - Investigation checklists
8. **decisions** - AI-assisted decisions
9. **policies** - Policy library
10. **policy_versions** - Policy version control
11. **policy_citations** - Policy usage tracking
12. **notifications** - User notifications
13. **activities** - Activity feed/stream
14. **tasks** - Task management
15. **analytics_metrics** - Pre-computed analytics
16. **audit_logs** - Complete audit trail
17. **governance_authority_matrix** - RBAC rules
18. **integrations** - External system integrations
19. **onboarding_workflows** - Employee onboarding
20. **onboarding_tasks** - Onboarding checklists
21. **settings** - Application configuration
22. **ai_persona_configs** - AI persona management

---

## 🔗 API Endpoints (87 Endpoints)

### Authentication (7 endpoints)
- POST `/auth/register` - User registration
- POST `/auth/login` - Email/password login
- POST `/auth/sso/login` - SSO authentication
- POST `/auth/refresh` - Refresh access token
- POST `/auth/logout` - Logout
- POST `/auth/forgot-password` - Password reset request
- POST `/auth/reset-password` - Reset password

### Users (9 endpoints)
- GET `/users` - List users
- GET `/users/:id` - Get user details
- GET `/users/me` - Current user profile
- PUT `/users/:id` - Update user
- PUT `/users/me` - Update own profile
- DELETE `/users/:id` - Delete user
- PUT `/users/:id/activate` - Activate account
- PUT `/users/:id/deactivate` - Deactivate account

### Employees (12 endpoints)
- GET `/employees` - List employees with filters
- GET `/employees/:id` - Employee profile
- POST `/employees` - Create employee
- PUT `/employees/:id` - Update employee
- DELETE `/employees/:id` - Delete employee
- GET `/employees/:id/cases` - Employee cases
- GET `/employees/:id/performance` - Performance metrics
- POST `/employees/:id/change-status` - Change status
- POST `/employees/import` - Bulk CSV import
- GET `/employees/export` - Export to CSV/Excel
- GET `/employees/stats` - Employee statistics

### Cases (17 endpoints)
- GET `/cases` - List cases with filters
- GET `/cases/:id` - Case details
- POST `/cases` - Create case
- PUT `/cases/:id` - Update case
- DELETE `/cases/:id` - Delete case
- POST `/cases/:id/assign` - Assign case
- POST `/cases/:id/status` - Change status
- POST `/cases/:id/escalate` - Escalate case
- POST `/cases/:id/close` - Close case
- GET `/cases/:id/timeline` - Case timeline
- POST `/cases/:id/timeline` - Add timeline event
- GET `/cases/:id/files` - List case files
- POST `/cases/:id/files` - Upload file
- DELETE `/cases/:id/files/:fileId` - Delete file
- GET `/cases/:id/files/:fileId/download` - Download file
- GET `/cases/:id/tasks` - Investigation tasks
- POST `/cases/:id/tasks` - Create task
- PUT `/cases/:id/tasks/:taskId` - Update task
- POST `/cases/:id/tasks/:taskId/complete` - Complete task
- DELETE `/cases/:id/tasks/:taskId` - Delete task
- GET `/cases/stats` - Case statistics

### Decisions (7 endpoints)
- GET `/decisions` - List decisions
- GET `/decisions/:id` - Decision details
- POST `/decisions` - Create decision
- PUT `/decisions/:id` - Update decision
- POST `/decisions/:id/approve` - Approve decision
- POST `/decisions/:id/reject` - Reject decision
- POST `/decisions/:id/override` - Override AI recommendation
- GET `/decisions/:id/audit-hash` - Verify audit hash

### Policies (9 endpoints)
- GET `/policies` - List policies
- GET `/policies/:id` - Policy details
- POST `/policies` - Create policy
- PUT `/policies/:id` - Update policy
- DELETE `/policies/:id` - Delete policy
- GET `/policies/:id/versions` - Version history
- POST `/policies/:id/versions` - Create new version
- GET `/policies/:id/citations` - Usage citations
- POST `/policies/:id/test` - Test policy
- GET `/policies/search` - Search policies

### Analytics (7 endpoints)
- GET `/analytics/dashboard` - Dashboard metrics
- GET `/analytics/cases` - Case analytics
- GET `/analytics/employees` - Employee analytics
- GET `/analytics/decisions` - Decision analytics
- GET `/analytics/sla` - SLA compliance
- GET `/analytics/governance` - Governance metrics
- GET `/analytics/export` - Export report

### Governance (10 endpoints)
- GET `/governance/decisions` - Decision registry
- GET `/governance/audit-logs` - Audit logs
- GET `/governance/authority-matrix` - Authority rules
- POST `/governance/authority-matrix` - Create rule
- PUT `/governance/authority-matrix/:id` - Update rule
- DELETE `/governance/authority-matrix/:id` - Delete rule
- POST `/governance/check-authority` - Check permissions
- GET `/governance/outcome-review` - Review queue
- POST `/governance/outcome-review/:id` - Submit review
- GET `/governance/ai-personas` - AI persona configs
- GET `/governance/ai-personas/:type` - Get persona config
- PUT `/governance/ai-personas/:type` - Update persona config

### Notifications (6 endpoints)
- GET `/notifications` - List notifications
- GET `/notifications/:id` - Get notification
- PUT `/notifications/:id/read` - Mark as read
- PUT `/notifications/mark-all-read` - Mark all read
- DELETE `/notifications/:id` - Delete notification
- GET `/notifications/unread-count` - Unread count
- POST `/notifications/test` - Send test notification

### Tasks (6 endpoints)
- GET `/tasks` - List tasks
- GET `/tasks/my-tasks` - My tasks
- GET `/tasks/:id` - Task details
- POST `/tasks` - Create task
- PUT `/tasks/:id` - Update task
- POST `/tasks/:id/complete` - Complete task
- DELETE `/tasks/:id` - Delete task

### Onboarding (8 endpoints)
- GET `/onboarding` - List workflows
- GET `/onboarding/:id` - Workflow details
- POST `/onboarding` - Create workflow
- PUT `/onboarding/:id` - Update workflow
- DELETE `/onboarding/:id` - Delete workflow
- GET `/onboarding/:id/tasks` - Workflow tasks
- POST `/onboarding/:id/tasks` - Create task
- PUT `/onboarding/:id/tasks/:taskId` - Update task
- POST `/onboarding/:id/tasks/:taskId/complete` - Complete task

### Integrations (7 endpoints)
- GET `/integrations` - List integrations
- GET `/integrations/:id` - Integration details
- POST `/integrations` - Create integration
- PUT `/integrations/:id` - Update integration
- DELETE `/integrations/:id` - Delete integration
- POST `/integrations/:id/test` - Test connection
- POST `/integrations/:id/sync` - Trigger sync
- GET `/integrations/:id/sync-status` - Sync status

### Settings (5 endpoints)
- GET `/settings` - List settings
- GET `/settings/:category/:key` - Get setting
- PUT `/settings/:category/:key` - Update setting
- POST `/settings` - Create setting
- DELETE `/settings/:category/:key` - Delete setting

### Activities (2 endpoints)
- GET `/activities` - Activity feed
- GET `/activities/recent` - Recent activities

### Files (4 endpoints)
- POST `/files/upload` - Upload file
- GET `/files/:id` - File metadata
- GET `/files/:id/download` - Download file
- DELETE `/files/:id` - Delete file

---

## 🔐 Authentication & Security

### JWT Implementation
- **Access Token**: Short-lived (1 hour), used for API requests
- **Refresh Token**: Long-lived (7 days), stored in database
- **Token Rotation**: New refresh token on each refresh
- **Revocation**: Logout revokes refresh tokens

### SSO Support
- Internal SSO (company system)
- Google OAuth
- Azure AD

### Role-Based Access Control (RBAC)
**Roles (hierarchy)**:
1. `admin` (Level 5) - Full system access
2. `hr_director` (Level 4) - HR leadership
3. `hr_manager` (Level 3) - HR operations
4. `manager` (Level 2) - Department managers
5. `employee` (Level 1) - Standard employees
6. `legal` (Special role) - Legal team access

### Security Features
- Password hashing with bcrypt
- JWT secret rotation support
- Request rate limiting
- Helmet.js security headers
- CORS configuration
- Audit logging for all actions
- IP address tracking
- User agent logging

---

## 📁 Project Structure

```
backend/
├── src/
│   ├── index.ts                    # Entry point
│   ├── server.ts                   # Express setup
│   ├── config/                     # Configuration
│   ├── middleware/                 # Express middleware
│   ├── controllers/                # Route controllers (14 files)
│   ├── routes/                     # API routes (14 files)
│   ├── services/                   # Business logic (15 files)
│   ├── models/                     # Database models (22 files)
│   ├── validators/                 # Request validators
│   ├── types/                      # TypeScript types
│   ├── utils/                      # Utilities
│   ├── websocket/                  # WebSocket handlers
│   ├── jobs/                       # Background jobs
│   ├── database/
│   │   ├── migrations/             # SQL migrations
│   │   └── seeds/                  # Seed data
│   └── tests/                      # Test files
├── uploads/                        # File storage
├── logs/                           # Application logs
├── .env                            # Environment variables
├── package.json
├── tsconfig.json
└── docker-compose.yml
```

---

## 🔄 Real-time Features (WebSocket)

### Event Types

**Notifications**
- `notification:new` - New notification
- `notification:read` - Notification read

**Cases**
- `case:assigned` - Case assigned to user
- `case:status-changed` - Case status updated
- `case:sla-warning` - SLA deadline approaching

**Decisions**
- `decision:pending` - Decision needs approval
- `decision:status-changed` - Decision approved/rejected

**Metrics**
- `metrics:update` - Dashboard metrics updated

---

## 📦 File Upload

### Configuration
- **Storage**: Local (dev) or S3/GCS (prod)
- **Max Size**: 10MB per file
- **Types**: Documents, images, PDFs
- **Categories**: evidence, documentation, communication, report

### Endpoints
- Upload files to cases
- Download with authentication
- Automatic metadata extraction
- Virus scanning (optional)

---

## 📊 Analytics & Reporting

### Pre-computed Metrics
- Case volume trends
- SLA compliance rates
- Decision mode distribution
- Risk level distribution
- Employee statistics
- Department metrics

### Report Export
- CSV format
- Excel format
- PDF format (optional)
- Scheduled reports

---

## 🔍 Audit Logging

### What's Logged
- All API requests (non-GET)
- User authentication events
- Data modifications
- Permission checks
- Failed operations
- System errors

### Audit Data
- User ID and email
- Action performed
- Entity type and ID
- IP address
- User agent
- Timestamp
- Request/response details
- Status code

---

## 🚀 Background Jobs

### Job Types
1. **SLA Monitor** - Check case SLA status
2. **Notification Queue** - Send email/push notifications
3. **Analytics Calculator** - Compute metrics
4. **Email Queue** - Send emails
5. **Data Cleanup** - Remove old data

### Technology
- Bull (Redis-based queue)
- Cron scheduling
- Retry logic
- Job monitoring

---

## 🧪 Testing Strategy

### Unit Tests
- Services
- Utils
- Validators

### Integration Tests
- API endpoints
- Database operations
- Authentication flows

### E2E Tests
- Complete user workflows
- Multi-step operations

### Tools
- Jest (test framework)
- Supertest (API testing)
- Mock data fixtures

---

## 🐳 Deployment

### Docker Support
```yaml
# docker-compose.yml
services:
  backend:
    build: .
    ports:
      - \"8000:8000\"
    environment:
      - DATABASE_URL=postgresql://...
      - REDIS_URL=redis://redis:6379
  
  postgres:
    image: postgres:15
    
  redis:
    image: redis:7
```

### Environment Variables (28 required)
See IMPLEMENTATION_GUIDE.md for complete list

---

## 📈 Performance Considerations

### Database
- Proper indexing on all foreign keys
- Composite indexes for common queries
- Connection pooling
- Query optimization

### API
- Pagination on all list endpoints
- Response caching (Redis)
- Query result caching
- Rate limiting per user/IP

### File Storage
- CDN for file serving
- Presigned URLs for S3
- Image optimization
- Lazy loading

---

## 🔧 Development Commands

```bash
# Development
npm run dev              # Start dev server with hot reload

# Database
npm run migrate          # Run migrations
npm run seed            # Seed database

# Building
npm run build           # Compile TypeScript
npm run start           # Start production server

# Testing
npm run test            # Run all tests
npm run test:watch      # Watch mode
npm run test:coverage   # Coverage report

# Code Quality
npm run lint            # Run ESLint
npm run lint:fix        # Fix lint issues
npm run format          # Format with Prettier
npm run typecheck       # Type checking
```

---

## 📋 Implementation Checklist

### Phase 1: Core Setup
- [ ] Initialize project with TypeScript
- [ ] Set up Express server
- [ ] Configure PostgreSQL with Prisma
- [ ] Implement JWT authentication
- [ ] Set up error handling
- [ ] Add request validation

### Phase 2: Core Modules
- [ ] Users & Authentication
- [ ] Employees management
- [ ] Cases CRUD
- [ ] Decisions management
- [ ] Policies library

### Phase 3: Advanced Features
- [ ] Analytics endpoints
- [ ] Governance & audit
- [ ] Notifications system
- [ ] WebSocket real-time
- [ ] File uploads

### Phase 4: Background Jobs
- [ ] SLA monitoring
- [ ] Email notifications
- [ ] Analytics calculations

### Phase 5: Testing & Deployment
- [ ] Unit tests
- [ ] Integration tests
- [ ] Docker configuration
- [ ] CI/CD pipeline

---

## 📚 Documentation Files

1. **DATABASE_SCHEMA.md** - Complete PostgreSQL schema with 22 tables
2. **API_ENDPOINTS.md** - All 87 REST API endpoints with request/response
3. **FOLDER_STRUCTURE.md** - Complete project structure and organization
4. **IMPLEMENTATION_GUIDE.md** - Step-by-step implementation with code examples

---

## 🎯 Key Features Summary

✅ **Authentication**: JWT + SSO (Internal/Google/Azure)  
✅ **Authorization**: Role-based access control (6 roles)  
✅ **Real-time**: WebSocket notifications and updates  
✅ **File Upload**: S3/Local storage with security  
✅ **Audit Trail**: Complete logging of all actions  
✅ **Analytics**: Pre-computed metrics and reports  
✅ **Background Jobs**: SLA monitoring, notifications  
✅ **API**: 87 REST endpoints, fully typed  
✅ **Database**: 22 normalized tables with relationships  
✅ **Testing**: Unit, integration, and E2E support  
✅ **Deployment**: Docker + Kubernetes ready

---

## 📞 API Design Patterns

- RESTful conventions
- Consistent error responses
- Pagination on all lists
- Filtering and sorting support
- Bulk operations where applicable
- Versioned API (/api/v1)
- Standard HTTP status codes
- Comprehensive validation

---

## 🔗 Related Technologies

**Required**:
- Node.js 18+
- TypeScript 5+
- Express.js
- PostgreSQL 15+
- Prisma ORM
- JWT
- Socket.io
- Bull + Redis

**Recommended**:
- Docker
- PM2 (process manager)
- Nginx (reverse proxy)
- AWS S3 (file storage)
- SendGrid (emails)
- Sentry (error tracking)

---

This comprehensive backend specification provides everything needed to build a production-ready API for the AiXWorkForce360 platform.