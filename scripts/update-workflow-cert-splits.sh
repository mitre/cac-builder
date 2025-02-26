#!/usr/bin/env bash
# Script to update GitHub workflow files to handle a specific number of certificate splits

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
WORKFLOWS_DIR="$ROOT_DIR/.github/workflows"

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    echo -e "${BOLD}Update Workflow Certificate Split Configuration${NC}"
    echo
    echo -e "Usage: $0 [options]"
    echo
    echo -e "${BOLD}Options:${NC}"
    echo -e "  -n, --num-parts NUM    Number of certificate parts (default: prompt user)"
    echo -e "  -h, --help             Display this help message"
    echo
    echo -e "${BOLD}Example:${NC}"
    echo -e "  $0 --num-parts 5"
}

# Parse arguments
NUM_PARTS=""

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -n | --num-parts)
        NUM_PARTS="$2"
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

# Verify workflows directory exists
if [ ! -d "$WORKFLOWS_DIR" ]; then
    echo -e "${RED}${BOLD}Error:${NC} GitHub workflows directory not found: $WORKFLOWS_DIR"
    echo "Make sure you're running this script from the project root."
    exit 1
fi

# If number of parts not specified, prompt user
if [ -z "$NUM_PARTS" ]; then
    echo -e "${BLUE}${BOLD}Certificate Split Configuration${NC}"
    echo
    echo -n "Enter the number of certificate parts (1-10): "
    read -r NUM_PARTS
fi

# Validate input
if ! [[ "$NUM_PARTS" =~ ^[1-9]|10$ ]]; then
    echo -e "${RED}${BOLD}Error:${NC} Invalid number of parts: $NUM_PARTS"
    echo "Please specify a number between 1 and 10."
    exit 1
fi

echo -e "${BLUE}${BOLD}Updating workflow files for ${NUM_PARTS} certificate parts...${NC}"

# Using a different approach to avoid awk errors with multiline strings
# Create the certificate loading script snippet
CERT_SCRIPT_FILE=$(mktemp)

# Update the workflow file approach to handle parts with a simpler approach
cat > "$CERT_SCRIPT_FILE" << 'EOF'
mkdir -p certs/org
# Start with an empty file
touch certs/org/ca-bundle.pem

# First try using single secret
if [ -n "${{ secrets.CA_BUNDLE }}" ]; then
  echo "${{ secrets.CA_BUNDLE }}" > certs/org/ca-bundle.pem
  echo "Using CA certificate from single secret"
# Next try using split certificate parts
elif [ -n "${{ secrets.CA_BUNDLE_PART1 }}" ]; then
  # Add part 1
  echo "${{ secrets.CA_BUNDLE_PART1 }}" > certs/org/ca-bundle.pem
  echo "Adding certificate part 1"
  
  # Check for and add additional parts
EOF

# Add the requested number of parts to the script
for ((i = 2; i <= NUM_PARTS; i++)); do
  cat >> "$CERT_SCRIPT_FILE" << EOF
  if [ -n "\${{ secrets.CA_BUNDLE_PART$i }}" ]; then
    echo "\${{ secrets.CA_BUNDLE_PART$i }}" >> certs/org/ca-bundle.pem
    echo "Adding certificate part $i"
  fi
EOF
done

cat >> "$CERT_SCRIPT_FILE" << 'EOF'
  
  echo "Using CA certificate assembled from multiple parts"
else
  # Fallback to empty file
  echo "Using empty CA certificate file"
fi
EOF

