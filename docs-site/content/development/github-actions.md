---
title: "Testing GitHub Actions"
linkTitle: "GitHub Actions"
weight: 30
description: How to test GitHub Actions workflows locally
---

# Testing GitHub Actions Locally

This guide explains how to test GitHub Actions workflows locally before pushing changes to the repository.

## Overview

GitHub Actions workflows can be tested locally using the [act](https://github.com/nektos/act) tool. The ComplianceAsCode Builder project includes scripts to simplify this process.

## Prerequisites

1. Install Act: Follow the instructions in [Installing Act](/development/installing-act/)
2. Docker must be installed and running
3. Make the test script executable: `chmod +x scripts/test-github-actions.sh`

## Available Test Commands

### List Available Workflows and Jobs

```bash
./scripts/test-github-actions.sh --list
```

This command displays all available workflows in the `.github/workflows/` directory and their jobs.

### Testing a Workflow

```bash
# Test the default local workflow
./scripts/test-github-actions.sh

# Test a specific workflow
./scripts/test-github-actions.sh --workflow build-test.yml

# Test a specific job
./scripts/test-github-actions.sh --workflow build-test.yml --job build

# Simulate a specific event
./scripts/test-github-actions.sh --event pull_request
```

### Architecture Options

For M-series Macs (Apple Silicon), specify the architecture:

```bash
# Use arm64 architecture (for M-series Macs)
./scripts/test-github-actions.sh --arch arm64

# Use amd64 architecture (compatibility mode)
./scripts/test-github-actions.sh --arch amd64
```

### Certificate Handling

The test script automatically handles certificates:

```bash
# Create a .secrets file for testing
cp .secrets.example .secrets

# Test with certificate handling
./scripts/test-github-actions.sh
```

### Advanced Options

```bash
# Just prepare the environment without running act
./scripts/test-github-actions.sh --prepare

# Enable verbose output for debugging
./scripts/test-github-actions.sh --verbose

# Fix Docker socket issues on macOS
./scripts/test-github-actions.sh --fix-socket
```

## How It Works

The local testing process:

1. Prepares the environment with necessary certificates
2. Sets up Docker Buildx for multi-architecture support
3. Creates test certificates if none are provided
4. Uses local optimized workflows for faster testing
5. Simulates GitHub's runner environment

## Understanding Workflows

### Standard Workflows

Located in `.github/workflows/`, these are the actual workflows that run on GitHub:

- `build-test.yml`: Tests all container builds
- `publish-container.yml`: Publishes containers to GitHub Container Registry

### Local Testing Workflows

Located in `.github/workflows/local/`, these are optimized versions for local testing:

- `build-test-local.yml`: Optimized version that only tests the minimal container

## Limitations

Local testing has some limitations:

- Some GitHub-specific features (like Actions) work differently
- GitHub context variables may have different values
- Network access patterns differ
- Performance may vary from GitHub-hosted runners