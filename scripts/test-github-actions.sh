#!/usr/bin/env bash
# Script to test GitHub Actions workflows locally using act
# https://github.com/nektos/act
#
# This script provides a comprehensive way to test GitHub Actions workflows locally
# with certificate handling, architecture selection, and Docker socket configuration.
# It handles both standard workflows and optimized local testing workflows.
#
# Key features:
# - Lists available workflows and jobs with --list option
# - Handles certificates and secrets automatically
# - Supports running specific jobs with --job option
# - Supports different architectures (arm64/amd64)
# - Offers detailed error messages and troubleshooting
#
# Usage:
#   ./scripts/test-github-actions.sh [OPTIONS]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Check if act is installed
if ! command -v act &>/dev/null; then
    echo -e "${RED}${BOLD}Error:${NC} 'act' is not installed."
    echo "Please install act to test GitHub Actions locally:"
    echo -e "  ${YELLOW}brew install act${NC}  # for macOS"
    echo -e "  or see ${BLUE}docs/installing-act.md${NC} for detailed instructions"
    exit 1
fi

# Function to display usage
usage() {
    echo -e "${BOLD}Test GitHub Actions Workflows Locally${NC}"
    echo
    echo -e "Usage: $0 [options]"
    echo
    echo -e "${BOLD}Options:${NC}"
    echo -e "  -w, --workflow WORKFLOW  Specific workflow file to test (default: local/build-test-local.yml)"
    echo -e "  -e, --event EVENT        Event to simulate (default: push)"
    echo -e "  -j, --job JOB            Specific job to run (default: all jobs)"
    echo -e "  -l, --list               List available workflows and jobs"
    echo -e "  -s, --secrets FILE       Secrets file (default: .secrets)"
    echo -e "  -v, --verbose            Enable verbose output"
    echo -e "  -a, --arch ARCH          Container architecture (amd64 or arm64, default: amd64)"
    echo -e "  -p, --prepare            Only prepare test environment, don't run act"
    echo -e "  -d, --docker-socket PATH Specify Docker socket path"
    echo -e "  -f, --fix-socket         Try to automatically fix Docker socket issues"
    echo -e "  -h, --help               Display this help message"
    echo
    echo -e "${BOLD}Examples:${NC}"
    echo -e "  $0 --list                     # List available workflows and jobs"
    echo -e "  $0                            # Test local/build-test-local.yml with push event"
    echo -e "  $0 -w publish-container.yml   # Test publish workflow"
    echo -e "  $0 -j build                   # Run only the 'build' job"
    echo -e "  $0 -e pull_request            # Test with pull_request event"
    echo -e "  $0 -a arm64                   # Use arm64 architecture (for M-series Macs)"
    echo -e "  $0 -f                         # Try to fix Docker socket issues"
    echo
    echo -e "${BOLD}Creating a secrets file:${NC}"
    echo -e "Create a .secrets file in the repository root with content like:"
    echo -e "  CA_BUNDLE=contents_of_certificate"
    echo -e "  CA_BUNDLE_PART1=first_part"
    echo -e "  CA_BUNDLE_PART2=second_part"
}

# Default values
WORKFLOW="local/build-test-local.yml"
EVENT="push"
JOB=""
LIST=false
SECRETS_FILE="$ROOT_DIR/.secrets"
TMP_SECRETS=""
VERBOSE=""
ARCH="amd64"  # Default to amd64 to avoid issues on M-series
PREPARE_ONLY=false
DOCKER_SOCKET=""
FIX_SOCKET=false

# Detect platform - macOS specific handling
IS_MACOS=false
if [[ "$(uname)" == "Darwin" ]]; then
    IS_MACOS=true
    # Default to arm64 on recent macOS systems
    if [[ "$(uname -m)" == "arm64" ]]; then
        ARCH="arm64"
    fi
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -w | --workflow)
        WORKFLOW="$2"
        shift
        shift
        ;;
    -e | --event)
        EVENT="$2"
        shift
        shift
        ;;
    -s | --secrets)
        SECRETS_FILE="$2"
        shift
        shift
        ;;
    -a | --arch)
        ARCH="$2"
        shift
        shift
        ;;
    -d | --docker-socket)
        DOCKER_SOCKET="$2"
        shift
        shift
        ;;
    -v | --verbose)
        VERBOSE="--verbose"
        shift
        ;;
    -p | --prepare)
        PREPARE_ONLY=true
        shift
        ;;
    -j | --job)
        JOB="$2"
        shift
        shift
        ;;
    -l | --list)
        LIST=true
        shift
        ;;
    -f | --fix-socket)
        FIX_SOCKET=true
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        echo -e "${RED}Unknown option: $1${NC}"
        usage
        exit 1
        ;;
    esac
