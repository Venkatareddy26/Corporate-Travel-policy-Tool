# Database Schema

## PostgreSQL Database: `corporate_travel`

This is the **unified database** shared by both Employee Portal and Admin Portal.

---

## Connection Config

```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=admin
DB_NAME=corporate_travel
```

---

## Core Tables (Sequelize Managed)

### users
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'employee',  -- employee, manager, admin
  "createdAt" TIMESTAMP DEFAULT NOW(),
  "updatedAt" TIMESTAMP DEFAULT NOW()
);
```

### travels
Main trip requests table.
```sql
CREATE TABLE travels (
  id SERIAL PRIMARY KEY,
  "userId" INTEGER REFERENCES users(id),
  "employeeName" VARCHAR(255),
  destination VARCHAR(255) NOT NULL,
  purpose TEXT,
  "startDate" DATE NOT NULL,
  "endDate" DATE NOT NULL,
  budget DECIMAL(10,2),
  urgency VARCHAR(50),
  accommodation VARCHAR(255),
  status VARCHAR(50) DEFAULT 'Pending',  -- Pending, Approved, Rejected
  "createdAt" TIMESTAMP DEFAULT NOW(),
  "updatedAt" TIMESTAMP DEFAULT NOW()
);
```

---

## Admin Portal Tables

### risk_advisories
```sql
CREATE TABLE risk_advisories (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  severity VARCHAR(50) DEFAULT 'low',  -- low, moderate, high, critical
  region VARCHAR(100),
  country VARCHAR(100),
  source VARCHAR(100),
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP
);
```

### trip_timeline
```sql
CREATE TABLE trip_timeline (
  id SERIAL PRIMARY KEY,
  travel_id INTEGER REFERENCES travels(id),
  action VARCHAR(255),
  actor VARCHAR(255),
  timestamp TIMESTAMP DEFAULT NOW(),
  details TEXT
);
```

### trip_comments
```sql
CREATE TABLE trip_comments (
  id SERIAL PRIMARY KEY,
  travel_id INTEGER REFERENCES travels(id),
  user_id INTEGER REFERENCES users(id),
  comment TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## Test Users

| Email | Password | Role |
|-------|----------|------|
| admin@corp.com | admin123 | admin |
| manager@corp.com | manager123 | manager |
| employee@corp.com | employee123 | employee |

---

## Setup Commands

```bash
# Create database
psql -U postgres -c "CREATE DATABASE corporate_travel;"

# Seed test users
cd Corporate-Travel-policy-Tool/Travel_backend
node seed.js

# Run admin tables migration (optional)
psql -U postgres -d corporate_travel -f db/admin_tables.sql
```

---

## Useful Queries

```sql
-- Get all trips with stats
SELECT 
  COUNT(*) as total,
  COUNT(CASE WHEN LOWER(status) = 'approved' THEN 1 END) as approved,
  COUNT(CASE WHEN LOWER(status) = 'pending' THEN 1 END) as pending
FROM travels;

-- Get trips by user
SELECT * FROM travels WHERE "userId" = 1 ORDER BY "createdAt" DESC;
```