# Function to update a workflow file
update_workflow() {
    local workflow_file="$1"
    local workflow_name="$2"
    
    if [ ! -f "$workflow_file" ]; then
        echo -e "  ${YELLOW}$workflow_name not found, skipping${NC}"
        return
    }
    
    echo -e "Updating ${YELLOW}$workflow_name${NC}..."
    
    # Create a temporary file for the updated workflow
    local tmp_file=$(mktemp)
    
    # Create a flag to track whether we're in the certificate section
    local in_cert_section=0
    local cert_section_found=0
    
    # Process the file line by line
    while IFS= read -r line; do
        # Check if we're entering the certificate section
        if [[ $line =~ name:.*Create.*certificate.*file.*for.*build ]]; then
            in_cert_section=1
            cert_section_found=1
            echo "$line" >> "$tmp_file"
            echo "        run: |" >> "$tmp_file"
            cat "$CERT_SCRIPT_FILE" >> "$tmp_file"
            continue
        fi
        
        # If we're in the certificate section and hit a new step, exit the section
        if [[ $in_cert_section -eq 1 && $line =~ ^[[:space:]]*- ]]; then
            in_cert_section=0
        fi
        
        # If we're not in the certificate section, copy the line
        if [[ $in_cert_section -eq 0 ]]; then
            echo "$line" >> "$tmp_file"
        fi
    done < "$workflow_file"
    
    # Check if we found the certificate section
    if [[ $cert_section_found -eq 0 ]]; then
        echo -e "  ${RED}Warning: Certificate section not found in $workflow_name${NC}"
        rm "$tmp_file"
        return
    fi
    
    # Replace the original file
    mv "$tmp_file" "$workflow_file"
    echo -e "  ${GREEN}Updated with $NUM_PARTS certificate part(s)${NC}"
}

# Update workflow files
update_workflow "$WORKFLOWS_DIR/build-test.yml" "build-test.yml"
update_workflow "$WORKFLOWS_DIR/publish-container.yml" "publish-container.yml"

# Update documentation
CERT_DOC_FILE="$ROOT_DIR/docs/CERTIFICATES.md"
if [ -f "$CERT_DOC_FILE" ]; then
    echo -e "Updating ${YELLOW}CERTIFICATES.md${NC}..."
    
    # Create temporary file
    TMP_FILE=$(mktemp)
    
    # Process the file line by line to update the section about handling large certificates
    local in_section=0
    while IFS= read -r line; do
        # Check if we're entering the section
        if [[ $line == "### Handling Large Certificates" ]]; then
            in_section=1
            echo "$line" >> "$TMP_FILE"
            echo >> "$TMP_FILE"
            echo "GitHub has a limit of 64KB per secret. For large certificates:" >> "$TMP_FILE"
            echo >> "$TMP_FILE"
            echo "1. Use our provided script to split your certificate:" >> "$TMP_FILE"
            echo "   \`\`\`bash" >> "$TMP_FILE"
            echo "   # Split certificate into multiple parts" >> "$TMP_FILE"
            echo "   ./scripts/split-cert-for-secrets.sh --parts $NUM_PARTS ./certs/org/your-ca-bundle.pem" >> "$TMP_FILE"
            echo "   \`\`\`" >> "$TMP_FILE"
            echo >> "$TMP_FILE"
            echo "2. Create GitHub secrets for each part:" >> "$TMP_FILE"
            for ((i=1; i<=NUM_PARTS; i++)); do
                echo "   - \`CA_BUNDLE_PART$i\`: Content from part$i.pem" >> "$TMP_FILE"
            done
            echo >> "$TMP_FILE"
            echo "The script will automatically split your certificate and provide instructions." >> "$TMP_FILE"
            continue
        fi
        
        # Check if we're leaving the section
        if [[ $in_section -eq 1 && $line == "### Benefits of This Approach" ]]; then
            in_section=0
        fi
        
        # If we're not in the section, copy the line
        if [[ $in_section -eq 0 ]]; then
            echo "$line" >> "$TMP_FILE"
        fi
    done < "$CERT_DOC_FILE"
    
    # Replace original file
    mv "$TMP_FILE" "$CERT_DOC_FILE"
    echo -e "  ${GREEN}Updated certificate documentation${NC}"
else
    echo -e "  ${YELLOW}CERTIFICATES.md not found, skipping${NC}"
fi

# Clean up
rm "$CERT_SCRIPT_FILE"

echo -e "${GREEN}${BOLD}Workflow files updated successfully!${NC}"
echo
echo -e "Now you need to:"
echo -e "1. Create the following GitHub secrets:"
for ((i = 1; i <= NUM_PARTS; i++)); do
    echo -e "   - ${BOLD}CA_BUNDLE_PART$i${NC}"
done
echo -e "2. Commit the updated workflow files"
echo -e "3. Push to GitHub to apply changes"