done

# List workflows and jobs if requested
if [ "$LIST" = true ]; then
    echo -e "${BLUE}${BOLD}Available workflows:${NC}"
    
    # Check standard workflows
    echo -e "${BLUE}${BOLD}Standard workflows:${NC}"
    for file in "$ROOT_DIR/.github/workflows"/*.yml; do
        if [ -f "$file" ]; then
            workflow_name=$(basename "$file")
            echo -e "${BLUE}${BOLD}$workflow_name${NC}"

            # Extract job names (basic grep approach)
            echo -e "${YELLOW}Jobs:${NC}"
            grep -A 1 "jobs:" "$file" | grep -v "jobs:" | grep -v -- "--" | sed 's/^\s*//g' | sed 's/:.*$//g' | while read -r job; do
                if [ -n "$job" ]; then
                    echo -e "  - ${job}"
                fi
            done
            echo ""
        fi
    done
    
    # Check local testing workflows
    echo -e "${BLUE}${BOLD}Local testing workflows:${NC}"
    if [ -d "$ROOT_DIR/.github/workflows/local" ]; then
        for file in "$ROOT_DIR/.github/workflows/local"/*.yml; do
            if [ -f "$file" ]; then
                workflow_name="local/$(basename "$file")"
                echo -e "${BLUE}${BOLD}$workflow_name${NC}"

                # Extract job names (basic grep approach)
                echo -e "${YELLOW}Jobs:${NC}"
                grep -A 1 "jobs:" "$file" | grep -v "jobs:" | grep -v -- "--" | sed 's/^\s*//g' | sed 's/:.*$//g' | while read -r job; do
                    if [ -n "$job" ]; then
                        echo -e "  - ${job}"
                    fi
                done
                echo ""
            fi
        done
    else
        echo -e "${YELLOW}No local testing workflows found${NC}"
    fi
    
    exit 0
fi

# Check if workflow file exists
WORKFLOW_PATH="$ROOT_DIR/.github/workflows/$WORKFLOW"
if [ ! -f "$WORKFLOW_PATH" ]; then
    echo -e "${RED}${BOLD}Error:${NC} Workflow file not found: $WORKFLOW_PATH"
    echo "Available workflows:"
    ls -1 "$ROOT_DIR/.github/workflows/"*.yml 2>/dev/null | xargs -n1 basename
    if [ -d "$ROOT_DIR/.github/workflows/local" ]; then
        ls -1 "$ROOT_DIR/.github/workflows/local/"*.yml 2>/dev/null | sed 's|^|local/|' | xargs -n1 echo
    fi
    exit 1
fi

# Check if we have a secrets file
SECRETS_ARGS=""
if [ -f "$SECRETS_FILE" ]; then
    echo -e "${GREEN}Using secrets from:${NC} $SECRETS_FILE"
    SECRETS_ARGS="--secret-file $SECRETS_FILE"
else
    echo -e "${YELLOW}Warning:${NC} No secrets file found at $SECRETS_FILE"
    echo "Certificate handling will fall back to empty certificate."
    echo "Create a .secrets file to test certificate handling properly."
fi

# Print test configuration
echo -e "${BLUE}${BOLD}Testing GitHub Actions Locally${NC}"
echo -e "Workflow: ${YELLOW}$WORKFLOW${NC}"
echo -e "Event: ${YELLOW}$EVENT${NC}"
echo -e "Architecture: ${YELLOW}$ARCH${NC}"

