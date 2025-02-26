#!/usr/bin/env bash
# Script to clean up project structure after reorganization

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}${BOLD}Cleaning up project structure...${NC}"

# Remove duplicate scripts from the root directory
echo -e "${YELLOW}Removing duplicate scripts from root directory...${NC}"
rm -f "$SCRIPT_DIR/build-common-products.sh"
rm -f "$SCRIPT_DIR/build-product.sh"
rm -f "$SCRIPT_DIR/copy-extra-cert.sh"
rm -f "$SCRIPT_DIR/init-environment.sh"
rm -f "$SCRIPT_DIR/welcome.sh"
rm -f "$SCRIPT_DIR/organize-certs.sh"
rm -f "$SCRIPT_DIR/update-dockerfiles.sh"

# Make sure all scripts are executable
echo -e "${YELLOW}Making all scripts executable...${NC}"
chmod +x "$SCRIPT_DIR/scripts/"*.sh
chmod +x "$SCRIPT_DIR/utils/"*.sh
chmod +x "$SCRIPT_DIR/setup.sh"

# Update setup.sh to use the scripts directory
echo -e "${YELLOW}Updating setup.sh references...${NC}"
sed -i.bak 's/\.\/update-dockerfiles\.sh/\.\/scripts\/update-dockerfiles.sh/g' "$SCRIPT_DIR/setup.sh"
rm -f "$SCRIPT_DIR/setup.sh.bak"

# Move reorganize script to scripts directory
echo -e "${YELLOW}Moving reorganize.sh to scripts directory...${NC}"
mv "$SCRIPT_DIR/reorganize.sh" "$SCRIPT_DIR/scripts/"

# Print final structure
echo -e "${GREEN}${BOLD}Project structure cleaned up!${NC}"
echo -e "${BLUE}Final project structure:${NC}"
find "$SCRIPT_DIR" -type f -name "*.sh" | sort

echo -e "\n${GREEN}${BOLD}Cleanup complete!${NC}"
echo -e "${BLUE}You should now have a clean, organized project structure.${NC}"
echo -e "${YELLOW}To build the project:${NC}"
echo -e "  ${BOLD}./setup.sh${NC}"
echo -e "  ${BOLD}docker-compose build${NC}"
echo -e "  ${BOLD}docker-compose up -d${NC}"
