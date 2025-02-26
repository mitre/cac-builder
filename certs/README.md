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
