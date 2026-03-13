
# API Endpoints Specification - AiXWorkForce360

Base URL: `/api/v1`

## Authentication Endpoints

### POST /auth/register
Create a new user account
```typescript
Request: {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  role?: string; // default: 'employee'
  department?: string;
  position?: string;
}

Response: {
  user: User;
  accessToken: string;
  refreshToken: string;
}
```

### POST /auth/login
Login with email and password
```typescript
Request: {
  email: string;
  password: string;
}

Response: {
  user: User;
  accessToken: string;
  refreshToken: string;
}
```

### POST /auth/sso/login
SSO authentication (internal/google/azure)
```typescript
Request: {
  provider: 'internal' | 'google' | 'azure';
  token: string;
  email?: string;
}

Response: {
  user: User;
  accessToken: string;
  refreshToken: string;
}
```

### POST /auth/refresh
Refresh access token
```typescript
Request: {
  refreshToken: string;
}

Response: {
  accessToken: string;
  refreshToken: string;
}
```

### POST /auth/logout
Logout and invalidate refresh token
```typescript
Request: {
  refreshToken: string;
}

Response: {
  message: string;
}
```

### POST /auth/forgot-password
Request password reset
```typescript
Request: {
  email: string;
}

Response: {
  message: string;
}
```

### POST /auth/reset-password
Reset password with token
```typescript
Request: {
  token: string;
  newPassword: string;
}

Response: {
  message: string;
}
```

---

## User Endpoints

### GET /users
Get all users (admin only)
```typescript
Query: {
  page?: number;
  limit?: number;
  role?: string;
  department?: string;
  search?: string;
  isActive?: boolean;
}

Response: {
  users: User[];
  pagination: PaginationMeta;
}
```

### GET /users/:id
Get user by ID
```typescript
Response: User
```

### GET /users/me
Get current user profile
```typescript
Response: User
```

### PUT /users/:id
Update user
```typescript
Request: Partial<User>

Response: User
```

### PUT /users/me
Update current user profile
```typescript
Request: {
  firstName?: string;
  lastName?: string;
  phone?: string;
  avatarUrl?: string;
}

Response: User
```

### DELETE /users/:id
Soft delete user (admin only)
```typescript
Response: {
  message: string;
}
```

### PUT /users/:id/activate
Activate user account
```typescript
Response: User
```

### PUT /users/:id/deactivate
Deactivate user account
```typescript
Response: User
```

---

## Employee Endpoints

### GET /employees
Get all employees
```typescript
Query: {
  page?: number;
  limit?: number;
  department?: string;
  status?: string;
  manager?: string;
  location?: string;
  search?: string;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

Response: {
  employees: Employee[];
  pagination: PaginationMeta;
  stats: {
    total: number;
    byDepartment: Record<string, number>;
    byStatus: Record<string, number>;
  }
}
```

### GET /employees/:id
Get employee by ID
```typescript
Response: {
  employee: Employee;
  manager: Employee | null;
  directReports: Employee[];
  activeCases: Case[];
  recentActivity: Activity[];
}
```

### POST /employees
Create new employee
```typescript
Request: {
  employeeId?: string; // auto-generated if not provided
  firstName: string;
  lastName: string;
  email: string;
  phone?: string;
  position: string;
  department: string;
  managerId?: string;
  location?: string;
  hireDate: string;
  status?: string;
  employmentType?: string;
  payRate?: number;
  payFrequency?: string;
  workSchedule?: string;
}

Response: Employee
```

### PUT /employees/:id
Update employee
```typescript
Request: Partial<Employee>

Response: Employee
```

### DELETE /employees/:id
Delete employee (soft delete)
```typescript
Response: {
  message: string;
}
```

### GET /employees/:id/cases
Get employee cases
```typescript
Query: {
  status?: string;
  type?: string;
  page?: number;
  limit?: number;
}

Response: {
  cases: Case[];
  pagination: PaginationMeta;
}
```

### GET /employees/:id/performance
Get employee performance metrics
```typescript
Response: {
  performanceScore: number;
  caseHistory: number;
  attendanceRate: number;
  tenure: number;
  evaluations: any[];
}
```

### POST /employees/:id/change-status
Change employee status
```typescript
Request: {
  status: 'active' | 'on_leave' | 'terminated' | 'suspended';
  effectiveDate?: string;
  reason?: string;
}

Response: Employee
```

