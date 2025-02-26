#!/usr/bin/env bash
# Script to organize certificates into a structured directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create certificates directory structure
mkdir -p "$SCRIPT_DIR/certs/org"

# Check if MITRE CA bundle exists and move it to the certs directory
if [ -f "$SCRIPT_DIR/mitre-ca-bundle.pem" ]; then
    echo "Moving MITRE CA bundle to certs directory..."
    mv "$SCRIPT_DIR/mitre-ca-bundle.pem" "$SCRIPT_DIR/certs/org/mitre-ca-bundle.pem"
fi

# Check if extra CA bundle exists and move it to the certs directory
if [ -f "$SCRIPT_DIR/extra-ca-bundle.pem" ]; then
    echo "Moving extra CA bundle to certs directory..."
    mv "$SCRIPT_DIR/extra-ca-bundle.pem" "$SCRIPT_DIR/certs/org/extra-ca-bundle.pem"
fi

# Create a README file for the certs directory
cat >"$SCRIPT_DIR/certs/README.md" <<'EOF'
# Certificate Directory

This directory contains CA certificates used by the ComplianceAsCode builder.

## Directory Structure

```
certs/
├── org/             # Organization-specific certificates
│   ├── mitre-ca-bundle.pem    # MITRE CA certificate bundle
│   └── extra-ca-bundle.pem    # Additional organization certificate (if provided)
└── README.md        # This file
```

## Adding Certificates

To add a new organization's certificate:

1. Place the certificate in the `org/` directory
2. Use the `--cert` or `--extra-cert` options with the setup script

Example:
```bash
./setup.sh --cert ./certs/org/your-org-ca-bundle.pem
```
EOF

echo "Certificate directory structure created."
echo "Certificates are now organized under ./certs/org/"
