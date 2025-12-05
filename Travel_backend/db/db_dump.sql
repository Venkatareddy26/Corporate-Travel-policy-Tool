--
-- PostgreSQL Database Dump - Corporate Travel Management System
-- Updated: December 2025
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

-- =====================================================
-- DROP EXISTING TABLES (if any)
-- =====================================================
DROP TABLE IF EXISTS "Alerts" CASCADE;
DROP TABLE IF EXISTS "Documents" CASCADE;
DROP TABLE IF EXISTS "Approvals" CASCADE;
DROP TABLE IF EXISTS "Trips" CASCADE;
DROP TABLE IF EXISTS "Travels" CASCADE;
DROP TABLE IF EXISTS "Policies" CASCADE;
DROP TABLE IF EXISTS "Users" CASCADE;

-- =====================================================
-- CREATE TABLES
-- =====================================================

-- Users Table
CREATE TABLE "Users" (
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
CREATE TABLE "Policies" (
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
CREATE TABLE "Travels" (
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
CREATE TABLE "Trips" (
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
CREATE TABLE "Approvals" (
    id SERIAL PRIMARY KEY,
    "travelId" INTEGER REFERENCES "Travels"(id) ON DELETE CASCADE,
    "approverId" INTEGER REFERENCES "Users"(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'pending',
    comments TEXT,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Documents Table
CREATE TABLE "Documents" (
    id SERIAL PRIMARY KEY,
    "travelId" INTEGER REFERENCES "Travels"(id) ON DELETE CASCADE,
    type VARCHAR(255) NOT NULL,
    "fileUrl" VARCHAR(255) NOT NULL,
    "expiryDate" DATE,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Alerts Table
CREATE TABLE "Alerts" (
    id SERIAL PRIMARY KEY,
    "travelId" INTEGER REFERENCES "Travels"(id) ON DELETE CASCADE,
    "alertType" VARCHAR(255) NOT NULL,
    message VARCHAR(255) NOT NULL,
    notified BOOLEAN DEFAULT FALSE,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_users_email ON "Users"(email);
CREATE INDEX idx_travels_userid ON "Travels"("userId");
CREATE INDEX idx_travels_status ON "Travels"(status);
CREATE INDEX idx_trips_userid ON "Trips"("userId");
CREATE INDEX idx_trips_status ON "Trips"(status);

-- =====================================================
-- INSERT SAMPLE DATA
-- =====================================================

-- Users (passwords: admin123, manager123, employee123)
INSERT INTO "Users" (id, name, email, password, role, department, "createdAt", "updatedAt") VALUES
(1, 'Super Admin', 'admin@corp.com', '$2b$10$YumZRnlV1lcgTIup/mIAruopk/9lu7S.VYX5f/I5e111TLVdEuTGe', 'admin', 'HR', NOW(), NOW()),
(2, 'John Manager', 'manager@corp.com', '$2b$10$qVsFU1zggBaw7LIK3/Njju56wGu9k2IasgfNLFs8ZzLAyyLXSqtFy', 'manager', 'Sales', NOW(), NOW()),
(3, 'Emily Employee', 'employee@corp.com', '$2b$10$mOrolyMTED6F5MWsdtNTyO24KZVRanCAZ1gX8tFEsmJvKPx4kxc7m', 'employee', 'Marketing', NOW(), NOW()),
(4, 'Alice Tester', 'alice@corp.com', '$2b$10$mOrolyMTED6F5MWsdtNTyO24KZVRanCAZ1gX8tFEsmJvKPx4kxc7m', 'employee', 'QA', NOW(), NOW()),
(5, 'Bob Developer', 'bob@corp.com', '$2b$10$mOrolyMTED6F5MWsdtNTyO24KZVRanCAZ1gX8tFEsmJvKPx4kxc7m', 'employee', 'Engineering', NOW(), NOW());

-- Reset sequence
SELECT setval('"Users_id_seq"', 5, true);

-- Policies
INSERT INTO "Policies" (id, "policyName", "travelPurpose", "bookingRules", "safetyRules", "expenseRules", "createdAt", "updatedAt") VALUES
(1, 'Default Travel Policy', 'Business', '{"class":"Economy","advanceBookingDays":14}', '{"insurance":true,"riskAssessment":true}', '{"perDiem":50,"receiptDeadlineDays":7}', NOW(), NOW()),
(2, 'International Travel Policy', 'Client Meeting', '{"class":"Business","advanceBookingDays":21}', '{"insurance":true,"riskAssessment":true}', '{"perDiem":100,"receiptDeadlineDays":7}', NOW(), NOW()),
(3, 'Executive Travel Policy', 'Conference', '{"class":"Business","advanceBookingDays":7}', '{"insurance":true,"riskAssessment":true}', '{"perDiem":150,"receiptDeadlineDays":14}', NOW(), NOW());

SELECT setval('"Policies_id_seq"', 3, true);

-- Travels
INSERT INTO "Travels" (id, "userId", "employeeName", destination, purpose, "startDate", "endDate", status, budget, "policyId", "emergencyContact", "insuranceVerified", "createdAt", "updatedAt") VALUES
(1, 3, 'Emily Employee', 'New York', 'Client Meeting', '2025-12-15', '2025-12-18', 'approved', 5000.00, 1, '+1-555-0123', true, NOW(), NOW()),
(2, 3, 'Emily Employee', 'London', 'Conference', '2025-12-20', '2025-12-25', 'pending', 8000.00, 2, '+1-555-0123', false, NOW(), NOW()),
(3, 4, 'Alice Tester', 'San Francisco', 'Training', '2025-12-10', '2025-12-12', 'approved', 3000.00, 1, '+1-555-0456', true, NOW(), NOW()),
(4, 5, 'Bob Developer', 'Tokyo', 'Tech Summit', '2026-01-05', '2026-01-10', 'pending', 12000.00, 2, '+1-555-0789', false, NOW(), NOW()),
(5, 3, 'Emily Employee', 'Chicago', 'Sales Meeting', '2025-12-28', '2025-12-30', 'rejected', 2500.00, 1, '+1-555-0123', false, NOW(), NOW());

SELECT setval('"Travels_id_seq"', 5, true);

-- Trips (Admin Portal - same data as Travels)
INSERT INTO "Trips" (id, "userId", "employeeName", destination, purpose, "startDate", "endDate", status, budget, "createdAt", "updatedAt") VALUES
(1, 3, 'Emily Employee', 'New York', 'Client Meeting', '2025-12-15', '2025-12-18', 'approved', 5000.00, NOW(), NOW()),
(2, 3, 'Emily Employee', 'London', 'Conference', '2025-12-20', '2025-12-25', 'pending', 8000.00, NOW(), NOW()),
(3, 4, 'Alice Tester', 'San Francisco', 'Training', '2025-12-10', '2025-12-12', 'approved', 3000.00, NOW(), NOW()),
(4, 5, 'Bob Developer', 'Tokyo', 'Tech Summit', '2026-01-05', '2026-01-10', 'pending', 12000.00, NOW(), NOW()),
(5, 3, 'Emily Employee', 'Chicago', 'Sales Meeting', '2025-12-28', '2025-12-30', 'rejected', 2500.00, NOW(), NOW());

SELECT setval('"Trips_id_seq"', 5, true);

-- Approvals
INSERT INTO "Approvals" (id, "travelId", "approverId", status, comments, "createdAt", "updatedAt") VALUES
(1, 1, 2, 'approved', 'Budget approved. Safe travels!', NOW(), NOW()),
(2, 3, 2, 'approved', 'Training approved.', NOW(), NOW()),
(3, 5, 1, 'rejected', 'Budget exceeded for this quarter.', NOW(), NOW());

SELECT setval('"Approvals_id_seq"', 3, true);

-- Documents
INSERT INTO "Documents" (id, "travelId", type, "fileUrl", "expiryDate", "createdAt", "updatedAt") VALUES
(1, 1, 'passport', '/uploads/passport_emily.pdf', '2030-05-20', NOW(), NOW()),
(2, 1, 'visa', '/uploads/visa_usa.pdf', '2026-12-31', NOW(), NOW()),
(3, 3, 'passport', '/uploads/passport_alice.pdf', '2029-08-15', NOW(), NOW());

SELECT setval('"Documents_id_seq"', 3, true);

-- Alerts
INSERT INTO "Alerts" (id, "travelId", "alertType", message, notified, "createdAt", "updatedAt") VALUES
(1, 2, 'Pending Approval', 'Trip to London awaiting manager approval', false, NOW(), NOW()),
(2, 4, 'Pending Approval', 'Trip to Tokyo awaiting manager approval', false, NOW(), NOW()),
(3, 1, 'Upcoming Trip', 'Trip to New York starts in 10 days', false, NOW(), NOW());

SELECT setval('"Alerts_id_seq"', 3, true);

-- =====================================================
-- VERIFICATION
-- =====================================================
SELECT 'Database restore complete!' as status;
SELECT 'Users: ' || COUNT(*) as count FROM "Users";
SELECT 'Policies: ' || COUNT(*) as count FROM "Policies";
SELECT 'Travels: ' || COUNT(*) as count FROM "Travels";
SELECT 'Trips: ' || COUNT(*) as count FROM "Trips";
SELECT 'Approvals: ' || COUNT(*) as count FROM "Approvals";

-- =====================================================
-- TEST CREDENTIALS
-- =====================================================
-- admin@corp.com / admin123 (Admin)
-- manager@corp.com / manager123 (Manager)
-- employee@corp.com / employee123 (Employee)
-- alice@corp.com / employee123 (Employee)
-- bob@corp.com / employee123 (Employee)
