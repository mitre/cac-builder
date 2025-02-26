#!/usr/bin/env bash
# Script to synchronize documentation files from docs/ to docs-site/content/
# This ensures we maintain a single source of truth for documentation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$REPO_ROOT/docs"
HUGO_CONTENT_DIR="$REPO_ROOT/docs-site/content"

# ANSI colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}${BOLD}Synchronizing documentation to Hugo content...${NC}"

# Function to convert a single file
convert_file() {
  local source="$1"
  local destination="$2"
  local section="$3"
  local weight="$4"
  local link_title="$5"
  
  # Skip if source doesn't exist
  if [ ! -f "$source" ]; then
    echo -e "${YELLOW}Warning: Source file not found: $source${NC}"
    return
  }
  
  echo -e "${GREEN}Converting${NC} $source -> $destination"
  
  # Get the title from the first heading
  if [ -z "$link_title" ]; then
    link_title=$(grep -m 1 "^# " "$source" | sed 's/^# //')
  fi
  
  # Get the description from the first paragraph after the title
  description=$(sed -n '/^# /,/^$/p' "$source" | tail -n +2 | head -n 1 | sed 's/^[[:space:]]*//')
  
  # Make sure the parent directory exists
  mkdir -p "$(dirname "$destination")"
  
  # Create frontmatter
  echo "---" > "$destination"
  echo "title: \"$link_title\"" >> "$destination"
  echo "linkTitle: \"$link_title\"" >> "$destination"
  echo "weight: $weight" >> "$destination"
  echo "description: \"$description\"" >> "$destination"
  echo "---" >> "$destination"
  echo "" >> "$destination"
  
  # Copy content (skip the first heading as it's in the frontmatter)
  tail -n +2 "$source" >> "$destination"
  
  echo -e "${GREEN}Converted:${NC} $destination"
}

# Create directories if they don't exist
mkdir -p "$HUGO_CONTENT_DIR/docs"
mkdir -p "$HUGO_CONTENT_DIR/getting-started"
mkdir -p "$HUGO_CONTENT_DIR/development"

# Map each source file to a destination with appropriate section and weight
echo -e "${BLUE}${BOLD}Processing documentation files...${NC}"

# Documentation section
convert_file "$DOCS_DIR/BUILD-TYPES.md" "$HUGO_CONTENT_DIR/docs/build-types.md" "docs" 15 "Build Types"
convert_file "$DOCS_DIR/CERTIFICATES.md" "$HUGO_CONTENT_DIR/docs/certificates.md" "docs" 20 "Certificate Management"
convert_file "$DOCS_DIR/workflow-options.md" "$HUGO_CONTENT_DIR/docs/workflow-options.md" "docs" 25 "Workflow Options"
convert_file "$REPO_ROOT/PROJECT-STRUCTURE.md" "$HUGO_CONTENT_DIR/docs/project-structure.md" "docs" 10 "Project Structure"
convert_file "$DOCS_DIR/README.md" "$HUGO_CONTENT_DIR/docs/overview.md" "docs" 5 "Documentation Overview"

# Getting Started section
convert_file "$DOCS_DIR/setup-local-development.md" "$HUGO_CONTENT_DIR/getting-started/setup.md" "getting-started" 10 "Setting Up Your Environment"
convert_file "$REPO_ROOT/README.md" "$HUGO_CONTENT_DIR/getting-started/introduction.md" "getting-started" 5 "Introduction"

# Development section
convert_file "$DOCS_DIR/local-development.md" "$HUGO_CONTENT_DIR/development/local-workflow.md" "development" 20 "Local Development"
convert_file "$DOCS_DIR/installing-act.md" "$HUGO_CONTENT_DIR/development/installing-act.md" "development" 25 "Installing Act"
convert_file "$REPO_ROOT/CONTRIBUTING.md" "$HUGO_CONTENT_DIR/development/contributing.md" "development" 10 "Contributing"
convert_file "$REPO_ROOT/CODE_OF_CONDUCT.md" "$HUGO_CONTENT_DIR/development/code-of-conduct.md" "development" 15 "Code of Conduct"

# Section files - create if needed
if [ ! -f "$HUGO_CONTENT_DIR/docs/_index.md" ]; then
  echo -e "${GREEN}Creating${NC} docs section index"
  cat > "$HUGO_CONTENT_DIR/docs/_index.md" << EOF
---
title: "Documentation"
linkTitle: "Documentation"
weight: 10
menu:
  main:
    weight: 10
---

# Documentation

This section contains detailed documentation on all aspects of the ComplianceAsCode Builder project.

## Overview

ComplianceAsCode Builder is a Docker-based environment for working with the [ComplianceAsCode/content](https://github.com/ComplianceAsCode/content) project. It provides tooling for generating SCAP content and remediation scripts for various platforms.

## Documentation Categories

- [Project Structure](/docs/project-structure/): Learn about the organization of the codebase
- [Build Types](/docs/build-types/): Understand the different build configurations
- [Certificate Management](/docs/certificates/): Configure certificates for secure connections
- [Workflow Options](/docs/workflow-options/): Understand the different workflow patterns
EOF
fi

if [ ! -f "$HUGO_CONTENT_DIR/getting-started/_index.md" ]; then
  echo -e "${GREEN}Creating${NC} getting-started section index"
  cat > "$HUGO_CONTENT_DIR/getting-started/_index.md" << EOF
---
title: "Getting Started"
linkTitle: "Getting Started"
weight: 20
menu:
  main:
    weight: 20
---

# Getting Started with ComplianceAsCode Builder

This section provides quick guides to help you get up and running with ComplianceAsCode Builder.
EOF
fi

if [ ! -f "$HUGO_CONTENT_DIR/development/_index.md" ]; then
  echo -e "${GREEN}Creating${NC} development section index"
  cat > "$HUGO_CONTENT_DIR/development/_index.md" << EOF
---
title: "Development"
linkTitle: "Development"
weight: 30
menu:
  main:
    weight: 30
---

# Development Guide

This section provides information for developers who want to contribute to the ComplianceAsCode Builder project.
EOF
fi

echo -e "${GREEN}${BOLD}Documentation synchronized successfully!${NC}"
echo "Content is available in $HUGO_CONTENT_DIR"