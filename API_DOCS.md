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

---

# Restaurants API Documentation

Base URL: `http://localhost:3000/api/v1/restaurants`

**Important:** All endpoints below require authentication. You must include the `Authorization: Token token=YOUR_JWT_TOKEN` header.

## 1. List Restaurants
**Endpoint:** `GET /`
**Description:** Retrieves a list of all restaurants.

**Query Parameters:**
- `page` (integer, optional) - Page number to retrieve. Default is `1`.
- `limit` (integer, optional) - Number of items per page. Default is `10`, maximum is `100`.

### cURL Example:
```bash
curl -X GET "http://localhost:3000/api/v1/restaurants?page=1&limit=10" \
  -H "Authorization: Token token=YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json"
```

## 2. Get a Specific Restaurant
**Endpoint:** `GET /:id`
**Description:** Retrieves details for a specific restaurant by its ID.

### cURL Example:
```bash
curl -X GET http://localhost:3000/api/v1/restaurants/1 \
  -H "Authorization: Token token=YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json"
```

### Success Response (200 OK):
```json
{
  "status_code": 200,
  "messages": [],
  "data": {
    "id": 1,
    "name": "Restaurant Name",
    "address": "123 Main St",
    "category": "main"
  }
}
```

## 3. Create a New Restaurant
**Endpoint:** `POST /`
**Description:** Creates a new restaurant.
**Body Parameters:**
- `name` (string, required)
- `address` (string, required)
- `category` (string, required) - Must be one of: `appetizer`, `main`, `dessert`, `drink`

### cURL Example:
```bash
curl -X POST http://localhost:3000/api/v1/restaurants \
  -H "Authorization: Token token=YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Hungry Hub Cafe",
    "address": "456 Food Ave",
    "category": "main"
  }'
```

## 4. Update an Existing Restaurant
**Endpoint:** `PUT /:id`
**Description:** Updates the fields of an existing restaurant.
**Body Parameters:** (all optional)
- `name` (string)
- `address` (string)
- `category` (string) - Must be one of: `appetizer`, `main`, `dessert`, `drink`

### cURL Example:
```bash
curl -X PUT http://localhost:3000/api/v1/restaurants/1 \
  -H "Authorization: Token token=YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Cafe Name"
  }'
```

## 5. Delete a Restaurant
**Endpoint:** `DELETE /:id`
**Description:** Deletes a specific restaurant by its ID.

### cURL Example:
```bash
curl -X DELETE http://localhost:3000/api/v1/restaurants/1 \
  -H "Authorization: Token token=YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json"
```
