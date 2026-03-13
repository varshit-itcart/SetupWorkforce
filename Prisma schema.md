# Prisma Schema - AiXWorkForce360

```prisma
// This is your Prisma schema file
// Learn more: https://pris.ly/d/prisma-schema

generator client {
  provider = \"prisma-client-js\"
}

datasource db {
  provider = \"postgresql\"
  url      = env(\"DATABASE_URL\")
}

// ============================================
// USERS & AUTHENTICATION
// ============================================

model User {
  id            String    @id @default(uuid())
  email         String    @unique
  passwordHash  String?   @map(\"password_hash\")
  firstName     String    @map(\"first_name\")
  lastName      String    @map(\"last_name\")
  role          String    // 'admin', 'hr_director', 'hr_manager', 'manager', 'employee', 'legal'
  department    String?
  position      String?
  avatarUrl     String?   @map(\"avatar_url\")
  phone         String?
  isActive      Boolean   @default(true) @map(\"is_active\")
  lastLogin     DateTime? @map(\"last_login\")
  ssoProvider   String?   @map(\"sso_provider\") // 'internal', 'google', 'azure'
  ssoId         String?   @map(\"sso_id\")
  createdAt     DateTime  @default(now()) @map(\"created_at\")
  updatedAt     DateTime  @updatedAt @map(\"updated_at\")
  createdById   String?   @map(\"created_by\")
  updatedById   String?   @map(\"updated_by\")

  // Relations
  refreshTokens            RefreshToken[]
  assignedCases            Case[]                    @relation(\"AssignedCases\")
  reportedCases            Case[]                    @relation(\"ReportedCases\")
  approvedDecisions        Decision[]
  notifications            Notification[]
  activities               Activity[]
  tasks                    Task[]                    @relation(\"AssignedTasks\")
  createdTasks             Task[]                    @relation(\"CreatedTasks\")
  auditLogs                AuditLog[]
  investigationTasks       CaseInvestigationTask[]
  completedInvestigationTasks CaseInvestigationTask[] @relation(\"CompletedBy\")
  caseFiles                CaseFile[]
  policyVersions           PolicyVersion[]
  policyCitations          PolicyCitation[]
  createdPolicies          Policy[]                  @relation(\"CreatedPolicies\")
  updatedPolicies          Policy[]                  @relation(\"UpdatedPolicies\")
  createdDecisions         Decision[]                @relation(\"CreatedDecisions\")
  createdEmployees         Employee[]                @relation(\"CreatedEmployees\")
  updatedEmployees         Employee[]                @relation(\"UpdatedEmployees\")
  createdCases             Case[]                    @relation(\"CreatedCases\")
  updatedCases             Case[]                    @relation(\"UpdatedCases\")
  createdSettings          Setting[]
  updatedAIPersonas        AIPersonaConfig[]
  createdIntegrations      Integration[]

  @@index([email])
  @@index([role])
  @@index([ssoProvider, ssoId])
  @@map(\"users\")
}

model RefreshToken {
  id        String    @id @default(uuid())
  userId    String    @map(\"user_id\")
  token     String    @unique
  expiresAt DateTime  @map(\"expires_at\")
  revoked   Boolean   @default(false)
  revokedAt DateTime? @map(\"revoked_at\")
  ipAddress String?   @map(\"ip_address\")
  userAgent String?   @map(\"user_agent\")
  createdAt DateTime  @default(now()) @map(\"created_at\")

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
  @@index([token])
  @@map(\"refresh_tokens\")
}

// ============================================
// EMPLOYEES
// ============================================

model Employee {
  id               String    @id @default(uuid())
  userId           String?   @map(\"user_id\")
  employeeId       String    @unique @map(\"employee_id\") // EMP-2847
  firstName        String    @map(\"first_name\")
  lastName         String    @map(\"last_name\")
  email            String?
  phone            String?
  position         String
  department       String
  managerId        String?   @map(\"manager_id\")
  location         String?
  hireDate         DateTime  @map(\"hire_date\")
  terminationDate  DateTime? @map(\"termination_date\")
  status           String    @default(\"active\") // 'active', 'on_leave', 'terminated', 'suspended'
  performanceScore Int?      @map(\"performance_score\")
  workSchedule     String?   @map(\"work_schedule\")
  employmentType   String?   @map(\"employment_type\") // 'full_time', 'part_time', 'contract', 'intern'
  payRate          Decimal?  @map(\"pay_rate\") @db.Decimal(12, 2)
  payFrequency     String?   @map(\"pay_frequency\")
  notes            String?
  createdAt        DateTime  @default(now()) @map(\"created_at\")
  updatedAt        DateTime  @updatedAt @map(\"updated_at\")
  createdById      String?   @map(\"created_by\")
  updatedById      String?   @map(\"updated_by\")

  // Relations
  manager              Employee?              @relation(\"EmployeeManager\", fields: [managerId], references: [id])
  directReports        Employee[]             @relation(\"EmployeeManager\")
  cases                Case[]
  onboardingWorkflows  OnboardingWorkflow[]
  assignedBuddies      OnboardingWorkflow[]   @relation(\"OnboardingBuddy\")
  createdBy            User?                  @relation(\"CreatedEmployees\", fields: [createdById], references: [id])
  updatedBy            User?                  @relation(\"UpdatedEmployees\", fields: [updatedById], references: [id])

  @@index([employeeId])
  @@index([department])
  @@index([managerId])
  @@index([status])
  @@map(\"employees\")
}

// ============================================
// CASES
// ============================================

model Case {
  id             String    @id @default(uuid())
  caseNumber     String    @unique @map(\"case_number\") // CASE-2847
  title          String
  description    String?
  type           String    // 'attendance', 'performance', 'harassment', 'safety', 'accommodation', 'leave', 'termination'
  status         String    @default(\"active\") // 'active', 'investigation', 'review', 'closed', 'escalated'
  priority       String    @default(\"normal\") // 'routine', 'normal', 'urgent', 'critical'
  riskLevel      String    @default(\"low\") @map(\"risk_level\") // 'low', 'medium', 'high', 'critical'
  urgency        String    @default(\"normal\") // 'routine', 'normal', 'urgent', 'critical'
  jurisdiction   String?   // 'federal', 'ca', 'ny', 'company'
  confidential   Boolean   @default(false)
  employeeId     String    @map(\"employee_id\")
  assignedTo     String?   @map(\"assigned_to\")
  reportedBy     String?   @map(\"reported_by\")
  slaDueDate     DateTime? @map(\"sla_due_date\")
  slaStatus      String    @default(\"ontime\") @map(\"sla_status\") // 'ontime', 'atrisk', 'overdue'
  hoursRemaining Int?      @map(\"hours_remaining\")
  resolution     String?
  resolutionDate DateTime? @map(\"resolution_date\")
  createdAt      DateTime  @default(now()) @map(\"created_at\")
  updatedAt      DateTime  @updatedAt @map(\"updated_at\")
  createdById    String?   @map(\"created_by\")
  updatedById    String?   @map(\"updated_by\")

  // Relations
  employee           Employee                 @relation(fields: [employeeId], references: [id], onDelete: Cascade)
  assignedUser       User?                    @relation(\"AssignedCases\", fields: [assignedTo], references: [id])
  reporter           User?                    @relation(\"ReportedCases\", fields: [reportedBy], references: [id])
  timeline           CaseTimeline[]
  files              CaseFile[]
  investigationTasks CaseInvestigationTask[]
  decisions          Decision[]
  policyCitations    PolicyCitation[]
  createdBy          User?                    @relation(\"CreatedCases\", fields: [createdById], references: [id])
  updatedBy          User?                    @relation(\"UpdatedCases\", fields: [updatedById], references: [id])

  @@index([caseNumber])
  @@index([employeeId])
  @@index([assignedTo])
  @@index([status])
  @@index([type])
  @@index([riskLevel])
  @@index([assignedTo, status])
  @@index([employeeId, status])
  @@map(\"cases\")
}

model CaseTimeline {
  id          String   @id @default(uuid())
  caseId      String   @map(\"case_id\")
  eventType   String   @map(\"event_type\") // 'created', 'updated', 'status_changed', 'assigned', 'note_added', 'file_uploaded', 'decision_made'
  title       String
  description String?
  eventData   Json?    @map(\"event_data\")
  userId      String?  @map(\"user_id\")
  userName    String?  @map(\"user_name\")
  createdAt   DateTime @default(now()) @map(\"created_at\")

  case Case @relation(fields: [caseId], references: [id], onDelete: Cascade)

  @@index([caseId])
  @@index([eventType])
  @@index([createdAt(sort: Desc)])
  @@map(\"case_timeline\")
}

model CaseFile {
  id          String   @id @default(uuid())
  caseId      String   @map(\"case_id\")
  fileName    String   @map(\"file_name\")
  fileType    String?  @map(\"file_type\")
  fileSize    BigInt?  @map(\"file_size\")
  filePath    String   @map(\"file_path\")
  fileUrl     String?  @map(\"file_url\")
  description String?
  category    String?  // 'evidence', 'documentation', 'communication', 'report'
  uploadedBy  String?  @map(\"uploaded_by\")
  uploadedAt  DateTime @default(now()) @map(\"uploaded_at\")

  case     Case  @relation(fields: [caseId], references: [id], onDelete: Cascade)
  uploader User? @relation(fields: [uploadedBy], references: [id])

  @@index([caseId])
  @@index([category])
  @@map(\"case_files\")
}

model CaseInvestigationTask {
  id          String    @id @default(uuid())
  caseId      String    @map(\"case_id\")
  title       String
  description String?
  assignedTo  String?   @map(\"assigned_to\")
  dueDate     DateTime? @map(\"due_date\")
  completed   Boolean   @default(false)
  completedAt DateTime? @map(\"completed_at\")
  completedBy String?   @map(\"completed_by\")
  notes       String?
  sortOrder   Int?      @map(\"sort_order\")
  createdAt   DateTime  @default(now()) @map(\"created_at\")
  updatedAt   DateTime  @updatedAt @map(\"updated_at\")

  case        Case  @relation(fields: [caseId], references: [id], onDelete: Cascade)
  assignedUser User? @relation(fields: [assignedTo], references: [id])
  completedByUser User? @relation(\"CompletedBy\", fields: [completedBy], references: [id])

  @@index([caseId])
  @@index([assignedTo])
  @@map(\"case_investigation_tasks\")
}

// ============================================
// DECISIONS
// ============================================

model Decision {
  id                  String    @id @default(uuid())
  decisionId          String    @unique @map(\"decision_id\") // DEC-8472
  caseId              String?   @map(\"case_id\")
  title               String
  decisionText        String    @map(\"decision_text\")
  decisionMode        String?   @map(\"decision_mode\") // 'autopilot', 'copilot', 'escalation', 'manual'
  aiPersona           String?   @map(\"ai_persona\") // 'hr', 'legal', 'operations', 'finance'
  aiRecommendation    String?   @map(\"ai_recommendation\")
  aiConfidenceScore   Decimal?  @map(\"ai_confidence_score\") @db.Decimal(5, 2)
  riskAssessment      String?   @map(\"risk_assessment\")
  policyReferences    Json?     @map(\"policy_references\")
  approverId          String?   @map(\"approver_id\")
  approvedAt          DateTime? @map(\"approved_at\")
  status              String    @default(\"pending\") // 'pending', 'approved', 'rejected', 'implemented'
  overrideReason      String?   @map(\"override_reason\")
  auditHash           String?   @map(\"audit_hash\")
  createdAt           DateTime  @default(now()) @map(\"created_at\")
  updatedAt           DateTime  @updatedAt @map(\"updated_at\")
  createdById         String?   @map(\"created_by\")

  case            Case?             @relation(fields: [caseId], references: [id], onDelete: Cascade)
  approver        User?             @relation(fields: [approverId], references: [id])
  createdBy       User?             @relation(\"CreatedDecisions\", fields: [createdById], references: [id])
  policyCitations PolicyCitation[]

  @@index([decisionId])
  @@index([caseId])
  @@index([approverId])
  @@index([status])
  @@map(\"decisions\")
}

// ============================================
// POLICIES
// ============================================

model Policy {
  id             String    @id @default(uuid())
  title          String
  slug           String    @unique
  jurisdiction   String    // 'federal', 'ca', 'ny', 'company'
  topic          String    // 'leave', 'wage_hour', 'termination', 'performance', 'accommodation', 'safety'
  version        String
  content        String
  excerpt        String?
  effectiveDate  DateTime  @map(\"effective_date\")
  expirationDate DateTime? @map(\"expiration_date\")
  isActive       Boolean   @default(true) @map(\"is_active\")
  policyData     Json?     @map(\"policy_data\")
  createdAt      DateTime  @default(now()) @map(\"created_at\")
  updatedAt      DateTime  @updatedAt @map(\"updated_at\")
  createdById    String?   @map(\"created_by\")
  updatedById    String?   @map(\"updated_by\")

  versions    PolicyVersion[]
  citations   PolicyCitation[]
  createdBy   User?            @relation(\"CreatedPolicies\", fields: [createdById], references: [id])
  updatedBy   User?            @relation(\"UpdatedPolicies\", fields: [updatedById], references: [id])

  @@index([jurisdiction])
  @@index([topic])
  @@index([isActive])
  @@map(\"policies\")
}

model PolicyVersion {
  id            String   @id @default(uuid())
  policyId      String   @map(\"policy_id\")
  version       String
  content       String
  changeSummary String?  @map(\"change_summary\")
  effectiveDate DateTime @map(\"effective_date\")
  createdAt     DateTime @default(now()) @map(\"created_at\")
  createdById   String?  @map(\"created_by\")

  policy    Policy @relation(fields: [policyId], references: [id], onDelete: Cascade)
  createdBy User?  @relation(fields: [createdById], references: [id])

  @@index([policyId])
  @@map(\"policy_versions\")
}

model PolicyCitation {
  id           String   @id @default(uuid())
  policyId     String   @map(\"policy_id\")
  caseId       String?  @map(\"case_id\")
  decisionId   String?  @map(\"decision_id\")
  citedSection String?  @map(\"cited_section\")
  appliedAt    DateTime @default(now()) @map(\"applied_at\")
  appliedBy    String?  @map(\"applied_by\")

  policy   Policy    @relation(fields: [policyId], references: [id], onDelete: Cascade)
  case     Case?     @relation(fields: [caseId], references: [id], onDelete: SetNull)
  decision Decision? @relation(fields: [decisionId], references: [id], onDelete: SetNull)
  user     User?     @relation(fields: [appliedBy], references: [id])

  @@index([policyId])
  @@index([caseId])
  @@map(\"policy_citations\")
}

// ============================================
// NOTIFICATIONS & ACTIVITIES
// ============================================

model Notification {
  id        String    @id @default(uuid())
  userId    String    @map(\"user_id\")
  type      String    // 'case_assigned', 'decision_pending', 'sla_warning', 'case_escalated'
  title     String
  message   String
  link      String?
  priority  String    @default(\"normal\") // 'low', 'normal', 'high', 'critical'
  read      Boolean   @default(false)
  readAt    DateTime? @map(\"read_at\")
  data      Json?
  createdAt DateTime  @default(now()) @map(\"created_at\")

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
  @@index([read])
  @@index([createdAt(sort: Desc)])
  @@index([userId, read])
  @@map(\"notifications\")
}

model Activity {
  id          String   @id @default(uuid())
  title       String
  description String?
  type        String   // 'case', 'decision', 'approval', 'alert', 'system'
  status      String?  // 'success', 'warning', 'info', 'error'
  entityType  String?  @map(\"entity_type\") // 'case', 'employee', 'policy', 'decision'
  entityId    String?  @map(\"entity_id\")
  link        String?
  userId      String?  @map(\"user_id\")
  createdAt   DateTime @default(now()) @map(\"created_at\")

  user User? @relation(fields: [userId], references: [id])

  @@index([type])
  @@index([userId])
  @@index([createdAt(sort: Desc)])
  @@map(\"activities\")
}

// ============================================
// TASKS
// ============================================

model Task {
  id          String    @id @default(uuid())
  title       String
  description String?
  assignedTo  String?   @map(\"assigned_to\")
  dueDate     DateTime? @map(\"due_date\")
  priority    String    @default(\"medium\") // 'low', 'medium', 'high', 'critical'
  status      String    @default(\"pending\") // 'pending', 'in_progress', 'completed', 'cancelled'
  completed   Boolean   @default(false)
  completedAt DateTime? @map(\"completed_at\")
  entityType  String?   @map(\"entity_type\") // 'case', 'employee', 'policy'
  entityId    String?   @map(\"entity_id\")
  createdAt   DateTime  @default(now()) @map(\"created_at\")
  updatedAt   DateTime  @updatedAt @map(\"updated_at\")
  createdById String?   @map(\"created_by\")

  assignedUser User? @relation(\"AssignedTasks\", fields: [assignedTo], references: [id])
  createdBy    User? @relation(\"CreatedTasks\", fields: [createdById], references: [id])

  @@index([assignedTo])
  @@index([status])
  @@index([priority])
  @@index([assignedTo, status])
  @@map(\"tasks\")
}

// ============================================
// ANALYTICS
// ============================================

model AnalyticsMetric {
  id          String   @id @default(uuid())
  metricType  String   @map(\"metric_type\") // 'case_volume', 'sla_compliance', 'resolution_time', 'risk_distribution'
  metricName  String   @map(\"metric_name\")
  metricValue Decimal? @map(\"metric_value\") @db.Decimal(12, 2)
  metricUnit  String?  @map(\"metric_unit\")
  dimensions  Json?    // flexible dimensions for filtering
  periodStart DateTime @map(\"period_start\") @db.Date
  periodEnd   DateTime @map(\"period_end\") @db.Date
  createdAt   DateTime @default(now()) @map(\"created_at\")

  @@index([metricType])
  @@index([periodStart, periodEnd])
  @@map(\"analytics_metrics\")
}

// ============================================
// AUDIT & GOVERNANCE
// ============================================

model AuditLog {
  id               String   @id @default(uuid())
  userId           String?  @map(\"user_id\")
  userEmail        String?  @map(\"user_email\")
  action           String   // 'create', 'update', 'delete', 'login', 'logout', 'approve', 'reject'
  entityType       String   @map(\"entity_type\") // 'case', 'employee', 'policy', 'decision'
  entityId         String?  @map(\"entity_id\")
  entityIdentifier String?  @map(\"entity_identifier\")
  changes          Json?
  ipAddress        String?  @map(\"ip_address\")
  userAgent        String?  @map(\"user_agent\")
  requestMethod    String?  @map(\"request_method\")
  requestPath      String?  @map(\"request_path\")
  statusCode       Int?     @map(\"status_code\")
  errorMessage     String?  @map(\"error_message\")
  createdAt        DateTime @default(now()) @map(\"created_at\")

  user User? @relation(fields: [userId], references: [id], onDelete: SetNull)

  @@index([userId])
  @@index([entityType, entityId])
  @@index([action])
  @@index([createdAt(sort: Desc)])
  @@index([userId, entityType, entityId])
  @@map(\"audit_logs\")
}

model GovernanceAuthorityMatrix {
  id               String   @id @default(uuid())
  role             String
  actionType       String   @map(\"action_type\") // 'create_case', 'approve_decision', 'terminate_employee'
  riskLevel        String?  @map(\"risk_level\") // 'low', 'medium', 'high', 'critical'
  requiresApproval Boolean  @default(false) @map(\"requires_approval\")
  approvalRole     String?  @map(\"approval_role\")
  conditions       Json?
  isActive         Boolean  @default(true) @map(\"is_active\")
  createdAt        DateTime @default(now()) @map(\"created_at\")
  updatedAt        DateTime @updatedAt @map(\"updated_at\")

  @@index([role])
  @@index([actionType])
  @@map(\"governance_authority_matrix\")
}

model AIPersonaConfig {
  id                  String   @id @default(uuid())
  personaType         String   @map(\"persona_type\") // 'hr', 'legal', 'operations', 'finance'
  version             String
  authorityScope      Json     @map(\"authority_scope\")
  boundaries          Json
  confidenceThreshold Decimal? @map(\"confidence_threshold\") @db.Decimal(5, 2)
  modelConfig         Json?    @map(\"model_config\")
  isActive            Boolean  @default(true) @map(\"is_active\")
  createdAt           DateTime @default(now()) @map(\"created_at\")
  updatedAt           DateTime @updatedAt @map(\"updated_at\")
  updatedById         String?  @map(\"updated_by\")

  updatedBy User? @relation(fields: [updatedById], references: [id])

  @@index([personaType])
  @@map(\"ai_persona_configs\")
}

// ============================================
// INTEGRATIONS
// ============================================

model Integration {
  id            String    @id @default(uuid())
  name          String
  type          String    // 'hris', 'ats', 'payroll', 'sso', 'communication'
  status        String    @default(\"active\") // 'active', 'inactive', 'error'
  config        Json
  lastSync      DateTime? @map(\"last_sync\")
  syncFrequency String?   @map(\"sync_frequency\") // 'realtime', 'hourly', 'daily', 'manual'
  errorMessage  String?   @map(\"error_message\")
  createdAt     DateTime  @default(now()) @map(\"created_at\")
  updatedAt     DateTime  @updatedAt @map(\"updated_at\")
  createdById   String?   @map(\"created_by\")

  createdBy User? @relation(fields: [createdById], references: [id])

  @@index([type])
  @@index([status])
  @@map(\"integrations\")
}

// ============================================
// ONBOARDING
// ============================================

model OnboardingWorkflow {
  id                 String    @id @default(uuid())
  employeeId         String    @map(\"employee_id\")
  workflowTemplate   String    @map(\"workflow_template\")
  status             String    @default(\"pending\") // 'pending', 'in_progress', 'completed', 'cancelled'
  startDate          DateTime? @map(\"start_date\") @db.Date
  completionDate     DateTime? @map(\"completion_date\") @db.Date
  progressPercentage Int       @default(0) @map(\"progress_percentage\")
  assignedBuddyId    String?   @map(\"assigned_buddy\")
  notes              String?
  createdAt          DateTime  @default(now()) @map(\"created_at\")
  updatedAt          DateTime  @updatedAt @map(\"updated_at\")

  employee      Employee          @relation(fields: [employeeId], references: [id], onDelete: Cascade)
  assignedBuddy Employee?         @relation(\"OnboardingBuddy\", fields: [assignedBuddyId], references: [id])
  tasks         OnboardingTask[]

  @@index([employeeId])
  @@index([status])
  @@map(\"onboarding_workflows\")
}

model OnboardingTask {
  id          String    @id @default(uuid())
  workflowId  String    @map(\"workflow_id\")
  title       String
  description String?
  taskType    String?   @map(\"task_type\") // 'document', 'training', 'meeting', 'system_access'
  assignedTo  String?   @map(\"assigned_to\")
  dueDays     Int?      @map(\"due_days\")
  completed   Boolean   @default(false)
  completedAt DateTime? @map(\"completed_at\")
  sortOrder   Int?      @map(\"sort_order\")
  createdAt   DateTime  @default(now()) @map(\"created_at\")

  workflow OnboardingWorkflow @relation(fields: [workflowId], references: [id], onDelete: Cascade)

  @@index([workflowId])
  @@map(\"onboarding_tasks\")
}

// ============================================
// SETTINGS
// ============================================

model Setting {
  id          String   @id @default(uuid())
  category    String   // 'general', 'security', 'notifications', 'integrations'
  key         String
  value       Json
  description String?
  isPublic    Boolean  @default(false) @map(\"is_public\")
  updatedAt   DateTime @updatedAt @map(\"updated_at\")
  updatedById String?  @map(\"updated_by\")

  updatedBy User? @relation(fields: [updatedById], references: [id])

  @@unique([category, key])
  @@index([category])
  @@map(\"settings\")
}
```

