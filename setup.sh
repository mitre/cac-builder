#!/usr/bin/env bash
# Enhanced setup script for ComplianceAsCode Docker environment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_MITRE_CA_PATH="${HOME}/.aws/mitre-ca-bundle.pem"
BUILD_TYPE="full"
CA_PATH=""
CUSTOM_CERT_PATH=""
SHOW_HELP=false

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Create cert directories if they don't exist
mkdir -p "$SCRIPT_DIR/certs/org"

# Function to display help menu
show_help() {
    echo -e "${BOLD}ComplianceAsCode Builder Setup${NC}"
    echo
    echo -e "Usage: $0 [options]"
    echo
    echo -e "Options:"
    echo -e "  ${BOLD}-h, --help${NC}             Show this help message"
    echo -e "  ${BOLD}-b, --build-type${NC} TYPE  Set build type: 'full' or 'minimal' (default: full)"
    echo -e "  ${BOLD}-c, --cert${NC} PATH        Path to primary CA certificate bundle (default: $DEFAULT_MITRE_CA_PATH)"
    echo -e "  ${BOLD}-e, --extra-cert${NC} PATH  Path to additional organization certificate"
    echo
    echo -e "Build Types:"
    echo -e "  ${BOLD}full${NC}     Complete build with pre-configured products"
    echo -e "  ${BOLD}minimal${NC}  Minimal build with on-demand product building"
    echo
    echo -e "Example:"
    echo -e "  $0 --build-type minimal --cert ~/my-ca-bundle.pem"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -h | --help)
        SHOW_HELP=true
        shift
        ;;
    -b | --build-type)
        BUILD_TYPE="$2"
        shift
        shift
        ;;
    -c | --cert)
        CA_PATH="$2"
        shift
        shift
        ;;
    -e | --extra-cert)
        CUSTOM_CERT_PATH="$2"
        shift
        shift
        ;;
    *)
        echo -e "${RED}Error: Unknown option: $1${NC}"
        show_help
        exit 1
        ;;
    esac
done

# Show help if requested
if [ "$SHOW_HELP" = true ]; then
    show_help
    exit 0
fi

# Validate build type
if [ "$BUILD_TYPE" != "full" ] && [ "$BUILD_TYPE" != "minimal" ]; then
    echo -e "${RED}Error: Invalid build type '$BUILD_TYPE'. Must be 'full' or 'minimal'.${NC}"
    exit 1
fi

# Set CA path if not specified
if [ -z "$CA_PATH" ]; then
    CA_PATH="$DEFAULT_MITRE_CA_PATH"
fi

echo -e "${GREEN}Setting up ComplianceAsCode Docker environment...${NC}"
echo -e "${BLUE}Build type:${NC} $BUILD_TYPE"
echo -e "${BLUE}CA certificate:${NC} $CA_PATH"
if [ -n "$CUSTOM_CERT_PATH" ]; then
    echo -e "${BLUE}Extra certificate:${NC} $CUSTOM_CERT_PATH"
fi

# Check if MITRE CA bundle exists
if [ -f "$CA_PATH" ]; then
    echo -e "${GREEN}Found CA bundle at $CA_PATH${NC}"
    cp "$CA_PATH" "$SCRIPT_DIR/certs/org/mitre-ca-bundle.pem"
else
    echo -e "${YELLOW}Warning: CA bundle not found at $CA_PATH${NC}"
    echo -e "${YELLOW}Creating an empty file (you'll need to add the real certificate)${NC}"
    touch "$SCRIPT_DIR/certs/org/mitre-ca-bundle.pem"
    echo -e "${YELLOW}Please add your CA bundle to ./certs/org/mitre-ca-bundle.pem${NC}"
fi

# Handle extra certificate if specified
if [ -n "$CUSTOM_CERT_PATH" ]; then
    if [ -f "$CUSTOM_CERT_PATH" ]; then
        echo -e "${GREEN}Found extra certificate at $CUSTOM_CERT_PATH${NC}"
        cp "$CUSTOM_CERT_PATH" "$SCRIPT_DIR/certs/org/extra-ca-bundle.pem"
        # Set environment variable for docker-compose
        echo "EXTRA_CERT=true" >"$SCRIPT_DIR/.env"
        echo "EXTRA_CERT_PATH=./certs/org/extra-ca-bundle.pem" >>"$SCRIPT_DIR/.env"
    else
        echo -e "${RED}Error: Extra certificate not found at $CUSTOM_CERT_PATH${NC}"
        exit 1
    fi
else
    echo "EXTRA_CERT=false" >"$SCRIPT_DIR/.env"
    echo "EXTRA_CERT_PATH=./certs/org/extra-ca-bundle.pem" >>"$SCRIPT_DIR/.env"
fi

# Set build type in environment file
echo "BUILD_TYPE=$BUILD_TYPE" >>"$SCRIPT_DIR/.env"

# Create output directory
mkdir -p "$SCRIPT_DIR/output"

# Create Dockerfile symlinks
echo -e "${BLUE}Creating Dockerfile symlinks...${NC}"
bash "$SCRIPT_DIR/scripts/update-dockerfiles.sh"

echo -e "${GREEN}Setup complete!${NC}"
echo -e "You can now build the Docker container:"
echo -e "  ${BOLD}docker-compose build${NC}"
echo -e "  ${BOLD}docker-compose up -d${NC}"
