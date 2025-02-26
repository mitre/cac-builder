#!/usr/bin/env bash
# Script to update GitHub repository secrets with certificate parts

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

# Function to display usage
usage() {
    echo -e "${BOLD}Update GitHub Repository Secrets${NC}"
    echo
    echo -e "Usage: $0 [options]"
    echo
    echo -e "${BOLD}Options:${NC}"
    echo -e "  -d, --directory DIR     Directory containing certificate parts (default: ./split-certs)"
    echo -e "  -r, --repo REPO         GitHub repository (default: current repository)"
    echo -e "  -h, --help              Display this help message"
    echo
    echo -e "${BOLD}Example:${NC}"
    echo -e "  $0 --directory ./split-certs"
    echo -e "  $0 --repo mitre/cac-builder --directory ./my-certs"
    echo
    echo -e "${BOLD}Requirements:${NC}"
    echo -e "  - GitHub CLI (gh) installed and authenticated"
    echo -e "  - Write access to the repository"
}

# Default values
CERT_DIR="$ROOT_DIR/split-certs"
REPO=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -d | --directory)
        CERT_DIR="$2"
        shift
        shift
        ;;
    -r | --repo)
        REPO="$2"
        shift
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

# Check if gh CLI is installed
if ! command -v gh &>/dev/null; then
    echo -e "${RED}${BOLD}Error:${NC} GitHub CLI (gh) is not installed."
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if authenticated with gh
if ! gh auth status &>/dev/null; then
    echo -e "${RED}${BOLD}Error:${NC} Not authenticated with GitHub CLI."
    echo "Please run 'gh auth login' first."
    exit 1
fi

# Check if certificate directory exists
if [ ! -d "$CERT_DIR" ]; then
    echo -e "${RED}${BOLD}Error:${NC} Certificate directory not found: $CERT_DIR"
    exit 1
fi

# Get repository if not specified
if [ -z "$REPO" ]; then
    # Try to determine from git remote
    REPO=$(git remote -v | grep origin | grep push | head -n 1 | awk '{print $2}' | sed 's/.*github.com[:/]\(.*\)\.git.*/\1/')

    if [ -z "$REPO" ]; then
        echo -e "${RED}${BOLD}Error:${NC} Cannot determine GitHub repository."
        echo "Please specify with --repo option."
        exit 1
    fi
fi

echo -e "${BLUE}${BOLD}GitHub Secret Update${NC}"
echo -e "Repository: ${YELLOW}$REPO${NC}"
echo -e "Certificate directory: ${YELLOW}$CERT_DIR${NC}"
echo

# Find certificate parts
echo -e "Searching for certificate parts..."
CERT_FILES=$(find "$CERT_DIR" -name "part*.pem" | sort -V)

if [ -z "$CERT_FILES" ]; then
    echo -e "${RED}${BOLD}Error:${NC} No certificate parts found in $CERT_DIR"
    echo "Expected files like: part1.pem, part2.pem, etc."
    exit 1
fi

echo -e "${GREEN}Found $(echo "$CERT_FILES" | wc -l | xargs) certificate parts${NC}"
echo

# Confirm before updating secrets
echo -e "${YELLOW}This will update GitHub secrets for repository: $REPO${NC}"
echo -e "${YELLOW}The following secrets will be updated:${NC}"
echo

PART_NUM=1
for cert_file in $CERT_FILES; do
    SECRET_NAME="CA_BUNDLE_PART$PART_NUM"
    FILE_SIZE=$(wc -c <"$cert_file")
    echo -e "  - ${BOLD}$SECRET_NAME${NC} ($(numfmt --to=iec --suffix=B --format="%.2f" $FILE_SIZE))"
    PART_NUM=$((PART_NUM + 1))
done

echo
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Operation canceled.${NC}"
    exit 0
fi

# Loop through files and update secrets
echo
echo -e "${BLUE}${BOLD}Updating GitHub secrets...${NC}"

PART_NUM=1
for cert_file in $CERT_FILES; do
    SECRET_NAME="CA_BUNDLE_PART$PART_NUM"
    echo -e "Setting secret ${YELLOW}$SECRET_NAME${NC}..."

    # Update the secret using gh cli
    if ! gh secret set "$SECRET_NAME" -b"$(cat "$cert_file")" --repo "$REPO"; then
        echo -e "${RED}${BOLD}Failed to update secret:${NC} $SECRET_NAME"
        exit 1
    fi

    echo -e "  ${GREEN}Secret updated successfully${NC}"
    PART_NUM=$((PART_NUM + 1))
done

echo
echo -e "${GREEN}${BOLD}All secrets updated successfully!${NC}"
echo -e "The GitHub Actions workflows will now use these certificate parts."

# Check if repository has actions workflow that uses these secrets
if gh api repos/"$REPO"/contents/.github/workflows/build-test.yml &>/dev/null ||
    gh api repos/"$REPO"/contents/.github/workflows/publish-container.yml &>/dev/null; then
    echo -e "${YELLOW}Tip:${NC} Run a workflow to verify the certificates are working:"
    echo -e "  ${BOLD}gh workflow run publish-container.yml --repo $REPO${NC}"
else
    echo -e "${YELLOW}Note:${NC} Couldn't verify if this repository has GitHub Actions workflows configured."
    echo -e "Make sure your workflows are set up to use CA_BUNDLE_PART* secrets."
fi
