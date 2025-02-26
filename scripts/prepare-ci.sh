#!/usr/bin/env bash
# Script to prepare the environment for CI/CD pipelines

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# ANSI colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}${BOLD}Preparing environment for CI/CD pipelines...${NC}"

# Create necessary directories
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p "$ROOT_DIR/certs/org"
mkdir -p "$ROOT_DIR/output"

# Create an empty certificate file if none exists
if [ ! -f "$ROOT_DIR/certs/org/mitre-ca-bundle.pem" ]; then
    echo -e "${YELLOW}Creating empty certificate file...${NC}"
    touch "$ROOT_DIR/certs/org/mitre-ca-bundle.pem"
fi

# Create Dockerfile symlinks
echo -e "${YELLOW}Creating Dockerfile symlinks...${NC}"
ln -sf "$ROOT_DIR/Dockerfile" "$ROOT_DIR/full.Dockerfile"
ln -sf "$ROOT_DIR/Dockerfile.optimized" "$ROOT_DIR/minimal.Dockerfile"

# Create .env file for docker-compose
echo -e "${YELLOW}Creating .env file...${NC}"
cat >"$ROOT_DIR/.env" <<EOF
BUILD_TYPE=full
EXTRA_CERT=false
EXTRA_CERT_PATH=./certs/org/extra-ca-bundle.pem
EOF

echo -e "${GREEN}${BOLD}CI/CD environment preparation complete!${NC}"
