#!/usr/bin/env bash
# Setup script for native Docker on ARM64 macOS via Lima
# For use on GitHub Actions runners and local development

set -e

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}${BOLD}Setting up native Docker for ARM64${NC}"

# Check architecture
ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

if [ "$ARCH" != "arm64" ]; then
  echo -e "${YELLOW}Warning: This script is optimized for ARM64 architecture, but detected $ARCH${NC}"
fi

# Install required packages via Homebrew
echo -e "${YELLOW}Installing Lima and Docker CLI...${NC}"
brew install lima docker

# Prepare directories
WORK_DIR=$(pwd)
mkdir -p /tmp/lima

# Create a Lima config file optimized for CI/CD
echo -e "${YELLOW}Creating Lima configuration...${NC}"
cat > lima-config.yaml << EOF
# Lima configuration optimized for GitHub Actions
arch: "${ARCH}"
images:
- location: "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img"
  arch: "aarch64"
- location: "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  arch: "x86_64"
memory: "8GiB"
disk: "50GiB"
cpus: 4
mounts:
- location: "~"
  writable: true
- location: "/tmp/lima"
  writable: true
- location: "${WORK_DIR}"
  mountPoint: "/workdir"
  writable: true
provision:
- mode: system
  script: |
    #!/bin/bash
    apt-get update && apt-get install -y ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \$(. /etc/os-release && echo "\$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
    usermod -aG docker ubuntu
portForwards:
- guestSocket: "/var/run/docker.sock"
  hostSocket: "${WORK_DIR}/docker.sock"
EOF

# Start Lima VM
echo -e "${YELLOW}Starting Lima VM with Docker...${NC}"
limactl start --name=docker --tty=false ./lima-config.yaml

# Set Docker socket location
export DOCKER_HOST="unix://${WORK_DIR}/docker.sock"
echo "export DOCKER_HOST=unix://${WORK_DIR}/docker.sock" >> ~/.zshrc

# Wait for Docker to be available
echo -e "${YELLOW}Waiting for Docker to be available...${NC}"
timeout=60
until docker version &>/dev/null || [ $timeout -eq 0 ]; do
  sleep 2
  echo "Waiting for Docker... ($timeout seconds left)"
  ((timeout-=2))
done

# Verify Docker is running
if docker version &>/dev/null; then
  echo -e "${GREEN}${BOLD}Docker is running with native ARM64 support!${NC}"
  docker version
  docker info | grep "Architecture\|Operating System"

  # Test a simple container
  echo -e "${YELLOW}Testing a simple ARM64 container...${NC}"
  docker run --rm --platform linux/arm64 alpine uname -m

  echo -e "${GREEN}${BOLD}Setup complete! Docker is ready for use.${NC}"
  echo "To use Docker in other terminals, run:"
  echo "export DOCKER_HOST=unix://${WORK_DIR}/docker.sock"
else
  echo -e "${RED}${BOLD}Docker failed to start${NC}"
  limactl list
  exit 1
fi
