#!/usr/bin/env bash
# Script to set up a Slidev presentation environment for CAC-Builder

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
PRES_DIR="$ROOT_DIR/docs/presentations"

# ANSI colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}${BOLD}Setting up CAC-Builder presentation environment...${NC}"

# Create presentation directory if it doesn't exist
mkdir -p "$PRES_DIR"
mkdir -p "$PRES_DIR/assets"

# Create a package.json if it doesn't exist
if [ ! -f "$PRES_DIR/package.json" ]; then
  echo -e "${YELLOW}Creating package.json...${NC}"
  cat >"$PRES_DIR/package.json" <<EOF
{
  "name": "cac-builder-presentation",
  "private": true,
  "scripts": {
    "dev": "slidev --open",
    "build": "slidev build",
    "export": "slidev export"
  },
  "dependencies": {
    "@slidev/cli": "^0.42.5",
    "@slidev/theme-default": "^0.21.2",
    "@slidev/theme-seriph": "^0.21.3"
  }
}
EOF
fi

# Create .gitignore if it doesn't exist
if [ ! -f "$PRES_DIR/.gitignore" ]; then
  echo -e "${YELLOW}Creating .gitignore...${NC}"
  cat >"$PRES_DIR/.gitignore" <<EOF
node_modules
.DS_Store
dist
*.local
.remote-assets
components.d.ts
EOF
fi

# Check if we need to create the example presentation
if [ ! -f "$PRES_DIR/cac-builder-intro.md" ]; then
  echo -e "${YELLOW}Creating example presentation...${NC}"
  # Note: The actual content will be supplied by the user or a separate process
  echo "# Example presentation file will be created here" >"$PRES_DIR/cac-builder-intro.md"
fi

# Create a container diagram for the presentation
if [ ! -f "$PRES_DIR/assets/container-diagram.png" ]; then
  echo -e "${YELLOW}Creating placeholder for container diagram...${NC}"
  # Generate a simple placeholder diagram (in real use, you'd create a proper diagram)
  cat >"$PRES_DIR/assets/container-diagram.png" <<EOF
iVBORw0KGgoAAAANSUhEUgAAAPAAAADwCAYAAAA+VemSAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAA8KADAAQAAAABAAAA8AAAAADV6CrLAAAFRElEQVR4Ae3cwZHCMBREwZ8LJ+NgnApD4bjYAxVQC1Xv1+xIbfX2rOu6vs7P6wRej3/094G/n8h9/3r/rcD9du7XCVzXdZ2fXwk8Q7xP4Ptt3K8TeF3X5/y8SuAR4n0C99u5Xyewrus6P68SeIZ4n8D9du7XCayrus7PqwSeId4ncL+d+3UC66qu8/MqgWeI9wncb+d+ncC6quv8vErgGeJ9Avfbt18nsK7qOj+vEniGeJ/A/bbt1wmsq7rOz6sEniHeJ3C/bft1AuuqrvPzKoFniPcJ3G/bfp3AuqrrBP5FYF3VdQL/JrCu6jqBfxNYV3WdwL8JrKu6TuDfBNZVXSfwbwLrqq4T+DeBdVXXCfybwLqq6wT+TWBd1XUC/yawruo6gX8TWFd1ncC/Cayrug==
EOF
fi

echo -e "${GREEN}${BOLD}Setup complete!${NC}"
echo -e "Your presentation environment is ready. To start working on your presentation:"
echo -e "1. ${YELLOW}cd $PRES_DIR${NC}"
echo -e "2. ${YELLOW}npm install${NC}  (first time only)"
echo -e "3. ${YELLOW}npm run dev${NC}  (to start the development server)"
echo
echo -e "This will open your presentation in the browser with hot-reload enabled."
echo -e "Edit ${BLUE}cac-builder-intro.md${NC} to create your presentation."
echo
echo -e "To build for production: ${YELLOW}npm run build${NC}"
echo -e "To export to PDF: ${YELLOW}npm run export${NC}"
