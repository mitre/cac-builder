#!/usr/bin/env bash
# Script to test GitHub Actions workflows locally using act

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
    echo -e "${RED}${BOLD}Error:${NC} 'act' is not installed. Please install it first:"
    echo -e "  ${YELLOW}brew install act${NC} (macOS)"
    echo -e "  ${YELLOW}https://github.com/nektos/act#installation${NC} (other platforms)"
    exit 1
fi

# Usage function
usage() {
    echo -e "${BOLD}Test GitHub Actions Workflows Locally${NC}"
    echo
    echo -e "Usage: $0 [options]"
    echo
    echo -e "${BOLD}Options:${NC}"
    echo -e "  -w, --workflow WORKFLOW   Specific workflow to test (default: all)"
    echo -e "  -e, --event EVENT         Event to simulate (default: push)"
    echo -e "  -j, --job JOB             Specific job to run (default: all jobs)"
    echo -e "  -l, --list                List available workflows and jobs"
    echo -e "  -h, --help                Display this help message"
    echo
    echo -e "${BOLD}Examples:${NC}"
    echo -e "  $0 --list"
    echo -e "  $0 --workflow build-test.yml"
    echo -e "  $0 --workflow publish-container.yml --job push-to-registry"
    echo -e "  $0 --event pull_request"
}

# Parse arguments
WORKFLOW="local/build-test-local.yml"
EVENT="push"
JOB=""
LIST=false

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
    -j | --job)
        JOB="$2"
        shift
        shift
        ;;
    -l | --list)
        LIST=true
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

# Check if .github/workflows directory exists
if [ ! -d "$ROOT_DIR/.github/workflows" ]; then
    echo -e "${RED}Error: No workflows directory found at .github/workflows${NC}"
    exit 1
fi

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

# Prepare the environment for testing
echo -e "${BLUE}${BOLD}Preparing environment for workflow testing...${NC}"

# Create necessary directories and files for testing
"$SCRIPT_DIR/prepare-ci.sh"

# Assemble certificates with test mode enabled
"$SCRIPT_DIR/assemble-certificates.sh" --output-dir "$ROOT_DIR/certs/org" --test-mode

# Build command based on parameters
cmd="act"

if [ -n "$EVENT" ]; then
    cmd="$cmd $EVENT"
fi

if [ -n "$WORKFLOW" ]; then
    cmd="$cmd -W .github/workflows/$WORKFLOW"
fi

if [ -n "$JOB" ]; then
    cmd="$cmd -j $JOB"
fi

# Add some useful options
cmd="$cmd --artifact-server-path /tmp/artifacts"

echo -e "${GREEN}${BOLD}Running:${NC} $cmd"
echo -e "${YELLOW}This may take some time depending on the workflow...${NC}"
echo "============================================================"

# Run the command
cd "$ROOT_DIR" && eval "$cmd"

status=$?

if [ $status -eq 0 ]; then
    echo "============================================================"
    echo -e "${GREEN}${BOLD}Workflow test completed successfully!${NC}"
else
    echo "============================================================"
    echo -e "${RED}${BOLD}Workflow test failed with exit code $status${NC}"
fi

exit $status
