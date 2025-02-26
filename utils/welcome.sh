#!/bin/bash
# Welcome message for ComplianceAsCode container

# ANSI colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BOLD}=================================================="
echo -e "  ComplianceAsCode Builder Container"
echo -e "==================================================${NC}"
echo
echo -e "${BLUE}Available commands:${NC}"
echo -e "  ${BOLD}build-product${NC} [product-name]  - Build a specific product"
echo -e "  ${BOLD}init-environment${NC}              - Initialize build environment"
echo -e "  ${BOLD}build-common-products${NC}         - Build common products (RHEL9, Ubuntu 22.04)"
echo
echo -e "${YELLOW}To see available products:${NC}"
echo -e "  ls -1 /content/products/"
echo
echo -e "${GREEN}Output files will be in /output/ directory${NC}"
echo -e "${BOLD}=================================================${NC}"
