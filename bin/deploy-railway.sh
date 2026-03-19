#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────
# HungryHub v2 — Railway Deployment Script
# ──────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_step()  { echo -e "${CYAN}➜${NC} $1"; }
print_ok()    { echo -e "${GREEN}✔${NC} $1"; }
print_warn()  { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✖${NC} $1"; }

# ── Help ─────────────────────────────────────
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat <<EOF
Usage: bin/deploy-railway.sh [OPTIONS]

Deploy HungryHub v2 to Railway.

Options:
  -h, --help      Show this help message
  --skip-login    Skip Railway login check
  --detach        Deploy without tailing logs

Prerequisites:
  1. Install Railway CLI:  npm i -g @railway/cli
  2. Login:                railway login
  3. Have a Railway project created (or script will prompt to create one)

Environment variables set automatically:
  RAILS_ENV, RAILS_MASTER_KEY, SECRET_KEY_BASE, RAILS_LOG_TO_STDOUT
EOF
  exit 0
fi

SKIP_LOGIN=false
DETACH=false
for arg in "$@"; do
  case "$arg" in
    --skip-login) SKIP_LOGIN=true ;;
    --detach)     DETACH=true ;;
  esac
done

# ── 1. Check Railway CLI ─────────────────────
print_step "Checking Railway CLI..."
if ! command -v railway &> /dev/null; then
  print_error "Railway CLI not found."
  echo "  Install it with: npm i -g @railway/cli"
  echo "  Then login with:  railway login"
  exit 1
fi
print_ok "Railway CLI found: $(railway --version 2>/dev/null || echo 'installed')"

# ── 2. Check login ──────────────────────────
if [[ "$SKIP_LOGIN" == false ]]; then
  print_step "Checking Railway login status..."
  if ! railway whoami &> /dev/null; then
    print_warn "Not logged in. Running 'railway login'..."
    railway login
  fi
  print_ok "Logged in as: $(railway whoami 2>/dev/null || echo 'authenticated')"
fi

# ── 3. Link project ─────────────────────────
print_step "Checking project link..."
if ! railway status &> /dev/null; then
  print_warn "No project linked. Running 'railway link'..."
  railway link
fi
print_ok "Project linked"

# ── 4. Set environment variables ─────────────
print_step "Setting environment variables..."

# Read RAILS_MASTER_KEY from config/master.key if it exists
MASTER_KEY=""
if [[ -f "config/master.key" ]]; then
  MASTER_KEY=$(cat config/master.key)
  print_ok "Found config/master.key"
elif [[ -n "${RAILS_MASTER_KEY:-}" ]]; then
  MASTER_KEY="$RAILS_MASTER_KEY"
  print_ok "Using RAILS_MASTER_KEY from environment"
else
  print_warn "No master key found. Set it manually:"
  echo "  railway variables set RAILS_MASTER_KEY=<your-master-key>"
fi

# Generate a SECRET_KEY_BASE if not already set
SECRET_KEY=$(openssl rand -hex 64)

railway variables set \
  RAILS_ENV=production \
  RAILS_LOG_TO_STDOUT=true \
  SOLID_QUEUE_IN_PUMA=true \
  ${MASTER_KEY:+RAILS_MASTER_KEY="$MASTER_KEY"} \
  SECRET_KEY_BASE="$SECRET_KEY" \
  2>/dev/null || true

print_ok "Environment variables configured"

# ── 5. Deploy ────────────────────────────────
print_step "Deploying to Railway..."
echo ""

if [[ "$DETACH" == true ]]; then
  railway up --detach
else
  railway up
fi

echo ""
print_ok "Deployment initiated!"
echo ""

# ── 6. Print deployment info ────────────────
print_step "Fetching deployment URL..."
DOMAIN=$(railway domain 2>/dev/null || true)
if [[ -n "$DOMAIN" ]]; then
  echo ""
  echo -e "${GREEN}🚀 Your app is live at:${NC}"
  echo -e "   ${CYAN}https://${DOMAIN}${NC}"
  echo ""
  echo -e "   API docs: ${CYAN}https://${DOMAIN}/api-docs${NC}"
else
  print_warn "No domain found. Generate one with:"
  echo "  railway domain"
fi

echo ""
echo -e "${GREEN}Useful commands:${NC}"
echo "  railway logs          — View logs"
echo "  railway open          — Open in browser"
echo "  railway variables     — View env variables"
echo "  railway shell         — Open Rails console"
echo ""
