-- PostgreSQL Database Schema for AiXWorkForce360

-- Core Tables

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    department VARCHAR(100),
    position VARCHAR(100),
    avatar_url TEXT,
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    sso_provider VARCHAR(50),
    sso_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_sso ON users(sso_provider, sso_id);

CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    revoked BOOLEAN DEFAULT false,
    revoked_at TIMESTAMP,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);

CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    position VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    manager_id UUID REFERENCES employees(id),
    location VARCHAR(255),
    hire_date DATE NOT NULL,
    termination_date DATE,
    status VARCHAR(50) DEFAULT 'active',
    performance_score INTEGER CHECK (performance_score >= 0 AND performance_score <= 100),
    work_schedule TEXT,
    employment_type VARCHAR(50),
    pay_rate DECIMAL(12, 2),
    pay_frequency VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);
CREATE INDEX idx_employees_employee_id ON employees(employee_id);
CREATE INDEX idx_employees_department ON employees(department);
CREATE INDEX idx_employees_manager ON employees(manager_id);
CREATE INDEX idx_employees_status ON employees(status);

CREATE TABLE cases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_number VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    priority VARCHAR(50) DEFAULT 'normal',
    risk_level VARCHAR(50) DEFAULT 'low',
    urgency VARCHAR(50) DEFAULT 'normal',
    jurisdiction VARCHAR(100),
    confidential BOOLEAN DEFAULT false,
    employee_id UUID REFERENCES employees(id) ON DELETE CASCADE,
    assigned_to UUID REFERENCES users(id),
    reported_by UUID REFERENCES users(id),
    sla_due_date TIMESTAMP,
    sla_status VARCHAR(50) DEFAULT 'ontime',
    hours_remaining INTEGER,
    resolution TEXT,
    resolution_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);
CREATE INDEX idx_cases_case_number ON cases(case_number);
CREATE INDEX idx_cases_employee ON cases(employee_id);
CREATE INDEX idx_cases_assigned ON cases(assigned_to);
CREATE INDEX idx_cases_status ON cases(status);
CREATE INDEX idx_cases_type ON cases(type);
CREATE INDEX idx_cases_risk ON cases(risk_level);

CREATE TABLE case_timeline (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
    event_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_data JSONB,
    user_id UUID REFERENCES users(id),
    user_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_case_timeline_case ON case_timeline(case_id);
CREATE INDEX idx_case_timeline_type ON case_timeline(event_type);
CREATE INDEX idx_case_timeline_created ON case_timeline(created_at DESC);

CREATE TABLE case_files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    file_type VARCHAR(100),
    file_size BIGINT,
    file_path TEXT NOT NULL,
    file_url TEXT,
    description TEXT,
    category VARCHAR(100),
    uploaded_by UUID REFERENCES users(id),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_case_files_case ON case_files(case_id);
CREATE INDEX idx_case_files_category ON case_files(category);

CREATE TABLE case_investigation_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id UUID NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    assigned_to UUID REFERENCES users(id),
    due_date TIMESTAMP,
    completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP,
    completed_by UUID REFERENCES users(id),
    notes TEXT,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_investigation_tasks_case ON case_investigation_tasks(case_id);
CREATE INDEX idx_investigation_tasks_assigned ON case_investigation_tasks(assigned_to);

CREATE TABLE decisions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    decision_id VARCHAR(50) UNIQUE NOT NULL,
    case_id UUID REFERENCES cases(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    decision_text TEXT NOT NULL,
    decision_mode VARCHAR(50),
    ai_persona VARCHAR(50),
    ai_recommendation TEXT,
    ai_confidence_score DECIMAL(5, 2),
    risk_assessment TEXT,
    policy_references JSONB,
    approver_id UUID REFERENCES users(id),
    approved_at TIMESTAMP,
    status VARCHAR(50) DEFAULT 'pending',
    override_reason TEXT,
    audit_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id)
);
CREATE INDEX idx_decisions_decision_id ON decisions(decision_id);
CREATE INDEX idx_decisions_case ON decisions(case_id);
CREATE INDEX idx_decisions_approver ON decisions(approver_id);
CREATE INDEX idx_decisions_status ON decisions(status);