## Migration Commands

```bash
# Initialize Prisma
npx prisma init

# Create migration
npx prisma migrate dev --name init

# Generate Prisma Client
npx prisma generate

# Apply migrations to production
npx prisma migrate deploy

# Open Prisma Studio (GUI)
npx prisma studio

# Reset database (dev only)
npx prisma migrate reset

# Validate schema
npx prisma validate

# Format schema
npx prisma format
```

## Seed Data Example

Create `src/database/seeds/index.ts`:

```typescript
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  // Create admin user
  const adminPassword = await bcrypt.hash('Admin@123', 10);
  
  const admin = await prisma.user.upsert({
    where: { email: 'admin@workspring.com' },
    update: {},
    create: {
      email: 'admin@workspring.com',
      passwordHash: adminPassword,
      firstName: 'System',
      lastName: 'Administrator',
      role: 'admin',
      isActive: true,
    },
  });

  console.log('✅ Admin user created:', admin.email);

  // Create default settings
  await prisma.setting.createMany({
    data: [
      {
        category: 'general',
        key: 'company_name',
        value: JSON.stringify('AiXWorkForce360'),
        description: 'Company name',
        isPublic: true,
      },
      {
        category: 'general',
        key: 'timezone',
        value: JSON.stringify('America/Los_Angeles'),
        description: 'Default timezone',
        isPublic: true,
      },
    ],
    skipDuplicates: true,
  });

  console.log('✅ Default settings created');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

Run seed:
```bash
npx ts-node src/database/seeds/index.ts
```
