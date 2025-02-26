#!/bin/bash
# Build common products for compliance testing

# ANSI colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}Building common products for compliance testing...${NC}"

# Build RHEL 9
echo -e "${YELLOW}Building RHEL 10...${NC}"
build-product rhel10

# Build Ubuntu 22.04 if it exists
if [ -d "/content/products/ubuntu2404" ]; then
    echo -e "${YELLOW}Building Ubuntu 24.04...${NC}"
    build-product ubuntu2404
fi

echo -e "${GREEN}Common products built successfully!${NC}"
echo -e "${BLUE}Files are available in /output/ directory${NC}"
