---
title: "Certificate Management"
linkTitle: "Certificate Management"
weight: 20
description: How to handle certificates in the ComplianceAsCode Builder
---

# Certificate Management

ComplianceAsCode Builder provides flexible options for configuring certificates for secure connections.

## Certificate Options

You can configure certificates in several ways:

### 1. Default Certificate

The project will automatically look for a certificate at a standard location:

```bash
./certs/org/mitre-ca-bundle.pem
```

If this file exists, it will be used without any additional configuration.

### 2. Custom CA Certificate

You can specify a custom certificate location using the `--cert` option:

```bash
./setup.sh --cert /path/to/ca-bundle.pem
```

This will copy the certificate to the appropriate location and configure the container to use it.

### 3. Extra Organization Certificate

For environments that need an additional certificate:

```bash
./setup.sh --extra-cert /path/to/org-cert.pem
```

This is useful for organizations with multiple certificate authorities.

## Certificate Handling Process

The certificate handling process follows these steps:

1. Certificates are copied to the container during building with proper permissions
2. They are installed in `/etc/pki/ca-trust/source/anchors/` within the container
3. The CA trust store is updated with `update-ca-trust` before any network operations
4. Environment variables are set to ensure all tools use the certificates:
   - `SSL_CERT_FILE`
   - `REQUESTS_CA_BUNDLE`
   - `NODE_EXTRA_CA_CERTS`

## GitHub Actions Integration

For GitHub Actions workflows, certificates are handled securely using secrets:

### Setting Up Certificate Secrets

For large certificates, the `assemble-certificates.sh` script can be used to split the certificate into multiple parts:

```bash
./scripts/split-cert-for-secrets.sh /path/to/ca-bundle.pem
```

These parts can then be stored as GitHub Secrets:
- `CA_BUNDLE_PART1`
- `CA_BUNDLE_PART2`
- etc.

### Using Certificates in Workflows

Our GitHub Actions workflows automatically assemble the certificate parts during the build process:

```yaml
- name: Create certificate file for build
  env:
    CA_BUNDLE_PART1: ${{ secrets.CA_BUNDLE_PART1 }}
    CA_BUNDLE_PART2: ${{ secrets.CA_BUNDLE_PART2 }}
  run: |
    ./scripts/assemble-certificates.sh --verify
```

## Local Testing with Test Certificates

For local testing, you can use the `.secrets.example` file as a template:

```bash
cp .secrets.example .secrets
./scripts/test-github-actions.sh
```

This will automatically handle certificates for local workflow testing.