# Certificate Directory

This directory contains CA certificates used by the ComplianceAsCode builder.

## Directory Structure

```
certs/
├── org/             # Organization-specific certificates
│   ├── ca-bundle.pem           # Primary CA certificate bundle
│   ├── organization-ca-bundle.pem  # Symlink to ca-bundle.pem for compatibility
│   └── extra-ca-bundle.pem     # Additional organization certificate (if provided)
└── README.md        # This file
```

## Adding Certificates

To add a new organization's certificate:

1. Use the `--cert` option with the setup script to add your primary certificate
2. Use the `--extra-cert` option to add any additional certificates

Example:
```bash
# Add your primary certificate
./setup.sh --cert /path/to/your-org-ca-bundle.pem

# Add an extra certificate
./setup.sh --extra-cert /path/to/extra-ca-bundle.pem
```

## Certificate Permissions

All certificates are stored with 644 permissions (readable by all users, writable only by owner) for security. These permissions are maintained when they are copied into the container.

## Certificate Handling

The Docker build process:
1. Copies certificates into the container's trust store
2. Updates the certificate trust database
3. Ensures certificates are available before any network operations

For GitHub Actions workflows, certificates are assembled from repository secrets and given appropriate permissions before building the container.
