# HungryHub v2 — Restaurant Menu Management API

A RESTful API for managing restaurants and their menu items, built with **Ruby on Rails 8.1** (API-only mode).

## Tech Stack

- **Ruby** 3.3.6 / **Rails** 8.1.2
- **SQLite3** — zero-config database
- **JWT** — token-based authentication
- **RSwag** — Swagger/OpenAPI documentation
- **RSpec** — test suite

## Quick Start (Local)

```bash
# Install dependencies
bundle install

# Setup database
bin/rails db:prepare
bin/rails db:seed

# Start server
bin/rails server
```

API available at `http://localhost:3000` · Swagger docs at `http://localhost:3000/api-docs`

---

## Docker

### Build & Run (standalone)

```bash
docker build -t hungryhub-v2 .
docker run -d -p 3000:3000 \
  -e RAILS_MASTER_KEY=$(cat config/master.key) \
  --name hungryhub-v2 hungryhub-v2
```

### Docker Compose (recommended)

```bash
# Create .env file with your master key
echo "RAILS_MASTER_KEY=$(cat config/master.key)" > .env

# Build and start
docker compose up --build

# Run in background
docker compose up --build -d

# Stop
docker compose down

# Stop and remove volumes (reset database)
docker compose down -v
```

App will be available at `http://localhost:3000`

---

## Deploy to Railway 🚀

### Prerequisites

1. Install Railway CLI:
   ```bash
   npm i -g @railway/cli
   ```
2. Login:
   ```bash
   railway login
   ```

### One-command deploy

```bash
bin/deploy-railway.sh
```

This will:
- Link your Railway project (or prompt to create one)
- Set all required environment variables
- Deploy using the existing Dockerfile
- Print your deployment URL

### Manual deploy

```bash
# Link to Railway project
railway link

# Set environment variables
railway variables set \
  RAILS_ENV=production \
  RAILS_MASTER_KEY=$(cat config/master.key) \
  SECRET_KEY_BASE=$(openssl rand -hex 64) \
  RAILS_LOG_TO_STDOUT=true \
  SOLID_QUEUE_IN_PUMA=true

# Deploy
railway up

# Get your URL
railway domain
```

### Useful commands

```bash
railway logs          # View logs
railway open          # Open in browser
railway variables     # View env variables
railway shell         # Open shell in container
```

---

## API Documentation

Interactive Swagger UI available at `/api-docs` after starting the server.

See [API_DOCS.md](API_DOCS.md) for a detailed endpoint reference.

## Running Tests

```bash
bundle exec rspec
```