# Try to detect and fix Docker socket issues
DOCKER_SOCKET_ARGS=""
if [ "$IS_MACOS" = true ] && ([ "$FIX_SOCKET" = true ] || [ -n "$DOCKER_SOCKET" ]); then
    echo -e "\n${BLUE}${BOLD}Checking Docker socket configuration...${NC}"
    
    # Use provided socket or try to autodetect
    if [ -n "$DOCKER_SOCKET" ]; then
        echo -e "${YELLOW}Using specified Docker socket:${NC} $DOCKER_SOCKET"
    elif [ "$FIX_SOCKET" = true ]; then
        # Try to find the Docker socket path
        DETECTED_SOCKET=$(docker context inspect 2>/dev/null | grep "SocketPath" | awk -F '"' '{print $4}' | head -1)
        
        if [ -n "$DETECTED_SOCKET" ] && [ -S "$DETECTED_SOCKET" ]; then
            DOCKER_SOCKET="$DETECTED_SOCKET"
            echo -e "${GREEN}Found Docker socket:${NC} $DOCKER_SOCKET"
        else
            echo -e "${YELLOW}Could not automatically detect Docker socket${NC}"
            echo "Will try with default socket path"
        fi
    fi
    
    # If we have a socket path, use it
    if [ -n "$DOCKER_SOCKET" ]; then
        DOCKER_SOCKET_ARGS="--container-daemon-socket $DOCKER_SOCKET"
        echo -e "${GREEN}Using Docker socket:${NC} $DOCKER_SOCKET"
    fi
fi

# Prepare environment for testing
echo -e "\n${BLUE}${BOLD}Preparing test environment...${NC}"

# Use the dedicated script to assemble certificates 
if [ -f "$SECRETS_FILE" ]; then
    # When testing with actual secrets, we'll create a simpler secrets file for ACT
    echo -e "${GREEN}Preparing secrets for certificate assembly...${NC}"
    
    # Create a temporary secrets file in a format that ACT can read
    TMP_SECRETS=$(mktemp)
    
    echo "# Using secrets from: $SECRETS_FILE"
    echo "# Certificate data will be added directly to the certificate file"
    
    # Extract all certificates and use them directly
    if grep -q "CA_BUNDLE_PART" "$SECRETS_FILE"; then
        # Write the parts directly to the cert file, bypassing the environment
        echo "Creating certificate directly from parts in secrets file"
        CA_CERT_DIR="$ROOT_DIR/certs/org"
        mkdir -p "$CA_CERT_DIR"
        
        # Extract certificate parts and concatenate directly to certificate file
        # Note: this is a safer approach than trying to handle complex values in env vars
        touch "$CA_CERT_DIR/ca-bundle.pem"
        chmod 644 "$CA_CERT_DIR/ca-bundle.pem"
        
        # Extract certificate parts from secrets file and write directly
        grep "CA_BUNDLE_PART1" "$SECRETS_FILE" | sed 's/^CA_BUNDLE_PART1="//;s/"$//' | sed 's/\\n/\n/g' > "$CA_CERT_DIR/ca-bundle.pem"
        grep "CA_BUNDLE_PART2" "$SECRETS_FILE" | sed 's/^CA_BUNDLE_PART2="//;s/"$//' | sed 's/\\n/\n/g' >> "$CA_CERT_DIR/ca-bundle.pem"
        
        # Create compatibility symlink
        ln -sf "$(basename "$CA_CERT_DIR/ca-bundle.pem")" "$CA_CERT_DIR/organization-ca-bundle.pem"
        
        echo "Certificate created at $CA_CERT_DIR/ca-bundle.pem"
        
        # We don't need to export certificate parts since we've already created the file directly
        # Set a flag so we know not to run the certificate assembly script
        CERT_ALREADY_ASSEMBLED=true
    fi
    
    # Export non-certificate environment variables
    grep -v -E '^#|CA_BUNDLE_PART' "$SECRETS_FILE" | grep "=" | while read -r line; do
        # Add to our ACT secrets file
        echo "$line" >> "$TMP_SECRETS"
    done
    
    # Use this simplified file for ACT
    SECRETS_ARGS="--secret-file $TMP_SECRETS"
fi

# Run the certificate assembly script if we haven't already created the certificate
if [ "${CERT_ALREADY_ASSEMBLED:-false}" = false ]; then
    echo -e "${BLUE}${BOLD}Assembling certificates...${NC}"
    "$ROOT_DIR/scripts/assemble-certificates.sh" --output-dir "$ROOT_DIR/certs/org" --test-mode
else
    echo -e "${GREEN}Certificate already assembled directly from secrets${NC}"
