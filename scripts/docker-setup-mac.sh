#!/usr/bin/env bash
# Helper script to set up Docker on macOS for both Intel and ARM architectures

set -e

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}${BOLD}Setting up Docker for macOS${NC}"

# Check architecture
ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
  echo -e "${YELLOW}Installing Homebrew...${NC}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Docker CLI and Colima
echo -e "${YELLOW}Installing Docker CLI and Colima...${NC}"
brew install docker colima

# Set up Colima with appropriate settings
if [ "$ARCH" == "arm64" ]; then
  # For Apple Silicon M1/M2 Macs
  echo -e "${YELLOW}Detected Apple Silicon, configuring ARM64-optimized Colima...${NC}"
  colima start --cpu 4 --memory 8 --disk 50 --vm-type=vz --vz-rosetta --mount-type=virtiofs
else
  # For Intel Macs
  echo -e "${YELLOW}Detected Intel Mac, configuring Intel-optimized Colima...${NC}"
  colima start --cpu 4 --memory 8 --disk 50 --mount-type=virtiofs
fi

# Wait for Docker to start
echo "Waiting for Docker to be available..."
timeout=60
while ! docker version &>/dev/null && [ $timeout -gt 0 ]; do
  if [ $(($timeout % 10)) -eq 0 ]; then
    echo "Waiting for Docker... ($timeout seconds left)"
  fi
  sleep 2
  ((timeout-=2))
done

# Verify Docker is running
if docker version &>/dev/null; then
  echo -e "${GREEN}${BOLD}Docker is running successfully!${NC}"
  docker version
  docker info | grep "Architecture\|Operating System"
  
  # Add to shell RC files
  echo '# Docker/Colima configuration' >> ~/.zshrc
  echo 'colima start 2>/dev/null || true' >> ~/.zshrc
else
  echo -e "${RED}${BOLD}Docker failed to start${NC}"
  colima status
  exit 1
fi

echo -e "${GREEN}${BOLD}Docker setup completed!${NC}"
echo "You can now use Docker commands normally."