### POST /employees/import
Bulk import employees (CSV)
```typescript
Request: FormData {
  file: File;
}

Response: {
  imported: number;
  failed: number;
  errors: string[];
}
```

### GET /employees/export
Export employees to CSV
```typescript
Query: {
  department?: string;
  status?: string;
  format?: 'csv' | 'xlsx';
}

Response: File
```

### GET /employees/stats
Get employee statistics
```typescript
Response: {
  totalEmployees: number;
  activeEmployees: number;
  averageTenure: number;
  retentionRate: number;
  byDepartment: Array<{department: string; count: number}>;
  byLocation: Array<{location: string; count: number}>;
}
```

---

## Case Endpoints

### GET /cases
Get all cases
```typescript
Query: {
  page?: number;
  limit?: number;
  status?: string;
  type?: string;
  riskLevel?: string;
  urgency?: string;
  assignedTo?: string;
  employeeId?: string;
  confidential?: boolean;
  slaStatus?: string;
  search?: string;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

Response: {
  cases: Case[];
  pagination: PaginationMeta;
  stats: {
    total: number;
    byStatus: Record<string, number>;
    byType: Record<string, number>;
    byRisk: Record<string, number>;
  }
}
```

### GET /cases/:id
Get case by ID
```typescript
Response: {
  case: Case;
  employee: Employee;
  assignedUser: User;
  timeline: CaseTimelineEvent[];
  files: CaseFile[];
  tasks: InvestigationTask[];
  decisions: Decision[];
}
```

### POST /cases
Create new case
```typescript
Request: {
  title: string;
  description: string;
  type: string;
  priority?: string;
  riskLevel?: string;
  urgency?: string;
  jurisdiction?: string;
  confidential?: boolean;
  employeeId: string;
  assignedTo?: string;
  slaDueDate?: string;
}

Response: Case
```

### PUT /cases/:id
Update case
```typescript
Request: Partial<Case>

Response: Case
```

### DELETE /cases/:id
Delete case
```typescript
Response: {
  message: string;
}
```

### POST /cases/:id/assign
Assign case to user
```typescript
Request: {
  assignedTo: string;
  notes?: string;
}

Response: Case
```

### POST /cases/:id/status
Change case status
```typescript
Request: {
  status: string;
  notes?: string;
}

Response: Case
```

### POST /cases/:id/escalate
Escalate case
```typescript
Request: {
  escalateTo: string;
  reason: string;
  priority?: string;
}

Response: Case
```

### POST /cases/:id/close
Close case
```typescript
Request: {
  resolution: string;
  outcome?: string;
}

Response: Case
```

### GET /cases/:id/timeline
Get case timeline
```typescript
Response: CaseTimelineEvent[]
```

### POST /cases/:id/timeline
Add timeline event
```typescript
Request: {
  eventType: string;
  title: string;
  description?: string;
  eventData?: any;
}

Response: CaseTimelineEvent
```

### GET /cases/:id/files
Get case files
```typescript
Query: {
  category?: string;
}

Response: CaseFile[]
```

### POST /cases/:id/files
Upload case file
```typescript
Request: FormData {
  file: File;
  category?: string;
  description?: string;
}

Response: CaseFile
```

### DELETE /cases/:id/files/:fileId
Delete case file
```typescript
Response: {
  message: string;
}
```

### GET /cases/:id/files/:fileId/download
Download case file
```typescript
Response: File
```

### GET /cases/:id/tasks
Get investigation tasks
```typescript
Response: InvestigationTask[]
```

### POST /cases/:id/tasks
Create investigation task
```typescript
Request: {
  title: string;
  description?: string;
  assignedTo?: string;
  dueDate?: string;
  sortOrder?: number;
}

Response: InvestigationTask
```

### PUT /cases/:id/tasks/:taskId
Update investigation task
```typescript
Request: Partial<InvestigationTask>

Response: InvestigationTask
```

### POST /cases/:id/tasks/:taskId/complete
Mark task as complete
```typescript
Request: {
  notes?: string;
}

Response: InvestigationTask
```

### DELETE /cases/:id/tasks/:taskId
Delete investigation task
```typescript
Response: {
  message: string;
}
```

