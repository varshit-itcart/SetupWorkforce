# Quick Reference Guide - AiXWorkForce360 Backend

## 📁 Generated Documentation Files

1. **README.md** (16KB) - Complete summary and overview
2. **DATABASE_SCHEMA.md** (22KB) - PostgreSQL schema with 22 tables
3. **API_ENDPOINTS.md** (25KB) - 87 REST API endpoints
4. **FOLDER_STRUCTURE.md** (17KB) - Complete project structure
5. **IMPLEMENTATION_GUIDE.md** (21KB) - Step-by-step implementation
6. **PRISMA_SCHEMA.md** (26KB) - Complete Prisma ORM schema

---

## 🎯 Quick Stats

- **Total Tables**: 22
- **Total API Endpoints**: 87
- **User Roles**: 6 (admin, hr_director, hr_manager, manager, employee, legal)
- **Real-time Events**: 8 WebSocket event types
- **Background Jobs**: 5 scheduled jobs
- **File Upload Support**: Yes (S3/Local)
- **Audit Logging**: Complete trail for all actions

---

## 🚀 Quick Start Commands

```bash
# 1. Initialize project
mkdir aixworkforce360-backend && cd aixworkforce360-backend
npm init -y

# 2. Install all dependencies (see IMPLEMENTATION_GUIDE.md for full list)
npm install express typescript prisma @prisma/client jsonwebtoken bcrypt socket.io bull ioredis

# 3. Set up TypeScript
npx tsc --init

# 4. Initialize Prisma
npx prisma init

# 5. Copy Prisma schema from PRISMA_SCHEMA.md to prisma/schema.prisma

# 6. Create and run migrations
npx prisma migrate dev --name init

# 7. Generate Prisma Client
npx prisma generate

# 8. Start development
npm run dev
```

---

## 📊 Database Tables Quick Reference

### Core Entities (9 tables)
- `users` - User accounts & auth
- `refresh_tokens` - JWT refresh tokens
- `employees` - Employee directory
- `cases` - Case management
- `case_timeline` - Case history
- `case_files` - Case attachments
- `case_investigation_tasks` - Investigation checklists
- `decisions` - AI decisions
- `policies` - Policy library

### Supporting Tables (13 tables)
- `policy_versions` - Version control
- `policy_citations` - Usage tracking
- `notifications` - User notifications
- `activities` - Activity feed
- `tasks` - Task management
- `analytics_metrics` - Pre-computed analytics
- `audit_logs` - Audit trail
- `governance_authority_matrix` - RBAC
- `ai_persona_configs` - AI settings
- `integrations` - External systems
- `onboarding_workflows` - Onboarding
- `onboarding_tasks` - Onboarding tasks
- `settings` - App config

---

## 🔗 API Endpoints by Category

### Authentication (7)
`POST /auth/register`, `/auth/login`, `/auth/sso/login`, `/auth/refresh`, `/auth/logout`, `/auth/forgot-password`, `/auth/reset-password`

### Users (9)
`GET /users`, `GET /users/:id`, `GET /users/me`, `PUT /users/:id`, `PUT /users/me`, `DELETE /users/:id`, `PUT /users/:id/activate`, `PUT /users/:id/deactivate`

### Employees (12)
`GET /employees`, `GET /employees/:id`, `POST /employees`, `PUT /employees/:id`, `DELETE /employees/:id`, `GET /employees/:id/cases`, `GET /employees/:id/performance`, `POST /employees/:id/change-status`, `POST /employees/import`, `GET /employees/export`, `GET /employees/stats`

### Cases (17)
CRUD + timeline, files, tasks, assign, status, escalate, close, stats

### Decisions (7)
CRUD + approve, reject, override, audit-hash

### Policies (9)
CRUD + versions, citations, test, search

### Analytics (7)
Dashboard, cases, employees, decisions, SLA, governance, export

### Governance (10)
Decisions, audit-logs, authority-matrix, check-authority, outcome-review, ai-personas

### Others (19)
Notifications (6), Tasks (6), Onboarding (8), Integrations (7), Settings (5), Activities (2), Files (4)

---

## 🔐 Authentication Flow

### Login
```
1. POST /auth/login { email, password }
2. Verify credentials (bcrypt)
3. Generate JWT access token (1h expiry)
4. Generate refresh token (7d expiry, stored in DB)
5. Return { user, accessToken, refreshToken }
```

### API Request
```
1. Include: Authorization: Bearer <access_token>
2. Middleware verifies token
3. Attach user to request object
4. Check RBAC permissions
5. Process request
```

### Token Refresh
```
1. POST /auth/refresh { refreshToken }
2. Verify refresh token in DB
3. Generate new access + refresh tokens
4. Revoke old refresh token
5. Return new tokens
```

---

## 🎨 Role Permissions (Hierarchy)

```
admin (Level 5)
  └── Full system access
  
hr_director (Level 4)
  └── HR leadership + all hr_manager permissions
  
hr_manager (Level 3)
  └── HR operations + all manager permissions
  
manager (Level 2)
  └── Department management + all employee permissions
  
employee (Level 1)
  └── Basic access (own profile, view policies)
  
legal (Special)
  └── Legal review + compliance access
```

**Permission Check**: User role level >= Required role level

---

## 📦 Required NPM Packages

### Core (10)
`express`, `typescript`, `@types/node`, `@types/express`, `dotenv`, `cors`, `helmet`, `ts-node`, `nodemon`, `winston`

### Database (3)
`prisma`, `@prisma/client`, `pg`

### Authentication (4)
`jsonwebtoken`, `@types/jsonwebtoken`, `bcrypt`, `@types/bcrypt`

### Validation (2)
`zod`, `express-validator`

