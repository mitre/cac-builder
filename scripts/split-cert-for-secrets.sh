#!/usr/bin/env bash
# Script to split a certificate file into parts for GitHub secrets

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
    echo -e "${BOLD}Certificate Splitter for GitHub Secrets${NC}"
    echo
    echo -e "Usage: $0 [options] <certificate-file>"
    echo
    echo -e "${BOLD}Options:${NC}"
    echo -e "  -p, --parts NUM       Number of parts to split into (default: 2)"
    echo -e "  -o, --output DIR      Output directory (default: ./split-certs)"
    echo -e "  -h, --help            Display this help message"
    echo
    echo -e "${BOLD}Example:${NC}"
    echo -e "  $0 ./certs/org/mitre-ca-bundle.pem"
    echo -e "  $0 --parts 3 /path/to/large-ca-bundle.pem"
}

# Default values
PARTS=2
OUTPUT_DIR="$ROOT_DIR/split-certs"

# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -p | --parts)
        PARTS="$2"
        shift
        shift
        ;;
    -o | --output)
        OUTPUT_DIR="$2"
        shift
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        CERT_FILE="$1"
        shift
        ;;
    esac
done

# Check if certificate file is provided
if [ -z "$CERT_FILE" ]; then
    echo -e "${RED}${BOLD}Error:${NC} Certificate file not specified"
    usage
    exit 1
fi

# Check if certificate file exists
if [ ! -f "$CERT_FILE" ]; then
    echo -e "${RED}${BOLD}Error:${NC} Certificate file not found: $CERT_FILE"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Get certificate file size and line count
FILE_SIZE=$(wc -c <"$CERT_FILE")
LINE_COUNT=$(wc -l <"$CERT_FILE")

echo -e "${BLUE}${BOLD}Certificate Information:${NC}"
echo -e "  File: ${YELLOW}$CERT_FILE${NC}"
echo -e "  Size: ${YELLOW}$(numfmt --to=iec --suffix=B --format="%.2f" $FILE_SIZE)${NC}"
echo -e "  Lines: ${YELLOW}$LINE_COUNT${NC}"
echo

# Calculate lines per part
LINES_PER_PART=$((LINE_COUNT / PARTS))
REMAINING_LINES=$((LINE_COUNT % PARTS))

echo -e "${BLUE}${BOLD}Splitting certificate into $PARTS parts:${NC}"

# Current line position
START_LINE=1

# Generate each part
for i in $(seq 1 $PARTS); do
    # Calculate end line for this part
    PART_LINES=$LINES_PER_PART
    if [ $i -le $REMAINING_LINES ]; then
        PART_LINES=$((PART_LINES + 1))
    fi

    END_LINE=$((START_LINE + PART_LINES - 1))
    OUTPUT_FILE="$OUTPUT_DIR/part$i.pem"

    echo -e "  Part $i: lines ${YELLOW}$START_LINE-$END_LINE${NC} -> ${GREEN}$OUTPUT_FILE${NC}"

    # Extract this part
    sed -n "${START_LINE},${END_LINE}p" "$CERT_FILE" >"$OUTPUT_FILE"

    # Get part size
    PART_SIZE=$(wc -c <"$OUTPUT_FILE")
    if [ $PART_SIZE -gt 65536 ]; then
        echo -e "    ${RED}${BOLD}Warning:${NC} Part size ${YELLOW}$(numfmt --to=iec --suffix=B --format="%.2f" $PART_SIZE)${NC} exceeds GitHub's 64KB limit"
    else
        echo -e "    Size: ${YELLOW}$(numfmt --to=iec --suffix=B --format="%.2f" $PART_SIZE)${NC} (Safe for GitHub secrets)"
    fi

    # Move to next part
    START_LINE=$((END_LINE + 1))
done

echo
echo -e "${GREEN}${BOLD}Certificate successfully split!${NC}"
echo -e "Now create GitHub secrets with these contents:"
for i in $(seq 1 $PARTS); do
    echo -e "  ${BOLD}CA_BUNDLE_PART$i${NC}: Content from ${YELLOW}$OUTPUT_DIR/part$i.pem${NC}"
done
echo
echo -e "${BLUE}Workflow Configuration:${NC}"
echo -e "The GitHub Actions workflow is already configured to use these secrets."
echo -e "Make sure all parts are added as secrets for the workflow to work correctly."
