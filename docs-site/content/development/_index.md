---
title: "Development"
linkTitle: "Development"
weight: 30
menu:
  main:
    weight: 30
---

# Development Guide

This section provides information for developers who want to contribute to the ComplianceAsCode Builder project.

## Development Environment Setup

Follow these steps to set up a development environment:

1. Clone the repository
2. Set up your environment with `./setup.sh`
3. Build the container with `docker-compose build`
4. Start the container with `docker-compose up -d`
5. Connect to the container with `docker exec -it compliance-as-code bash`

## Testing GitHub Actions Workflows

Test GitHub Actions workflows locally using the `act` tool:

```bash
# List available workflows
./scripts/test-github-actions.sh --list

# Test the build workflow
./scripts/test-github-actions.sh --workflow build-test.yml

# Test a specific job
./scripts/test-github-actions.sh --job build

# Test with arm64 architecture (for M-series Macs)
./scripts/test-github-actions.sh --arch arm64
```

## Development Topics

- [Code Style Guidelines](/development/code-style/): Coding standards for the project
- [Pull Request Process](/development/pull-requests/): How to submit changes
- [Local Development Workflow](/development/local-workflow/): Best practices for development
- [Testing](/development/testing/): How to test your changes
- [Releasing](/development/releasing/): Process for creating releases
- [Contributing](/development/contributing/): Guidelines for contributing