### GET /cases/stats
Get case statistics
```typescript
Query: {
  startDate?: string;
  endDate?: string;
  department?: string;
}

Response: {
  totalCases: number;
  openCases: number;
  closedCases: number;
  averageResolutionTime: number;
  slaCompliance: number;
  byType: Array<{type: string; count: number}>;
  byRisk: Array<{risk: string; count: number}>;
  byStatus: Array<{status: string; count: number}>;
  trend: Array<{date: string; count: number}>;
}
```

---

## Decision Endpoints

### GET /decisions
Get all decisions
```typescript
Query: {
  page?: number;
  limit?: number;
  caseId?: string;
  status?: string;
  mode?: string;
  persona?: string;
  approverId?: string;
  search?: string;
}

Response: {
  decisions: Decision[];
  pagination: PaginationMeta;
}
```

### GET /decisions/:id
Get decision by ID
```typescript
Response: {
  decision: Decision;
  case: Case;
  approver: User;
  policyCitations: PolicyCitation[];
}
```

### POST /decisions
Create new decision
```typescript
Request: {
  caseId: string;
  title: string;
  decisionText: string;
  decisionMode?: string;
  aiPersona?: string;
  aiRecommendation?: string;
  aiConfidenceScore?: number;
  riskAssessment?: string;
  policyReferences?: any[];
}

Response: Decision
```

### PUT /decisions/:id
Update decision
```typescript
Request: Partial<Decision>

Response: Decision
```

### POST /decisions/:id/approve
Approve decision
```typescript
Request: {
  notes?: string;
}

Response: Decision
```

### POST /decisions/:id/reject
Reject decision
```typescript
Request: {
  reason: string;
  notes?: string;
}

Response: Decision
```

### POST /decisions/:id/override
Override AI recommendation
```typescript
Request: {
  overrideReason: string;
  newDecision: string;
}

Response: Decision
```

### GET /decisions/:id/audit-hash
Verify decision audit hash
```typescript
Response: {
  valid: boolean;
  hash: string;
  timestamp: string;
}
```

---

## Policy Endpoints

### GET /policies
Get all policies
```typescript
Query: {
  page?: number;
  limit?: number;
  jurisdiction?: string;
  topic?: string;
  isActive?: boolean;
  search?: string;
}

Response: {
  policies: Policy[];
  pagination: PaginationMeta;
}
```

### GET /policies/:id
Get policy by ID
```typescript
Response: {
  policy: Policy;
  versions: PolicyVersion[];
  citations: PolicyCitation[];
}
```

### POST /policies
Create new policy
```typescript
Request: {
  title: string;
  jurisdiction: string;
  topic: string;
  version: string;
  content: string;
  excerpt?: string;
  effectiveDate: string;
  expirationDate?: string;
  policyData?: any;
}

Response: Policy
```

### PUT /policies/:id
Update policy
```typescript
Request: Partial<Policy>

Response: Policy
```

### DELETE /policies/:id
Delete policy
```typescript
Response: {
  message: string;
}
```

### GET /policies/:id/versions
Get policy version history
```typescript
Response: PolicyVersion[]
```

### POST /policies/:id/versions
Create new policy version
```typescript
Request: {
  version: string;
  content: string;
  changeSummary: string;
  effectiveDate: string;
}

Response: PolicyVersion
```

### GET /policies/:id/citations
Get policy citations (where used)
```typescript
Response: {
  cases: Case[];
  decisions: Decision[];
  count: number;
}
```

### POST /policies/:id/test
Test policy against case scenario
```typescript
Request: {
  scenarioData: any;
}

Response: {
  applicable: boolean;
  violations: string[];
  recommendations: string[];
}
```

### GET /policies/search
Search policies by keyword
```typescript
Query: {
  query: string;
  jurisdiction?: string;
  topic?: string;
}

Response: Policy[]
```

---

## Analytics Endpoints

### GET /analytics/dashboard
Get dashboard analytics
```typescript
Query: {
  timeRange?: 'today' | 'week' | 'month' | 'quarter' | 'year';
}

Response: {
  totalCases: number;
  openCases: number;
  slaAtRisk: number;
  highRiskDecisions: number;
  docQuality: number;
  caseVolumeTrend: Array<{date: string; created: number; resolved: number}>;
  decisionModeDistribution: Array<{mode: string; count: number}>;
  riskDistribution: Array<{level: string; count: number}>;
  complianceScore: number;
}
```