### Real-time (2)
`socket.io`, `@types/socket.io`

### Background Jobs (3)
`bull`, `ioredis`, `@types/ioredis`

### File Upload (2)
`multer`, `@types/multer`

### Utilities (3)
`uuid`, `date-fns`, `crypto-js`

### Testing (4)
`jest`, `@types/jest`, `ts-jest`, `supertest`

---

## 🌐 Environment Variables (Critical)

```env
# Server
NODE_ENV=development
PORT=8000
API_VERSION=v1

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/aixworkforce360

# JWT
JWT_SECRET=your-super-secret-key-change-in-production
JWT_EXPIRES_IN=1h
REFRESH_TOKEN_SECRET=your-refresh-secret
REFRESH_TOKEN_EXPIRES_IN=7d

# Redis
REDIS_URL=redis://localhost:6379

# CORS
CORS_ORIGIN=http://localhost:3000

# File Storage
STORAGE_TYPE=local
UPLOAD_MAX_SIZE=10485760
UPLOAD_DIR=./uploads
```

---

## 🔄 WebSocket Events

### Connection
```typescript
// Client connects with JWT
socket.connect('/api/v1/ws', { auth: { token: jwt } });
```

### Events
```typescript
'notification:new'       // New notification
'notification:read'      // Notification read
'case:assigned'          // Case assigned
'case:status-changed'    // Case status updated
'case:sla-warning'       // SLA approaching
'decision:pending'       // Decision needs approval
'decision:status-changed' // Decision approved/rejected
'metrics:update'         // Dashboard metrics updated
```

---

## 🧪 Testing Commands

```bash
npm run test              # Run all tests
npm run test:watch        # Watch mode
npm run test:coverage     # Coverage report
npm run test:unit         # Unit tests only
npm run test:integration  # Integration tests only
npm run test:e2e          # End-to-end tests
```

---

## 📈 Performance Best Practices

### Database
- ✅ Use indexes on foreign keys
- ✅ Composite indexes for common queries
- ✅ Connection pooling
- ✅ Query pagination (default: 20 items)
- ✅ Avoid N+1 queries (use Prisma includes)

### API
- ✅ Response caching (Redis)
- ✅ Rate limiting (100 req/15min)
- ✅ Compression (gzip)
- ✅ Query result caching
- ✅ Lazy loading

### Files
- ✅ CDN for serving
- ✅ Presigned URLs (S3)
- ✅ Image optimization
- ✅ Virus scanning

---

## 🐛 Common Issues & Solutions

### Issue: Prisma Client not generated
```bash
npx prisma generate
```

### Issue: Migration failed
```bash
npx prisma migrate reset  # Dev only
npx prisma migrate dev
```

### Issue: Port already in use
```bash
lsof -ti:8000 | xargs kill -9
# Or change PORT in .env
```

### Issue: JWT token expired
```bash
# Use refresh token endpoint
POST /auth/refresh
```

### Issue: CORS errors
```bash
# Check CORS_ORIGIN in .env
# Must match frontend URL
```

---

## 📚 Documentation Reference

| File | Purpose | Size |
|------|---------|------|
| README.md | Complete overview | 16KB |
| DATABASE_SCHEMA.md | SQL schema with triggers | 22KB |
| API_ENDPOINTS.md | All 87 endpoints | 25KB |
| FOLDER_STRUCTURE.md | Project organization | 17KB |
| IMPLEMENTATION_GUIDE.md | Code examples | 21KB |
| PRISMA_SCHEMA.md | Prisma ORM schema | 26KB |

**Total Documentation**: ~127KB of comprehensive specs

---

## 🎯 Development Workflow

```
1. Design API endpoint (API_ENDPOINTS.md)
   ↓
2. Create Prisma model (PRISMA_SCHEMA.md)
   ↓
3. Run migration (npx prisma migrate dev)
   ↓
4. Generate types (npx prisma generate)
   ↓
5. Create validator (src/validators/)
   ↓
6. Implement service (src/services/)
   ↓
7. Create controller (src/controllers/)
   ↓
8. Add route (src/routes/)
   ↓
9. Add RBAC middleware
   ↓
10. Write tests (src/tests/)
   ↓
11. Test with Postman/curl
   ↓
12. Document any changes
```

---

## 🚀 Deployment Checklist

- [ ] Set NODE_ENV=production
- [ ] Update all secrets in .env
- [ ] Run migrations: `npx prisma migrate deploy`
- [ ] Build TypeScript: `npm run build`
- [ ] Set up Redis for jobs
- [ ] Configure S3/storage
- [ ] Set up monitoring (Sentry)
- [ ] Configure SSL/TLS
- [ ] Set up logging
- [ ] Configure backup strategy
- [ ] Set up CI/CD pipeline
- [ ] Load test critical endpoints
- [ ] Security audit

---

## 📞 Support & Resources

- **Prisma Docs**: https://www.prisma.io/docs
- **Express Docs**: https://expressjs.com
- **Socket.io Docs**: https://socket.io/docs
- **TypeScript Docs**: https://www.typescriptlang.org/docs
- **Bull Queue**: https://github.com/OptimalBits/bull

---

## 🎉 Next Steps After Setup

1. Review DATABASE_SCHEMA.md for table relationships
2. Study API_ENDPOINTS.md for request/response formats
3. Follow IMPLEMENTATION_GUIDE.md step-by-step
4. Copy PRISMA_SCHEMA.md to your project
5. Refer to FOLDER_STRUCTURE.md for organization
6. Use README.md for quick reference

**Start with authentication → users → employees → cases → decisions**

---

This backend specification is production-ready and covers all aspects of the AiXWorkForce360 Workforce Decision OS platform.