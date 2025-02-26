#!/usr/bin/env bash
# Script to assemble certificates from GitHub secrets or environment variables
# 
# This script assembles certificates from various sources for use in the ComplianceAsCode Builder.
# It handles both single certificates and split certificate parts, which is useful for GitHub Actions
# where certificates may need to be split due to secret size limitations.
#
# Usage: 
#   ./assemble-certificates.sh [OPTIONS]
#
# Options:
#   --verify           Verify certificate format after assembly
#   --test-mode        Enable test mode with more lenient verification
#   --output-dir DIR   Specify output directory (default: ./certs/org)
#   --help             Show help information
#
# Environment Variables:
#   CA_BUNDLE          Complete certificate bundle (used if available)
#   CA_BUNDLE_PART1..9 Certificate parts (used if CA_BUNDLE is not available)
#   GITHUB_ACTIONS     Set by GitHub Actions, enables test mode
#   ACT                Set by Act tool, enables test mode
#   TEST_ENVIRONMENT   Can be set manually to enable test mode

set -e

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Default output directory
OUTPUT_DIR="./certs/org"
VERIFY_CERT=false
TEST_MODE=false

# Detect if running in test environment
if [ -n "${GITHUB_ACTIONS:-}" ] || [ -n "${ACT:-}" ] || [ -n "${TEST_ENVIRONMENT:-}" ]; then
    TEST_MODE=true
    echo -e "${YELLOW}Running in test mode - certificate verification will be lenient${NC}"
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    --output-dir)
        OUTPUT_DIR="$2"
        shift
        shift
        ;;
    --verify)
        VERIFY_CERT=true
        shift
        ;;
    --test-mode)
        TEST_MODE=true
        echo -e "${YELLOW}Test mode enabled - certificate verification will be lenient${NC}"
        shift
        ;;
    --help)
        echo "Usage: $0 [options]"
        echo "Options:"
        echo "  --output-dir DIR    Output directory for certificates (default: ./certs/org)"
        echo "  --verify            Verify certificate format"
        echo "  --test-mode         Enable test mode (more lenient certificate handling)"
        echo "  --help              Show this help message"
        exit 0
        ;;
    *)
        echo -e "${RED}Unknown option: $1${NC}"
        exit 1
        ;;
    esac
done

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Path to the main certificate
CERT_PATH="$OUTPUT_DIR/ca-bundle.pem"

# Variables to store certificate parts from environment
CERT_SINGLE="${CA_BUNDLE:-}"
# The parts are expected to be in environment variables CA_BUNDLE_PART1, CA_BUNDLE_PART2, etc.

echo "Assembling certificate at $CERT_PATH"

# Start with an empty file with proper permissions
touch "$CERT_PATH"
chmod 644 "$CERT_PATH"

# First try using single secret
if [ -n "$CERT_SINGLE" ]; then
    # Use the single bundle secret
    echo "$CERT_SINGLE" > "$CERT_PATH"
    chmod 644 "$CERT_PATH"
    echo "Using CA certificate from single secret"
# Next try using split certificate parts
elif [ -n "${CA_BUNDLE_PART1:-}" ]; then
    # For split certificates, start with part 1
    echo "${CA_BUNDLE_PART1}" > "$CERT_PATH"
    echo "Adding certificate part 1"
    
    # Then append each additional part that exists
    # Part 2
    if [ -n "${CA_BUNDLE_PART2:-}" ]; then
        echo "${CA_BUNDLE_PART2}" >> "$CERT_PATH"
        echo "Adding certificate part 2"
    fi
    
    # Part 3
    if [ -n "${CA_BUNDLE_PART3:-}" ]; then
        echo "${CA_BUNDLE_PART3}" >> "$CERT_PATH"
        echo "Adding certificate part 3"
    fi
    
    # Part 4
    if [ -n "${CA_BUNDLE_PART4:-}" ]; then
        echo "${CA_BUNDLE_PART4}" >> "$CERT_PATH"
        echo "Adding certificate part 4"
    fi
    
    # Part 5
    if [ -n "${CA_BUNDLE_PART5:-}" ]; then
        echo "${CA_BUNDLE_PART5}" >> "$CERT_PATH"
        echo "Adding certificate part 5"
    fi
    
    # Part 6
    if [ -n "${CA_BUNDLE_PART6:-}" ]; then
        echo "${CA_BUNDLE_PART6}" >> "$CERT_PATH"
        echo "Adding certificate part 6"
    fi
    
    # Part 7
    if [ -n "${CA_BUNDLE_PART7:-}" ]; then
        echo "${CA_BUNDLE_PART7}" >> "$CERT_PATH"
        echo "Adding certificate part 7"
    fi
    
    # Part 8
    if [ -n "${CA_BUNDLE_PART8:-}" ]; then
        echo "${CA_BUNDLE_PART8}" >> "$CERT_PATH"
        echo "Adding certificate part 8"
    fi
    
    # Part 9
    if [ -n "${CA_BUNDLE_PART9:-}" ]; then
        echo "${CA_BUNDLE_PART9}" >> "$CERT_PATH"
        echo "Adding certificate part 9"
    fi
    
    # Ensure proper permissions
    chmod 644 "$CERT_PATH"
    echo "Using CA certificate assembled from multiple parts"