### GET /analytics/cases
Get case analytics
```typescript
Query: {
  startDate?: string;
  endDate?: string;
  department?: string;
  type?: string;
}

Response: {
  volumeOverTime: Array<{period: string; count: number}>;
  byType: Array<{type: string; count: number}>;
  byDepartment: Array<{department: string; count: number}>;
  averageResolutionTime: number;
  resolutionTimeByType: Array<{type: string; days: number}>;
  slaCompliance: number;
}
```

### GET /analytics/employees
Get employee analytics
```typescript
Query: {
  department?: string;
}

Response: {
  totalEmployees: number;
  activeEmployees: number;
  averageTenure: number;
  retentionRate: number;
  turnoverRate: number;
  byDepartment: Array<{department: string; count: number}>;
  performanceDistribution: Array<{range: string; count: number}>;
}
```

### GET /analytics/decisions
Get decision analytics
```typescript
Query: {
  startDate?: string;
  endDate?: string;
}

Response: {
  totalDecisions: number;
  byMode: Array<{mode: string; count: number}>;
  byPersona: Array<{persona: string; count: number}>;
  approvalRate: number;
  overrideRate: number;
  averageConfidenceScore: number;
}
```

### GET /analytics/sla
Get SLA analytics
```typescript
Query: {
  startDate?: string;
  endDate?: string;
}

Response: {
  complianceRate: number;
  onTimeCases: number;
  atRiskCases: number;
  overdueCases: number;
  complianceTrend: Array<{period: string; rate: number}>;
  byType: Array<{type: string; compliance: number}>;
}
```

### GET /analytics/governance
Get governance analytics
```typescript
Response: {
  totalDecisions: number;
  auditedDecisions: number;
  policyViolations: number;
  unauthorizedActions: number;
  trustScore: number;
  aiPersonaPerformance: Array<{persona: string; confidence: number; accuracy: number}>;
}
```

### GET /analytics/export
Export analytics report
```typescript
Query: {
  reportType: string;
  startDate?: string;
  endDate?: string;
  format?: 'csv' | 'xlsx' | 'pdf';
}

Response: File
```

---

## Governance Endpoints

### GET /governance/decisions
Get decision registry
```typescript
Query: {
  page?: number;
  limit?: number;
  mode?: string;
  persona?: string;
  status?: string;
}

Response: {
  decisions: Decision[];
  pagination: PaginationMeta;
}
```

### GET /governance/audit-logs
Get audit logs
```typescript
Query: {
  page?: number;
  limit?: number;
  userId?: string;
  entityType?: string;
  action?: string;
  startDate?: string;
  endDate?: string;
}

Response: {
  logs: AuditLog[];
  pagination: PaginationMeta;
}
```

### GET /governance/authority-matrix
Get authority matrix
```typescript
Query: {
  role?: string;
}

Response: AuthorityMatrixEntry[]
```

### POST /governance/authority-matrix
Create authority matrix entry
```typescript
Request: {
  role: string;
  actionType: string;
  riskLevel?: string;
  requiresApproval?: boolean;
  approvalRole?: string;
  conditions?: any;
}

Response: AuthorityMatrixEntry
```

### PUT /governance/authority-matrix/:id
Update authority matrix entry
```typescript
Request: Partial<AuthorityMatrixEntry>

Response: AuthorityMatrixEntry
```

### DELETE /governance/authority-matrix/:id
Delete authority matrix entry
```typescript
Response: {
  message: string;
}
```

### POST /governance/check-authority
Check user authority for action
```typescript
Request: {
  userId: string;
  action: string;
  riskLevel?: string;
  context?: any;
}

Response: {
  authorized: boolean;
  requiresApproval: boolean;
  approvalRole?: string;
  reason?: string;
}
```

### GET /governance/outcome-review
Get outcomes requiring review
```typescript
Query: {
  status?: string;
}

Response: {
  decisions: Decision[];
  count: number;
}
```

### POST /governance/outcome-review/:decisionId
Submit outcome review
```typescript
Request: {
  outcome: string;
  effectiveness: number;
  trustAdjustment?: 'increase' | 'decrease' | 'maintain';
  notes?: string;
}

Response: {
  message: string;
}
```

### GET /governance/ai-personas
Get AI persona configurations
```typescript
Response: AIPersonaConfig[]
```

### GET /governance/ai-personas/:type
Get specific AI persona config
```typescript
Response: AIPersonaConfig
```

