---
layout: default
title: Script Reference
parent: Documentation
nav_order: 7
---

# ComplianceAsCode Builder Script Reference

This page provides a quick reference for all scripts and utilities in the ComplianceAsCode Builder project.

## Setup Scripts

| Script | Description | Location |
|--------|-------------|----------|
| `setup.sh` | Main setup script for the project | Root directory |
| `init-repo.sh` | Initializes new repository instances | Root directory |
| `cleanup-structure.sh` | Cleans up project structure | Root directory |

## Certificate Management Scripts

| Script | Description | Location |
|--------|-------------|----------|
| `assemble-certificates.sh` | Assembles certificates from environment variables or secrets | `/scripts` |
| `organize-certs.sh` | Organizes certificates into proper directory structure | `/scripts` |
| `split-cert-for-secrets.sh` | Splits certificates for GitHub Secrets | `/scripts` |
| `split-cert-smaller.sh` | Creates smaller certificate chunks | `/scripts` |
| `update-workflow-cert-splits.sh` | Updates workflows for certificate handling | `/scripts` |
| `copy-extra-cert.sh` | Copies additional certificates to container | `/utils` |

## CI/CD Scripts

| Script | Description | Location |
|--------|-------------|----------|
| `test-github-actions.sh` | Tests GitHub Actions workflows locally | `/scripts` |
| `test-workflows.sh` | Tests custom workflows | `/scripts` |
| `prepare-ci.sh` | Prepares environment for CI/CD | `/scripts` |
| `update-repo-secrets.sh` | Updates repository secrets | `/scripts` |

## Docker/Container Scripts

| Script | Description | Location |
|--------|-------------|----------|
| `update-dockerfiles.sh` | Updates Dockerfile symlinks | `/scripts` |
| `reorganize.sh` | Reorganizes project files for containers | `/scripts` |

## Container Utilities

| Utility | Description | Location |
|---------|-------------|----------|
| `build-product.sh` | Builds a specific ComplianceAsCode product | `/utils` |
| `build-common-products.sh` | Builds common ComplianceAsCode products | `/utils` |
| `init-environment.sh` | Initializes container environment | `/utils` |
| `welcome.sh` | Displays welcome message in container | `/utils` |

## Usage Guidelines

- All scripts in the `/scripts` directory should be run from the project root: `./scripts/script-name.sh`
- Utilities in the `/utils` directory are available on the PATH inside the container
- Most scripts support a `--help` flag for detailed usage information
- Scripts follow POSIX-compliant practices for maximum compatibility

## Docker Integration

Many scripts interact with Docker in some way:

- `setup.sh` configures Docker environment variables and builds containers
- `test-github-actions.sh` uses Docker for running GitHub Actions locally
- Container utilities run within the Docker container environment

## Environment Variables

Scripts may use or set the following environment variables:

- `CA_BUNDLE` or `CA_BUNDLE_PART1` through `CA_BUNDLE_PART9` for certificates
- `BUILD_TYPE` to control container build type (full or minimal)
- `OUTPUT_DIR` to specify where output files are placed
- `GITHUB_ACTIONS` or `ACT` to detect CI/CD environments

For more details on a specific script, click its name in the navigation menu.