fi

# Verify the certificate directory structure
if [ ! -f "$ROOT_DIR/certs/org/ca-bundle.pem" ]; then
    echo -e "${RED}${BOLD}Error:${NC} Certificate file not created properly."
    exit 1
fi

# Create test certificate parts if no secrets file exists
if [ ! -f "$SECRETS_FILE" ]; then
    echo -e "\n${BLUE}${BOLD}Creating temporary test certificates...${NC}"

    # Create a temporary secrets file
    TMP_SECRETS=$(mktemp)

    # Generate some sample certificate content
    echo "# Test certificate parts" >$TMP_SECRETS
    echo "CA_BUNDLE_PART1='-----BEGIN CERTIFICATE-----\nMIIFAzCCAuugAwIBAgIULvpN7tWL0msS36H3b9e3EnXjG1swDQYJKoZIhvcNAQEL\nBQAwGzEZMBcGA1UEAwwQVGVzdCBDZXJ0aWZpY2F0ZTAeFw0yMzA4MDExMjAwMDBa\nFw0zMzA3MjkxMjAwMDBaMBsxGTAXBgNVBAMMEFRlc3QgQ2VydGlmaWNhdGUwggIi\n-----END CERTIFICATE-----'" >>$TMP_SECRETS
    echo "CA_BUNDLE_PART2='-----BEGIN CERTIFICATE-----\nMIIFMjCCAxqgAwIBAgIUF2IhfAdFadN1MvlGFpchq+hBuZgwDQYJKoZIhvcNAQEL\nBQAwGzEZMBcGA1UEAwwQVGVzdCBDZXJ0aWZpY2F0ZTAeFw0yMzA4MDExMjAwMDBa\nFw0zMzA3MjkxMjAwMDBaMBsxGTAXBgNVBAMMEFRlc3QgQ2VydGlmaWNhdGUwggIi\n-----END CERTIFICATE-----'" >>$TMP_SECRETS

    SECRETS_ARGS="--secret-file $TMP_SECRETS"
    echo -e "${GREEN}Created temporary test certificates${NC}"
fi

# Build final act command
ACT_CMD="act $EVENT -W .github/workflows/$WORKFLOW $SECRETS_ARGS $VERBOSE --container-architecture linux/$ARCH $DOCKER_SOCKET_ARGS --timeout 600"

# Add job parameter if specified
if [ -n "$JOB" ]; then
    ACT_CMD="$ACT_CMD -j $JOB"
fi

# Check if we should only prepare the environment
if [ "$PREPARE_ONLY" = true ]; then
    echo -e "\n${GREEN}${BOLD}Test environment prepared!${NC}"
    echo "You can now run act manually:"
    echo -e "  cd $ROOT_DIR && $ACT_CMD"
    exit 0
fi

# Run act to test the workflow
echo -e "\n${BLUE}${BOLD}Running workflow with act...${NC}"
echo -e "${YELLOW}Command:${NC} $ACT_CMD"

echo
cd "$ROOT_DIR"
eval $ACT_CMD

# Capture exit code to report success/failure
ACT_EXIT_CODE=$?

# Clean up temporary files if created
if [ -n "$TMP_SECRETS" ] && [ -f "$TMP_SECRETS" ]; then
    rm -f "$TMP_SECRETS"
    echo "Cleaned up temporary secrets file"
fi

if [ $ACT_EXIT_CODE -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}Workflow test completed successfully!${NC}"
else
    echo -e "\n${RED}${BOLD}Workflow test failed with exit code $ACT_EXIT_CODE${NC}"
    echo -e "${YELLOW}Troubleshooting tips:${NC}"
    
    if [ "$IS_MACOS" = true ]; then
        echo "1. Try running with the fix-socket option: $0 -w $WORKFLOW -f"
        echo "2. Check Docker Desktop is running and properly configured"
        echo "3. See docs/installing-act.md for detailed macOS troubleshooting"
    fi
    
    echo "4. Try running with --arch amd64 (or arm64) to match your system"
    echo "5. Check if all required files are accessible to Docker"
    echo "6. Run with --verbose for more detailed output"
    echo "7. Try preparing only (-p) and then run the act command manually"
fi

echo "For full GitHub Actions compatibility, also test on GitHub."
exit $ACT_EXIT_CODE