### PUT /governance/ai-personas/:type
Update AI persona config
```typescript
Request: Partial<AIPersonaConfig>

Response: AIPersonaConfig
```

---

## Notification Endpoints

### GET /notifications
Get user notifications
```typescript
Query: {
  page?: number;
  limit?: number;
  read?: boolean;
  type?: string;
  priority?: string;
}

Response: {
  notifications: Notification[];
  pagination: PaginationMeta;
  unreadCount: number;
}
```

### GET /notifications/:id
Get notification by ID
```typescript
Response: Notification
```

### PUT /notifications/:id/read
Mark notification as read
```typescript
Response: Notification
```

### PUT /notifications/mark-all-read
Mark all notifications as read
```typescript
Response: {
  message: string;
  count: number;
}
```

### DELETE /notifications/:id
Delete notification
```typescript
Response: {
  message: string;
}
```

### GET /notifications/unread-count
Get unread notification count
```typescript
Response: {
  count: number;
}
```

### POST /notifications/test
Send test notification (admin only)
```typescript
Request: {
  userId: string;
  type: string;
  title: string;
  message: string;
}

Response: Notification
```

---

## Task Endpoints

### GET /tasks
Get tasks
```typescript
Query: {
  page?: number;
  limit?: number;
  assignedTo?: string;
  status?: string;
  priority?: string;
  entityType?: string;
}

Response: {
  tasks: Task[];
  pagination: PaginationMeta;
}
```

### GET /tasks/my-tasks
Get current user's tasks
```typescript
Query: {
  status?: string;
  priority?: string;
}

Response: Task[]
```

### GET /tasks/:id
Get task by ID
```typescript
Response: Task
```

### POST /tasks
Create new task
```typescript
Request: {
  title: string;
  description?: string;
  assignedTo?: string;
  dueDate?: string;
  priority?: string;
  entityType?: string;
  entityId?: string;
}

Response: Task
```

### PUT /tasks/:id
Update task
```typescript
Request: Partial<Task>

Response: Task
```

### POST /tasks/:id/complete
Mark task as completed
```typescript
Response: Task
```

### DELETE /tasks/:id
Delete task
```typescript
Response: {
  message: string;
}
```

---

## Onboarding Endpoints

### GET /onboarding
Get all onboarding workflows
```typescript
Query: {
  status?: string;
  page?: number;
  limit?: number;
}

Response: {
  workflows: OnboardingWorkflow[];
  pagination: PaginationMeta;
}
```

### GET /onboarding/:id
Get onboarding workflow by ID
```typescript
Response: {
  workflow: OnboardingWorkflow;
  employee: Employee;
  tasks: OnboardingTask[];
  progress: number;
}
```

### POST /onboarding
Create onboarding workflow
```typescript
Request: {
  employeeId: string;
  workflowTemplate: string;
  startDate?: string;
  assignedBuddy?: string;
}

Response: OnboardingWorkflow
```

### PUT /onboarding/:id
Update onboarding workflow
```typescript
Request: Partial<OnboardingWorkflow>

Response: OnboardingWorkflow
```

### DELETE /onboarding/:id
Delete onboarding workflow
```typescript
Response: {
  message: string;
}
```

### GET /onboarding/:id/tasks
Get onboarding tasks
```typescript
Response: OnboardingTask[]
```

### POST /onboarding/:id/tasks
Create onboarding task
```typescript
Request: {
  title: string;
  description?: string;
  taskType?: string;
  assignedTo?: string;
  dueDays?: number;
}

Response: OnboardingTask
```

### PUT /onboarding/:id/tasks/:taskId
Update onboarding task
```typescript
Request: Partial<OnboardingTask>

Response: OnboardingTask
```

### POST /onboarding/:id/tasks/:taskId/complete
Mark onboarding task as complete
```typescript
Response: OnboardingTask
```

---

## Integration Endpoints

### GET /integrations
Get all integrations
```typescript
Response: Integration[]
```

### GET /integrations/:id
Get integration by ID
```typescript
Response: Integration
```

### POST /integrations
Create new integration
```typescript
Request: {
  name: string;
  type: string;
  config: any;
  syncFrequency?: string;
}

Response: Integration
```

### PUT /integrations/:id
Update integration
```typescript
Request: Partial<Integration>

Response: Integration
```

### DELETE /integrations/:id
Delete integration
```typescript
Response: {
  message: string;
}
```

