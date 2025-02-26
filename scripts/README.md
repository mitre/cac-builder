# Scripts Directory

This directory contains setup, maintenance, and testing scripts for the ComplianceAsCode builder project.

## Setup and Configuration Scripts

- `organize-certs.sh`: Organizes certificates into a structured directory
- `update-dockerfiles.sh`: Creates symlinks for Dockerfiles based on build type
- `prepare-ci.sh`: Prepares the environment for CI/CD pipelines and testing
- `assemble-certificates.sh`: Assembles certificates from various sources with validation
- `split-cert-for-secrets.sh`: Splits large certificates for GitHub Secrets
- `split-cert-smaller.sh`: Splits certificates into even smaller parts if needed
- `update-workflow-cert-splits.sh`: Updates workflows to handle a specific number of certificate parts
- `update-repo-secrets.sh`: Updates GitHub repository secrets with certificate parts

## Testing Scripts

- `test-github-actions.sh`: Main script for testing GitHub Actions workflows locally
  - Lists available workflows and jobs
  - Handles certificate assembly and validation
  - Supports specific architecture selection
  - Provides Docker socket configuration for macOS
  - Offers detailed troubleshooting

## GitHub Workflow Testing

To test GitHub workflows locally:

```bash
# List available workflows and jobs
./scripts/test-github-actions.sh --list

# Test a local optimized workflow (default)
./scripts/test-github-actions.sh

# Test a specific standard workflow
./scripts/test-github-actions.sh --workflow build-test.yml

# Test a specific job only
./scripts/test-github-actions.sh --job build

# Test with arm64 architecture (for M-series Macs)
./scripts/test-github-actions.sh --arch arm64
```

Each script includes detailed help information with the `--help` flag.
