#!/usr/bin/env bash
# Script to split a certificate into smaller chunks for GitHub secrets

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
    echo -e "${BOLD}Certificate Splitter for GitHub Secrets (Small Chunks)${NC}"
    echo
    echo -e "Usage: $0 [options] <certificate-file>"
    echo
    echo -e "${BOLD}Options:${NC}"
    echo -e "  -s, --size SIZE        Maximum size per chunk in KB (default: 32)"
    echo -e "  -o, --output DIR       Output directory (default: ./split-certs)"
    echo -e "  -h, --help             Display this help message"
    echo
    echo -e "${BOLD}Example:${NC}"
    echo -e "  $0 ./certs/org/ca-bundle.pem"
    echo -e "  $0 --size 16 ./certs/org/ca-bundle.pem"
}

# Default values
MAX_SIZE_KB=32
OUTPUT_DIR="$ROOT_DIR/split-certs"

# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -s | --size)
        MAX_SIZE_KB="$2"
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
MAX_SIZE_BYTES=$((MAX_SIZE_KB * 1024))

echo -e "${BLUE}${BOLD}Certificate Information:${NC}"
echo -e "  File: ${YELLOW}$CERT_FILE${NC}"
echo -e "  Size: ${YELLOW}$(numfmt --to=iec --suffix=B --format="%.2f" $FILE_SIZE)${NC}"
echo -e "  Lines: ${YELLOW}$LINE_COUNT${NC}"
echo -e "  Max chunk size: ${YELLOW}${MAX_SIZE_KB}KB${NC}"
echo

# Calculate how many chunks we need
NUM_CHUNKS=$(((FILE_SIZE + MAX_SIZE_BYTES - 1) / MAX_SIZE_BYTES))
echo -e "${BLUE}${BOLD}Splitting certificate into approximately $NUM_CHUNKS chunks...${NC}"

# Split the file using split command (more reliable for binary files)
split -b ${MAX_SIZE_KB}k "$CERT_FILE" "$OUTPUT_DIR/chunk-"

# Rename chunks to part1.pem, part2.pem, etc.
CHUNK_NUM=1
for chunk in $(ls -v "$OUTPUT_DIR/chunk-"*); do
    OUTPUT_FILE="$OUTPUT_DIR/part$CHUNK_NUM.pem"
    mv "$chunk" "$OUTPUT_FILE"

    # Get chunk size
    CHUNK_SIZE=$(wc -c <"$OUTPUT_FILE")

    echo -e "  Part $CHUNK_NUM: ${YELLOW}$(numfmt --to=iec --suffix=B --format="%.2f" $CHUNK_SIZE)${NC} -> ${GREEN}$OUTPUT_FILE${NC}"

    # Verify chunk size
    if [ $CHUNK_SIZE -gt $MAX_SIZE_BYTES ]; then
        echo -e "    ${RED}${BOLD}Warning:${NC} Chunk size exceeds ${MAX_SIZE_KB}KB limit!"
    else
        echo -e "    ${GREEN}Size OK${NC} (under ${MAX_SIZE_KB}KB GitHub secret limit)"
    fi

    CHUNK_NUM=$((CHUNK_NUM + 1))
done

# Calculate and show total number of chunks
TOTAL_CHUNKS=$((CHUNK_NUM - 1))

echo
echo -e "${GREEN}${BOLD}Certificate successfully split into $TOTAL_CHUNKS parts!${NC}"
echo -e "Now create GitHub secrets with these contents:"
for i in $(seq 1 $TOTAL_CHUNKS); do
    echo -e "  ${BOLD}CA_BUNDLE_PART$i${NC}: Content from ${YELLOW}$OUTPUT_DIR/part$i.pem${NC}"
done

# Update the workflow script
echo
echo -e "${BLUE}${BOLD}Updating workflow files for $TOTAL_CHUNKS certificate parts...${NC}"
"$SCRIPT_DIR/update-workflow-cert-splits.sh" --num-parts $TOTAL_CHUNKS

echo
echo -e "${GREEN}${BOLD}All done!${NC}"
echo -e "You can now update your GitHub secrets using:"
echo -e "  ${BOLD}./scripts/update-repo-secrets.sh --directory $OUTPUT_DIR${NC}"