### POST /integrations/:id/test
Test integration connection
```typescript
Response: {
  success: boolean;
  message: string;
}
```

### POST /integrations/:id/sync
Trigger integration sync
```typescript
Response: {
  message: string;
  syncId: string;
}
```

### GET /integrations/:id/sync-status
Get integration sync status
```typescript
Response: {
  status: string;
  lastSync: string;
  nextSync?: string;
  errorMessage?: string;
}
```

---

## Settings Endpoints

### GET /settings
Get all settings
```typescript
Query: {
  category?: string;
  publicOnly?: boolean;
}

Response: Setting[]
```

### GET /settings/:category/:key
Get specific setting
```typescript
Response: Setting
```

### PUT /settings/:category/:key
Update setting (admin only)
```typescript
Request: {
  value: any;
  description?: string;
}

Response: Setting
```

### POST /settings
Create new setting (admin only)
```typescript
Request: {
  category: string;
  key: string;
  value: any;
  description?: string;
  isPublic?: boolean;
}

Response: Setting
```

### DELETE /settings/:category/:key
Delete setting (admin only)
```typescript
Response: {
  message: string;
}
```

---

## Activity Endpoints

### GET /activities
Get activities feed
```typescript
Query: {
  page?: number;
  limit?: number;
  type?: string;
  userId?: string;
  entityType?: string;
}

Response: {
  activities: Activity[];
  pagination: PaginationMeta;
}
```

### GET /activities/recent
Get recent activities (dashboard)
```typescript
Query: {
  limit?: number;
  type?: string;
}

Response: Activity[]
```

---

## File Upload Endpoints

### POST /files/upload
Upload file
```typescript
Request: FormData {
  file: File;
  entityType?: string;
  entityId?: string;
  category?: string;
}

Response: {
  id: string;
  fileName: string;
  fileUrl: string;
  fileSize: number;
  mimeType: string;
}
```

### GET /files/:id
Get file metadata
```typescript
Response: FileMetadata
```

### GET /files/:id/download
Download file
```typescript
Response: File
```

### DELETE /files/:id
Delete file
```typescript
Response: {
  message: string;
}
```

---

## WebSocket Events

### Connection
```typescript
// Client connects
socket.io.connect('/api/v1/ws', {
  auth: {
    token: 'jwt_access_token'
  }
});

// Server confirms connection
socket.emit('connected', { userId: string });
```

### Notifications
```typescript
// Server sends notification
socket.emit('notification:new', {
  id: string;
  type: string;
  title: string;
  message: string;
  priority: string;
  data: any;
});

// Client acknowledges
socket.emit('notification:read', { notificationId: string });
```

### Case Updates
```typescript
// Case assigned
socket.emit('case:assigned', {
  caseId: string;
  caseNumber: string;
  assignedTo: string;
});

// Case status changed
socket.emit('case:status-changed', {
  caseId: string;
  caseNumber: string;
  status: string;
  changedBy: string;
});

// SLA warning
socket.emit('case:sla-warning', {
  caseId: string;
  caseNumber: string;
  hoursRemaining: number;
});
```

### Decision Updates
```typescript
// Decision pending approval
socket.emit('decision:pending', {
  decisionId: string;
  caseId: string;
  approverId: string;
});

// Decision approved/rejected
socket.emit('decision:status-changed', {
  decisionId: string;
  status: string;
  approver: string;
});
```

### Real-time Metrics
```typescript
// Dashboard metrics update
socket.emit('metrics:update', {
  openCases: number;
  slaAtRisk: number;
  highRiskDecisions: number;
});
```

---

## Error Responses

All endpoints return standardized error responses:

```typescript
{
  error: {
    code: string; // 'VALIDATION_ERROR', 'UNAUTHORIZED', 'NOT_FOUND', etc.
    message: string;
    details?: any;
  }
}
```

### HTTP Status Codes
- 200: Success
- 201: Created
- 204: No Content
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 409: Conflict
- 422: Validation Error
- 500: Internal Server Error

---

## Pagination Meta

```typescript
interface PaginationMeta {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
  hasNext: boolean;
  hasPrevious: boolean;
}
```

---

## Authentication

All endpoints (except `/auth/*`) require JWT authentication:

```
Authorization: Bearer <access_token>
```

Role-based access control (RBAC) is enforced on all endpoints based on user role.
"