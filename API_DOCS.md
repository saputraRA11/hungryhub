# Authentication API Documentation

Base URL: `http://localhost:3000/api/v1`

## 1. Register a New User

**Endpoint:** `POST /api/v1/auth/register`

- **Content-Type:** `application/json`
- **Body:**
  - `email` (string, required)
  - `password` (string, required)

### cURL Example:
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "Password123!"
  }'
```

### Success Response (201 Created):
```json
{
  "status_code": 201,
  "messages": "Created",
  "data": {
    "email": "user@example.com",
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

---

## 2. Login

**Endpoint:** `POST /api/v1/auth/login`

- **Content-Type:** `application/json`
- **Body:**
  - `email` (string, required)
  - `password` (string, required)

### cURL Example:
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "Password123!"
  }'
```

### Success Response (200 OK):
```json
{
  "status_code": 200,
  "messages": "OK",
  "data": {
    "email": "user@example.com",
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

### Error Response (401 Unauthorized):
```json
{
  "status_code": 401,
  "messages": [
    "Authentication failed",
    "Invalid email or password"
  ],
  "data": null
}
```

---

## 3. Authenticated Requests

For endpoints that require authentication (any controller that includes `Authenticatable`), you must pass the generated token in the `Authorization` header.

### cURL Example:
```bash
curl -X GET http://localhost:3000/api/v1/some_protected_route \
  -H "Authorization: Token token=YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json"
```

*Note on Authorization Format*:
Rails' `ActionController::HttpAuthentication::Token` expects the format to be `Token token="xxxx"`. If the token is passed plainly as `Bearer xxxx`, make sure your client implements it effectively or prefix it with `Token token=xxxx` as per Rails defaults.
