# Certificate Management

This document describes how certificates are handled in the ComplianceAsCode Builder.

## Overview

The project requires CA certificates to communicate securely with GitHub and other services. These certificates are mounted into the container during the build process.

## Certificate Options for Users

When building the container locally, you have several options for managing certificates:

### 1. Default Certificate Path

The setup script looks for a CA bundle specified in your environment or uses a default path:

```bash
# Uses the default certificate path
./setup.sh
```

### 2. Custom CA Certificate

Specify a custom certificate path:

```bash
# Specify your own certificate location
./setup.sh --cert /path/to/your/ca-bundle.pem
```

### 3. Extra Certificates

Add an additional certificate:

```bash
# Add an extra certificate alongside the primary one
./setup.sh --extra-cert /path/to/org-cert.pem
```

### 4. Manual Certificate Placement

You can manually place certificates in the project's certificate directory:

```bash
mkdir -p certs/org
cp /path/to/your/ca-bundle.pem certs/org/ca-bundle.pem
```

All certificates are stored in the `./certs/org/` directory within the project.

## Repository Secret for Published Containers

For GitHub Actions workflows that build and publish official containers:

1. The workflow uses repository secrets named `CA_BUNDLE` or split into `CA_BUNDLE_PART1` and `CA_BUNDLE_PART2`
2. These secrets contain the organization CA bundle
3. The certificate is included in the container during the build process
4. Published containers on GitHub Container Registry include this certificate

### Handling Large Certificates

GitHub has a limit of 64KB per secret. For large certificates:

1. Use our provided script to split your certificate:

   ```bash
   # Split certificate into multiple parts
   ./scripts/split-cert-for-secrets.sh --parts 5 ./certs/org/your-ca-bundle.pem
   ```

2. Create GitHub secrets for each part:
   - `CA_BUNDLE_PART1`: Content from part1.pem
   - `CA_BUNDLE_PART2`: Content from part2.pem
   - `CA_BUNDLE_PART3`: Content from part3.pem
   - `CA_BUNDLE_PART4`: Content from part4.pem
   - `CA_BUNDLE_PART5`: Content from part5.pem

The script will automatically split your certificate and provide instructions.

### Benefits of This Approach

- **For MITRE Team Members**: Containers from GitHub Container Registry work on the MITRE network without additional setup
- **For Public Users**: Can still use their own certificates when building locally
- **For Repository**: No certificate files are committed to the repository

## Troubleshooting Certificate Issues

If you encounter SSL certificate errors:

1. Verify your certificate is correctly placed at `./certs/org/ca-bundle.pem`
2. Check that the certificate file is in PEM format
3. In the container, you can verify the certificate was copied with:

   ```bash
   cat /etc/pki/ca-trust/source/anchors/ca-bundle.pem
   ```

4. Update the certificate store in the container:

   ```bash
   update-ca-trust
   ```

## Security Considerations

- Never commit actual certificate files to the repository
- The `.gitignore` file is configured to prevent accidental certificate commits
- Use environment variables or repository secrets for sensitive certificate data
