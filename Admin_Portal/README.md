# Admin Portal - Corporate Travel Management System

A React-based admin dashboard for managing corporate travel requests, integrated with the Employee Portal via a unified backend.

![Dashboard](https://img.shields.io/badge/Status-Active-brightgreen) ![React](https://img.shields.io/badge/React-18-blue) ![Vite](https://img.shields.io/badge/Vite-5-purple)

## 🏗️ Architecture

```
Employee Portal (3000) ──┐
                         ├──► Unified Backend (5000) ──► corporate_travel DB
Admin Portal (5173) ─────┘
```

Both portals share the same backend and database for seamless data flow.

## ✨ Features

- 📊 **KPI Dashboard** - Real-time metrics (trips, travelers, spend)
- ✈️ **Trip Management** - Approve/reject employee travel requests
- 💰 **Expense Tracking** - View and manage travel expenses
- ⚠️ **Risk Management** - Travel advisories and safety alerts
- 📋 **Policy Management** - Create and manage travel policies
- 📄 **Document Management** - Upload and manage travel documents
- 🗺️ **Global Map** - Interactive map showing travel destinations
- 🎨 **Theme Support** - Multiple color themes

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | React 18, Vite, Tailwind CSS, Recharts, Leaflet |
| Backend | Node.js, Express.js (shared with Employee Portal) |
| Database | PostgreSQL (`corporate_travel`) |
| Real-time | Socket.IO |

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- PostgreSQL 15+
- Unified Backend running (see below)

### 1. Start the Unified Backend

```bash
cd Corporate-Travel-policy-Tool/Travel_backend
npm install
npm start  # Runs on http://localhost:5000
```

### 2. Start the Admin Portal

```bash
cd ad/project/Frontend
npm install
npm run dev  # Runs on http://localhost:5173
```

### 3. (Optional) Start Employee Portal

```bash
cd Corporate-Travel-policy-Tool/Travel_frontend
npm install
npm start  # Runs on http://localhost:3000
```

## 🔧 Configuration

### Frontend (`Frontend/.env.local`)
```env
VITE_API_URL=http://localhost:5000
```

### Backend (`Travel_backend/.env`)
```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=admin
DB_NAME=corporate_travel
PORT=5000
JWT_SECRET=corporateTravelAuthSecret2025
```

## 🔑 Test Credentials

| Email | Password | Role |
|-------|----------|------|
| admin@corp.com | admin123 | admin |
| manager@corp.com | manager123 | manager |
| employee@corp.com | employee123 | employee |

## 📡 API Endpoints

All endpoints served by the unified backend at `http://localhost:5000/api`

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/login` | User login |
| GET | `/kpi` | Dashboard KPIs |
| GET | `/trips` | All trip requests |
| PATCH | `/travel/:id/status` | Approve/reject trip |
| GET | `/analytics` | Analytics data |
| GET | `/risk` | Risk advisories |

## 📁 Project Structure

```
ad/project/
├── Frontend/
│   ├── src/
│   │   ├── components/     # Reusable UI components
│   │   ├── pages/          # Page components
│   │   ├── services/       # API services
│   │   └── styles/         # CSS files
│   ├── .env.local          # API URL config
│   └── package.json
│
└── docs/
    ├── BACKEND_API.md
    ├── DATABASE_SCHEMA.md
    ├── DEVELOPER_SETUP.md
    └── FRONTEND_GUIDE.md
```

## 🔄 Data Flow

1. **Employee creates trip** → Employee Portal → Backend → Database
2. **Admin views trips** → Admin Portal → Backend → Same Database
3. **Admin approves** → Backend updates → Socket.IO notifies Employee

## 📚 Documentation

- [Developer Setup](docs/DEVELOPER_SETUP.md)
- [Backend API](docs/BACKEND_API.md)
- [Frontend Guide](docs/FRONTEND_GUIDE.md)
- [Database Schema](docs/DATABASE_SCHEMA.md)

## 📄 License

MIT