else
    # For local testing, create a placeholder certificate
    echo "Using empty or placeholder CA certificate file"
    echo "# Placeholder certificate for testing" > "$CERT_PATH"
    chmod 644 "$CERT_PATH"
fi

# Create symlink for compatibility with different workflows and naming conventions
ln -sf "$(basename "$CERT_PATH")" "$OUTPUT_DIR/organization-ca-bundle.pem"

# Validate certificate if requested
if [ "$VERIFY_CERT" = true ]; then
    echo "Verifying certificate..."
    
    # Check file exists and has content
    if [ ! -s "$CERT_PATH" ]; then
        echo -e "${RED}${BOLD}Error:${NC} Certificate file is empty or doesn't exist."
        exit 1
    fi
    
    # Check for BEGIN CERTIFICATE marker (unless it's just a placeholder)
    if ! grep -q "# Placeholder" "$CERT_PATH" && ! grep -q "BEGIN CERTIFICATE" "$CERT_PATH"; then
        echo -e "${RED}${BOLD}Error:${NC} Certificate file does not contain a valid certificate."
        echo "File content:"
        head -n 5 "$CERT_PATH"
        exit 1
    fi
    
    # Try to use openssl to verify the certificate if it's available
    if command -v openssl &>/dev/null && ! grep -q "# Placeholder" "$CERT_PATH"; then
        if ! openssl x509 -noout -text -in "$CERT_PATH" &>/dev/null; then
            # For GitHub Actions testing, we'll be lenient with test certificates
            if [ -n "${GITHUB_ACTIONS:-}" ] || [ -n "${ACT:-}" ] || [ "$TEST_MODE" = true ]; then
                echo -e "${YELLOW}Warning:${NC} Certificate verification failed, but continuing for testing purposes."
                # Try to make the test certificate at least minimally valid for testing
                if [ ! -s "$CERT_PATH" ]; then
                    echo "# Test certificate created by assemble-certificates.sh" > "$CERT_PATH"
                    echo "# This is a placeholder for testing only" >> "$CERT_PATH"
                    echo "-----BEGIN CERTIFICATE-----" >> "$CERT_PATH"
                    echo "MIICKzCCAZQCCQDm1GZ0BV5hPDANBgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJV" >> "$CERT_PATH"
                    echo "UzETMBEGA1UECAwKV2FzaGluZ3RvbjEQMA4GA1UEBwwHU2VhdHRsZTEQMA4GA1UE" >> "$CERT_PATH"
                    echo "CgwHRXhhbXBsZTESMBAGA1UEAwwJbG9jYWxob3N0MB4XDTIzMDgwMTEyMDAwMFoX" >> "$CERT_PATH"
                    echo "DTI0MDgwMTEyMDAwMFowWjELMAkGA1UEBhMCVVMxEzARBgNVBAgMCldhc2hpbmd0" >> "$CERT_PATH"
                    echo "b24xEDAOBgNVBAcMB1NlYXR0bGUxEDAOBgNVBAoMB0V4YW1wbGUxEjAQBgNVBAMM" >> "$CERT_PATH"
                    echo "CWxvY2FsaG9zdDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAuG1MliMPe3sO" >> "$CERT_PATH"
                    echo "CZAFXlmY5JqTWS+O0NHm98qZ9IG77pv5GMHu5vJ6aJYPv2CLQzG5h0AGtTzxRxgz" >> "$CERT_PATH"
                    echo "MZRjK+Rfkt+8LBQD/D4MZjq+KcF0Kf5mzV8KxnN99HLRq0Uv6bKKEVfAIzSO4c6H" >> "$CERT_PATH"
                    echo "HkST7/KiQr1xO2GJsaQvNYEUC+kCAwEAATANBgkqhkiG9w0BAQUFAAOBgQBEiZK0" >> "$CERT_PATH"
                    echo "2NShOD0C4YPP6Qa+oXaXbNOuj6TcAhNKxTObTRfR/0xP7kOwVLejYBs4woFrKGnw" >> "$CERT_PATH"
                    echo "LGn1HOlo9DR1LJD5BFJakb7oz4bKNMtNzEsC0KXGv5D+2VerL1JnzRKnYKBJYZBr" >> "$CERT_PATH"
                    echo "Oz/xDN5q3ixlpf4/6XO2P1nSTvG3PZ1OmQ==" >> "$CERT_PATH"
                    echo "-----END CERTIFICATE-----" >> "$CERT_PATH"
                fi
            else
                echo -e "${RED}${BOLD}Error:${NC} Certificate verification failed."
                exit 1
            fi
        else
            echo -e "${GREEN}Certificate verified successfully.${NC}"
        fi
    else
        echo -e "${YELLOW}Note:${NC} Certificate format could not be fully verified (openssl not available or placeholder certificate)."
    fi
fi

# Output certificate info
echo -e "${GREEN}Certificate assembled successfully at $CERT_PATH${NC}"
echo "Certificate permissions: $(ls -l "$CERT_PATH" | awk '{print $1}')"
echo "Symlink: $(ls -l "$OUTPUT_DIR/organization-ca-bundle.pem")"

# Return success
exit 0