CREATE TABLE policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    jurisdiction VARCHAR(100) NOT NULL,
    topic VARCHAR(100) NOT NULL,
    version VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    excerpt TEXT,
    effective_date DATE NOT NULL,
    expiration_date DATE,
    is_active BOOLEAN DEFAULT true,
    policy_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);
CREATE INDEX idx_policies_jurisdiction ON policies(jurisdiction);
CREATE INDEX idx_policies_topic ON policies(topic);
CREATE INDEX idx_policies_active ON policies(is_active);

CREATE TABLE policy_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    policy_id UUID NOT NULL REFERENCES policies(id) ON DELETE CASCADE,
    version VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    change_summary TEXT,
    effective_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id)
);
CREATE INDEX idx_policy_versions_policy ON policy_versions(policy_id);

CREATE TABLE policy_citations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    policy_id UUID NOT NULL REFERENCES policies(id) ON DELETE CASCADE,
    case_id UUID REFERENCES cases(id) ON DELETE SET NULL,
    decision_id UUID REFERENCES decisions(id) ON DELETE SET NULL,
    cited_section TEXT,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    applied_by UUID REFERENCES users(id)
);
CREATE INDEX idx_policy_citations_policy ON policy_citations(policy_id);
CREATE INDEX idx_policy_citations_case ON policy_citations(case_id);

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    link TEXT,
    priority VARCHAR(50) DEFAULT 'normal',
    read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(read);
CREATE INDEX idx_notifications_created ON notifications(created_at DESC);

CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(100) NOT NULL,
    status VARCHAR(50),
    entity_type VARCHAR(50),
    entity_id UUID,
    link TEXT,
    user_id UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_activities_type ON activities(type);
CREATE INDEX idx_activities_user ON activities(user_id);
CREATE INDEX idx_activities_created ON activities(created_at DESC);

CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    assigned_to UUID REFERENCES users(id),
    due_date TIMESTAMP,
    priority VARCHAR(50) DEFAULT 'medium',
    status VARCHAR(50) DEFAULT 'pending',
    completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP,
    entity_type VARCHAR(50),
    entity_id UUID,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id)
);
CREATE INDEX idx_tasks_assigned ON tasks(assigned_to);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_priority ON tasks(priority);

CREATE TABLE analytics_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    metric_type VARCHAR(100) NOT NULL,
    metric_name VARCHAR(255) NOT NULL,
    metric_value DECIMAL(12, 2),
    metric_unit VARCHAR(50),
    dimensions JSONB,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_analytics_type ON analytics_metrics(metric_type);
CREATE INDEX idx_analytics_period ON analytics_metrics(period_start, period_end);

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    user_email VARCHAR(255),
    action VARCHAR(255) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id UUID,
    entity_identifier VARCHAR(255),
    changes JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    request_method VARCHAR(10),
    request_path TEXT,
    status_code INTEGER,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_audit_user ON audit_logs(user_id);
CREATE INDEX idx_audit_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_action ON audit_logs(action);
CREATE INDEX idx_audit_created ON audit_logs(created_at DESC);

CREATE TABLE governance_authority_matrix (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role VARCHAR(50) NOT NULL,
    action_type VARCHAR(100) NOT NULL,
    risk_level VARCHAR(50),
    requires_approval BOOLEAN DEFAULT false,
    approval_role VARCHAR(50),
    conditions JSONB,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_authority_role ON governance_authority_matrix(role);
CREATE INDEX idx_authority_action ON governance_authority_matrix(action_type);

CREATE TABLE integrations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    config JSONB,
    last_sync TIMESTAMP,
    sync_frequency VARCHAR(50),
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id)
);
CREATE INDEX idx_integrations_type ON integrations(type);
CREATE INDEX idx_integrations_status ON integrations(status);

