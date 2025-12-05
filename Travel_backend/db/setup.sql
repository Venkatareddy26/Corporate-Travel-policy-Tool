-- Corporate Travel Management System - Database Setup with Sample Data
-- Run: psql -U postgres -d corporate_travel -f setup.sql

-- Create ENUM types (ignore if exists)
DO $$ BEGIN CREATE TYPE user_role AS ENUM ('employee', 'manager', 'admin'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE travel_status AS ENUM ('pending', 'approved', 'rejected'); EXCEPTION WHEN duplicate_object THEN null; END $$;

-- Users Table
CREATE TABLE IF NOT EXISTS "Users" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'employee',
    department VARCHAR(255),
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Policies Table
CREATE TABLE IF NOT EXISTS "Policies" (
    id SERIAL PRIMARY KEY,
    "policyName" VARCHAR(255) NOT NULL,
    "travelPurpose" VARCHAR(255),
    "bookingRules" JSON,
    "safetyRules" JSON,
    "expenseRules" JSON,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Travels Table
CREATE TABLE IF NOT EXISTS "Travels" (
    id SERIAL PRIMARY KEY,
    "userId" INTEGER REFERENCES "Users"(id) ON DELETE SET NULL,
    "employeeName" VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    purpose VARCHAR(255) NOT NULL,
    "startDate" DATE NOT NULL,
    "endDate" DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    budget DECIMAL(10,2),
    "policyId" INTEGER REFERENCES "Policies"(id) ON DELETE SET NULL,
    "emergencyContact" VARCHAR(255),
    "insuranceVerified" BOOLEAN DEFAULT FALSE,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trips Table (Admin Portal)
CREATE TABLE IF NOT EXISTS "Trips" (
    id SERIAL PRIMARY KEY,
    "userId" INTEGER REFERENCES "Users"(id) ON DELETE SET NULL,
    "employeeName" VARCHAR(255),
    destination VARCHAR(255) NOT NULL,
    purpose TEXT,
    "startDate" DATE NOT NULL,
    "endDate" DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    budget DECIMAL(10,2),
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Approvals Table
CREATE TABLE IF NOT EXISTS "Approvals" (
    id SERIAL PRIMARY KEY,
    "travelId" INTEGER REFERENCES "Travels"(id) ON DELETE CASCADE,
    "approverId" INTEGER REFERENCES "Users"(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'pending',
    comments TEXT,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Documents Table
CREATE TABLE IF NOT EXISTS "Documents" (
    id SERIAL PRIMARY KEY,
    "travelId" INTEGER REFERENCES "Travels"(id) ON DELETE CASCADE,
    type VARCHAR(255) NOT NULL,
    "fileUrl" VARCHAR(255) NOT NULL,
    "expiryDate" DATE,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Alerts Table
CREATE TABLE IF NOT EXISTS "Alerts" (
    id SERIAL PRIMARY KEY,
    "travelId" INTEGER REFERENCES "Travels"(id) ON DELETE CASCADE,
    "alertType" VARCHAR(255) NOT NULL,
    message VARCHAR(255) NOT NULL,
    notified BOOLEAN DEFAULT FALSE,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_travels_userid ON "Travels"("userId");
CREATE INDEX IF NOT EXISTS idx_travels_status ON "Travels"(status);
CREATE INDEX IF NOT EXISTS idx_trips_userid ON "Trips"("userId");
CREATE INDEX IF NOT EXISTS idx_trips_status ON "Trips"(status);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Clear existing data (optional - comment out if you want to keep existing data)
TRUNCATE "Alerts", "Documents", "Approvals", "Trips", "Travels", "Policies", "Users" RESTART IDENTITY CASCADE;

-- Insert Users (passwords are bcrypt hashed)
-- admin123, manager123, employee123
INSERT INTO "Users" (name, email, password, role, department, "createdAt", "updatedAt") VALUES
('Super Admin', 'admin@corp.com', '$2b$10$YumZRnlV1lcgTIup/mIAruopk/9lu7S.VYX5f/I5e111TLVdEuTGe', 'admin', 'HR', NOW(), NOW()),
('John Manager', 'manager@corp.com', '$2b$10$qVsFU1zggBaw7LIK3/Njju56wGu9k2IasgfNLFs8ZzLAyyLXSqtFy', 'manager', 'Sales', NOW(), NOW()),
('Emily Employee', 'employee@corp.com', '$2b$10$mOrolyMTED6F5MWsdtNTyO24KZVRanCAZ1gX8tFEsmJvKPx4kxc7m', 'employee', 'Marketing', NOW(), NOW()),
('Alice Tester', 'alice@corp.com', '$2b$10$84eZ771.yBrfumRWiJkiBOaaN0VsvLgZxQXV/mPkqv8uUfxU.HlmG', 'employee', 'QA', NOW(), NOW()),
('Bob Developer', 'bob@corp.com', '$2b$10$mOrolyMTED6F5MWsdtNTyO24KZVRanCAZ1gX8tFEsmJvKPx4kxc7m', 'employee', 'Engineering', NOW(), NOW());

-- Insert Policies
INSERT INTO "Policies" ("policyName", "travelPurpose", "bookingRules", "safetyRules", "expenseRules", "createdAt", "updatedAt") VALUES
('Default Travel Policy', 'Business', '{"class":"Economy","advanceBookingDays":14}', '{"insurance":true,"riskAssessment":true}', '{"perDiem":50,"receiptDeadlineDays":7}', NOW(), NOW()),
('International Travel Policy', 'Client Meeting', '{"class":"Business","advanceBookingDays":21}', '{"insurance":true,"riskAssessment":true}', '{"perDiem":100,"receiptDeadlineDays":7}', NOW(), NOW()),
('Executive Travel Policy', 'Conference', '{"class":"Business","advanceBookingDays":7}', '{"insurance":true,"riskAssessment":true}', '{"perDiem":150,"receiptDeadlineDays":14}', NOW(), NOW());

-- Insert Travels
INSERT INTO "Travels" ("userId", "employeeName", destination, purpose, "startDate", "endDate", status, budget, "policyId", "emergencyContact", "insuranceVerified", "createdAt", "updatedAt") VALUES
(3, 'Emily Employee', 'New York', 'Client Meeting', '2025-12-15', '2025-12-18', 'approved', 5000.00, 1, '+1-555-0123', true, NOW(), NOW()),
(3, 'Emily Employee', 'London', 'Conference', '2025-12-20', '2025-12-25', 'pending', 8000.00, 2, '+1-555-0123', false, NOW(), NOW()),
(4, 'Alice Tester', 'San Francisco', 'Training', '2025-12-10', '2025-12-12', 'approved', 3000.00, 1, '+1-555-0456', true, NOW(), NOW()),
(5, 'Bob Developer', 'Tokyo', 'Tech Summit', '2026-01-05', '2026-01-10', 'pending', 12000.00, 2, '+1-555-0789', false, NOW(), NOW()),
(3, 'Emily Employee', 'Chicago', 'Sales Meeting', '2025-12-28', '2025-12-30', 'rejected', 2500.00, 1, '+1-555-0123', false, NOW(), NOW());

-- Insert Trips (Admin Portal)
INSERT INTO "Trips" ("userId", "employeeName", destination, purpose, "startDate", "endDate", status, budget, "createdAt", "updatedAt") VALUES
(3, 'Emily Employee', 'New York', 'Client Meeting', '2025-12-15', '2025-12-18', 'approved', 5000.00, NOW(), NOW()),
(3, 'Emily Employee', 'London', 'Conference', '2025-12-20', '2025-12-25', 'pending', 8000.00, NOW(), NOW()),
(4, 'Alice Tester', 'San Francisco', 'Training', '2025-12-10', '2025-12-12', 'approved', 3000.00, NOW(), NOW()),
(5, 'Bob Developer', 'Tokyo', 'Tech Summit', '2026-01-05', '2026-01-10', 'pending', 12000.00, NOW(), NOW()),
(3, 'Emily Employee', 'Chicago', 'Sales Meeting', '2025-12-28', '2025-12-30', 'rejected', 2500.00, NOW(), NOW());

-- Insert Approvals
INSERT INTO "Approvals" ("travelId", "approverId", status, comments, "createdAt", "updatedAt") VALUES
(1, 2, 'approved', 'Budget approved. Safe travels!', NOW(), NOW()),
(3, 2, 'approved', 'Training approved.', NOW(), NOW()),
(5, 1, 'rejected', 'Budget exceeded for this quarter.', NOW(), NOW());

-- Insert Documents
INSERT INTO "Documents" ("travelId", type, "fileUrl", "expiryDate", "createdAt", "updatedAt") VALUES
(1, 'passport', '/uploads/passport_emily.pdf', '2030-05-20', NOW(), NOW()),
(1, 'visa', '/uploads/visa_usa.pdf', '2026-12-31', NOW(), NOW()),
(3, 'passport', '/uploads/passport_alice.pdf', '2029-08-15', NOW(), NOW());

-- Insert Alerts
INSERT INTO "Alerts" ("travelId", "alertType", message, notified, "createdAt", "updatedAt") VALUES
(2, 'Pending Approval', 'Trip to London awaiting manager approval', false, NOW(), NOW()),
(4, 'Pending Approval', 'Trip to Tokyo awaiting manager approval', false, NOW(), NOW()),
(1, 'Upcoming Trip', 'Trip to New York starts in 10 days', false, NOW(), NOW());

-- =====================================================
-- VERIFICATION
-- =====================================================
SELECT 'Database setup complete!' as status;
SELECT 'Users: ' || COUNT(*) FROM "Users";
SELECT 'Policies: ' || COUNT(*) FROM "Policies";
SELECT 'Travels: ' || COUNT(*) FROM "Travels";
SELECT 'Trips: ' || COUNT(*) FROM "Trips";
SELECT 'Approvals: ' || COUNT(*) FROM "Approvals";
SELECT 'Documents: ' || COUNT(*) FROM "Documents";
SELECT 'Alerts: ' || COUNT(*) FROM "Alerts";

-- Test Credentials:
-- admin@corp.com / admin123 (Admin)
-- manager@corp.com / manager123 (Manager)  
-- employee@corp.com / employee123 (Employee)
-- alice@corp.com / employee123 (Employee)
-- bob@corp.com / employee123 (Employee)
