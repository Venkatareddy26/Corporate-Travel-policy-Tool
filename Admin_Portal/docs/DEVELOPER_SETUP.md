# Developer Setup Guide - Admin Portal

## Architecture

The Admin Portal connects to the **unified backend** shared with the Employee Portal.

```
Admin Portal (5173) ──┐
                      ├──► Unified Backend (5000) ──► corporate_travel DB
Employee Portal (3000)┘
```

---

## Prerequisites

- **Node.js** v18+ 
- **PostgreSQL** v14+
- **npm** or **yarn**

---

## Quick Start

### 1. Start the Unified Backend

```bash
# Navigate to backend
cd Corporate-Travel-policy-Tool/Travel_backend

# Install dependencies (if not done)
npm install

# Start backend server
npm start
```

Backend runs at: http://localhost:5000

### 2. Start the Admin Portal Frontend

```bash
# Navigate to admin frontend
cd ad/project/Frontend

# Install dependencies (if not done)
npm install

# Start development server
npm run dev
```

Frontend runs at: http://localhost:5173

---

## Environment Configuration

### Admin Portal Frontend (`Frontend/.env.local`)
```env
VITE_API_URL=http://localhost:5000
```

### Unified Backend (`Travel_backend/.env`)
```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=admin
DB_NAME=corporate_travel
PORT=5000
JWT_SECRET=corporateTravelAuthSecret2025
```

---

## Test Credentials

| Email | Password | Role |
|-------|----------|------|
| admin@corp.com | admin123 | admin |
| manager@corp.com | manager123 | manager |
| employee@corp.com | employee123 | employee |

---

## Project Structure

```
ad/project/
├── Frontend/
│   ├── src/
│   │   ├── components/        # Reusable UI components
│   │   ├── pages/             # Page components
│   │   ├── services/          # API services
│   │   └── styles/            # CSS files
│   ├── .env.local             # API URL config
│   └── package.json
│
└── docs/                      # Documentation

Corporate-Travel-policy-Tool/
├── Travel_backend/            # UNIFIED BACKEND (shared)
│   ├── controllers/
│   ├── routes/
│   ├── modules/               # Sequelize models
│   ├── config/
│   └── .env
│
└── Travel_frontend/           # Employee Portal
```

---

## API Endpoints Used by Admin Portal

| Endpoint | Description |
|----------|-------------|
| POST /api/auth/login | User authentication |
| GET /api/kpi | Dashboard KPIs |
| GET /api/trips | All trip requests |
| PATCH /api/travel/:id/status | Approve/reject trips |
| GET /api/risk | Risk advisories |
| GET /api/analytics | Analytics data |

---

## Troubleshooting

**"Network Error" or CORS issues:**
- Ensure backend is running on port 5000
- Check `VITE_API_URL` in `.env.local`

**Login fails:**
- Run seed script: `node Travel_backend/seed.js`
- Check credentials match seeded users

**Dashboard shows 0 trips:**
- Verify backend returns data: `curl http://localhost:5000/api/kpi`
- Check browser console for errors
- Ensure auth token is valid
