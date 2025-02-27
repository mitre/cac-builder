---
layout: default
title: assemble-certificates.sh
parent: Scripts
grand_parent: Documentation
nav_order: 1
---

# assemble-certificates.sh

This script assembles certificates from various sources (environment variables or GitHub secrets) for use in the ComplianceAsCode Builder. It's particularly useful in CI/CD environments where certificates may need to be split into smaller parts due to size limitations of secrets.

## Location

`/scripts/assemble-certificates.sh`

## Purpose

The primary purpose of this script is to:

1. Assemble certificates from environment variables
2. Handle both single certificates and multi-part certificates
3. Verify certificate format (when requested)
4. Create appropriate symlinks for compatibility across different workflows

## Usage

```bash
./scripts/assemble-certificates.sh [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `--output-dir DIR` | Specify output directory (default: ./certs/org) |
| `--verify` | Verify certificate format after assembly |
| `--test-mode` | Enable test mode with more lenient verification |
| `--help` | Show help information |

### Environment Variables

The script recognizes the following environment variables:

| Variable | Description |
|----------|-------------|
| `CA_BUNDLE` | Complete certificate bundle (used if available) |
| `CA_BUNDLE_PART1` through `CA_BUNDLE_PART9` | Certificate parts (used if CA_BUNDLE is not available) |
| `GITHUB_ACTIONS` | Set by GitHub Actions, enables test mode |
| `ACT` | Set by Act tool, enables test mode |
| `TEST_ENVIRONMENT` | Can be set manually to enable test mode |

## Examples

### Basic Usage

```bash
./scripts/assemble-certificates.sh
```

### With Verification

```bash
./scripts/assemble-certificates.sh --verify
```

### Custom Output Directory

```bash
./scripts/assemble-certificates.sh --output-dir ./my-certs/
```

### For Testing Environments

```bash
./scripts/assemble-certificates.sh --test-mode
```

## Behavior

The script follows this process:

1. Checks for a single certificate in the `CA_BUNDLE` environment variable
2. If not found, looks for certificate parts in `CA_BUNDLE_PART1` through `CA_BUNDLE_PART9`
3. Assembles the parts into a single certificate file
4. Creates a symlink for compatibility with different workflows
5. Optionally verifies the certificate format 

## Output

The script creates:

- A certificate file at the specified output directory (default: `./certs/org/ca-bundle.pem`)
- A symlink named `organization-ca-bundle.pem` pointing to the certificate file

## Certificate Verification

When the `--verify` option is used, the script will:

1. Check that the certificate file exists and has content
2. Verify that the file contains a valid certificate format
3. Use OpenSSL to validate the certificate (if available)

In test mode, verification is more lenient and will create a placeholder certificate if needed.