CREATE TABLE onboarding_workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    workflow_template VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    start_date DATE,
    completion_date DATE,
    progress_percentage INTEGER DEFAULT 0,
    assigned_buddy UUID REFERENCES employees(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_onboarding_employee ON onboarding_workflows(employee_id);
CREATE INDEX idx_onboarding_status ON onboarding_workflows(status);

CREATE TABLE onboarding_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workflow_id UUID NOT NULL REFERENCES onboarding_workflows(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    task_type VARCHAR(100),
    assigned_to UUID REFERENCES users(id),
    due_days INTEGER,
    completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_onboarding_tasks_workflow ON onboarding_tasks(workflow_id);

CREATE TABLE settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category VARCHAR(100) NOT NULL,
    key VARCHAR(100) NOT NULL,
    value JSONB NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID REFERENCES users(id),
    UNIQUE(category, key)
);
CREATE INDEX idx_settings_category ON settings(category);

CREATE TABLE ai_persona_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    persona_type VARCHAR(50) NOT NULL,
    version VARCHAR(20) NOT NULL,
    authority_scope JSONB,
    boundaries JSONB,
    confidence_threshold DECIMAL(5, 2),
    model_config JSONB,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID REFERENCES users(id)
);
CREATE INDEX idx_ai_persona_type ON ai_persona_configs(persona_type);

-- Relationships, Seed Data, Functions, Triggers, Indexes

-- Initial Seed Data
INSERT INTO users (email, first_name, last_name, role, is_active) VALUES ('admin@workspring.com', 'System', 'Administrator', 'admin', true);
INSERT INTO settings (category, key, value, description, is_public) VALUES
('general', 'company_name', '"AiXWorkForce360"', 'Company name', true),
('general', 'timezone', '"America/Los_Angeles"', 'Default timezone', true),
('security', 'jwt_expiry', '3600', 'JWT token expiry in seconds', false),
('security', 'refresh_token_expiry', '604800', 'Refresh token expiry in seconds', false),
('notifications', 'email_enabled', 'true', 'Enable email notifications', true),
('notifications', 'realtime_enabled', 'true', 'Enable real-time notifications', true);

-- Functions & Triggers
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = CURRENT_TIMESTAMP; RETURN NEW; END; $$ language 'plpgsql';
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON employees FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cases_updated_at BEFORE UPDATE ON cases FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_policies_updated_at BEFORE UPDATE ON policies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_decisions_updated_at BEFORE UPDATE ON decisions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE SEQUENCE case_number_seq START 2847;
CREATE OR REPLACE FUNCTION generate_case_number() RETURNS TRIGGER AS $$ BEGIN IF NEW.case_number IS NULL THEN NEW.case_number := 'CASE-' || nextval('case_number_seq'); END IF; RETURN NEW; END; $$ language 'plpgsql';
CREATE TRIGGER generate_case_number_trigger BEFORE INSERT ON cases FOR EACH ROW EXECUTE FUNCTION generate_case_number();

CREATE SEQUENCE decision_id_seq START 8470;
CREATE OR REPLACE FUNCTION generate_decision_id() RETURNS TRIGGER AS $$ BEGIN IF NEW.decision_id IS NULL THEN NEW.decision_id := 'DEC-' || nextval('decision_id_seq'); END IF; RETURN NEW; END; $$ language 'plpgsql';
CREATE TRIGGER generate_decision_id_trigger BEFORE INSERT ON decisions FOR EACH ROW EXECUTE FUNCTION generate_decision_id();

-- Additional Indexes
CREATE INDEX idx_cases_assigned_status ON cases(assigned_to, status);
CREATE INDEX idx_cases_employee_status ON cases(employee_id, status);
