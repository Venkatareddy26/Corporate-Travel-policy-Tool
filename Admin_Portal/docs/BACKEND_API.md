# Backend API Documentation

## Overview

The Admin Portal uses the **unified backend** at `Corporate-Travel-policy-Tool/Travel_backend`.

**Base URL:** `http://localhost:5000/api`

---

## Authentication

### POST `/auth/login`
Authenticate user.

**Request:**
```json
{ "email": "admin@corp.com", "password": "admin123" }
```

**Response:**
```json
{
  "token": "jwt_token_here",
  "user": { "id": 1, "name": "Admin User", "email": "admin@corp.com", "role": "admin" }
}
```

### POST `/auth/register`
Register new user.

### GET `/auth/me`
Get current user (requires auth header).

---

## Trips

### GET `/trips`
Get all trips (admin view).

**Headers:** `Authorization: Bearer <token>`

**Response:**
```json
{
  "success": true,
  "trips": [{
    "id": 1,
    "destination": "New York",
    "start": "2024-12-15",
    "end": "2024-12-20",
    "status": "pending",
    "requester": "John Doe",
    "department": "Engineering",
    "purpose": "Client meeting",
    "costEstimate": 2500,
    "riskLevel": "Low"
  }]
}
```

### PATCH `/travel/:id/status`
Update trip status (approve/reject).

**Request:**
```json
{ "status": "approved" }
```

### DELETE `/travel/:id`
Delete a trip.

---

## KPI Dashboard

### GET `/kpi?range=30d`
Get dashboard KPIs.

**Query Params:** `range` - 7d | 30d | 90d | 365d

**Response:**
```json
{
  "success": true,
  "kpis": {
    "total_trips": 3,
    "trips_count": 3,
    "approved_trips": 1,
    "pending_trips": 2,
    "rejected_trips": 0,
    "distinct_travelers": 1,
    "destinations_count": 3,
    "total_budget": 8523,
    "total_spend": 0,
    "approval_rate": 33
  }
}
```

---

## Analytics

### GET `/analytics`
Get detailed analytics.

**Response:**
```json
{
  "success": true,
  "trips": [...],
  "monthlyTrend": [...],
  "destinations": [...]
}
```

---

## Risk Management

### GET `/risk`
Get risk alerts/advisories.

---

## Error Responses

```json
{
  "success": false,
  "error": "Error message"
}
```

**Status Codes:**
- 200: Success
- 400: Bad Request
- 401: Unauthorized
- 404: Not Found
- 500: Server Error
