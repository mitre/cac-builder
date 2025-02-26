#!/usr/bin/env bash
# Script to initialize git repository and push to GitHub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}${BOLD}Initializing Git repository for cac-builder...${NC}"

# Initialize the git repository if not already initialized
if [ ! -d .git ]; then
    git init
    echo -e "${GREEN}Git repository initialized.${NC}"
else
    echo -e "${YELLOW}Git repository already initialized.${NC}"
fi

# Create .gitignore file
cat >.gitignore <<'EOF'
# Certificates
certs/org/*.pem
!certs/org/.gitkeep

# Build artifacts
output/*
!output/.gitkeep

# Environment files
.env

# Docker related
.docker/

# Temporary files
*.tmp
*.bak
*.swp
*~

# macOS specific files
.DS_Store
.AppleDouble
.LSOverride

# Windows specific files
Thumbs.db
ehthumbs.db
Desktop.ini

# IDE files
.idea/
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
.history
*.code-workspace

# Python
__pycache__/
*.py[cod]
*$py.class
.pytest_cache/
EOF

# Create empty directories with .gitkeep
mkdir -p certs/org
touch certs/org/.gitkeep

mkdir -p output
touch output/.gitkeep

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit

This commit includes:
- Docker configuration for ComplianceAsCode builder
- Documentation for setup and usage
- Scripts for certificate and environment management
- GitHub Actions workflows for building and testing
- Project structure and organization"

# Add GitHub remote
echo -e "${BLUE}${BOLD}Adding GitHub remote...${NC}"
git remote add origin https://github.com/mitre/cac-builder.git

echo
echo -e "${GREEN}${BOLD}Repository initialized and committed!${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Review the commit with ${BOLD}git show${NC}"
echo -e "2. Push to GitHub with ${BOLD}git push -u origin main${NC}"
echo -e "3. Once pushed, test GitHub Actions workflows with ${BOLD}./scripts/test-github-actions.sh --list${NC}"
