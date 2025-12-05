-- Corporate Travel Management System - Database Setup
-- Run this script to create the database and initial schema
-- Usage: psql -U postgres -f setup.sql

-- Create database (run as postgres superuser)
-- DROP DATABASE IF EXISTS corporate_travel;
-- CREATE DATABASE corporate_travel;

-- Connect to the database
\c corporate_travel;

-- Create ENUM types
DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('employee', 'manager', 'admin');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE travel_status AS ENUM ('pending', 'approved', 'rejected');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

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

-- Trips Table (Admin Portal compatible)
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

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_travels_userid ON "Travels"("userId");
CREATE INDEX IF NOT EXISTS idx_travels_status ON "Travels"(status);
CREATE INDEX IF NOT EXISTS idx_trips_userid ON "Trips"("userId");
CREATE INDEX IF NOT EXISTS idx_trips_status ON "Trips"(status);

-- Note: Run 'node seed.js' in Travel_backend folder to create test users
-- Test credentials after seeding:
--   admin@corp.com / admin123 (Admin)
--   manager@corp.com / manager123 (Manager)
--   employee@corp.com / employee123 (Employee)

SELECT 'Database setup complete!' as status;
