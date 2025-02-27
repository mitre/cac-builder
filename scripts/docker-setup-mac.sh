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

# Install Docker CLI
echo -e "${YELLOW}Installing Docker CLI...${NC}"
brew install docker

if [ "$ARCH" == "arm64" ]; then
  # For Apple Silicon M1/M2 Macs
  echo -e "${YELLOW}Detected Apple Silicon, installing Rancher Desktop...${NC}"
  brew install --cask rancher
  
  # Give Rancher time to start
  echo "Waiting for Rancher Desktop services to start..."
  timeout=120
  
  # First try to use Rancher's Docker socket
  until test -S ~/Library/Application\ Support/rancher-desktop/run/docker.sock || [ $timeout -eq 0 ]; do
    if [ $(($timeout % 10)) -eq 0 ]; then
      echo "Waiting for Docker socket... ($timeout seconds left)"
    fi
    sleep 1
    ((timeout--))
  done
  
  # Set up the Docker socket
  if test -S ~/Library/Application\ Support/rancher-desktop/run/docker.sock; then
    mkdir -p ~/.docker
    ln -sf ~/Library/Application\ Support/rancher-desktop/run/docker.sock ~/.docker/run-docker.sock
    export DOCKER_HOST=unix://~/.docker/run-docker.sock
    echo "export DOCKER_HOST=unix://~/.docker/run-docker.sock" >> ~/.zshrc
    echo -e "${GREEN}Rancher Desktop Docker socket linked successfully${NC}"
  else
    echo -e "${RED}Rancher Desktop did not start properly${NC}"
    echo -e "${YELLOW}Trying Docker Desktop as fallback...${NC}"
    brew install --cask docker
    
    # Open Docker Desktop
    open -a Docker
    
    # Wait for Docker to start
    echo "Waiting for Docker Desktop to start..."
    timeout=60
    while ! docker info &>/dev/null && [ $timeout -gt 0 ]; do
      sleep 2
      if [ $(($timeout % 10)) -eq 0 ]; then
        echo "Waiting for Docker... ($timeout seconds left)"
      fi
      ((timeout-=2))
    done
  fi
else
  # For Intel Macs
  echo -e "${YELLOW}Detected Intel Mac, installing Docker Desktop...${NC}"
  brew install --cask docker
  
  # Start Docker
  open -a Docker
  
  # Wait for Docker to start
  echo "Waiting for Docker to start..."
  timeout=60
  while ! docker info &>/dev/null && [ $timeout -gt 0 ]; do
    sleep 2
    if [ $(($timeout % 10)) -eq 0 ]; then
      echo "Waiting for Docker... ($timeout seconds left)"
    fi
    ((timeout-=2))
  done
fi

# Verify Docker is running
if docker info &>/dev/null; then
  echo -e "${GREEN}${BOLD}Docker is running successfully!${NC}"
  docker info | grep "Server Version"
else
  echo -e "${RED}${BOLD}Docker failed to start after multiple attempts${NC}"
  exit 1
fi

echo -e "${GREEN}${BOLD}Docker setup completed!${NC}"
echo "You can now use Docker commands normally."
