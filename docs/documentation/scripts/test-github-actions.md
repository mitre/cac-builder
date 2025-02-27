---
layout: default
title: test-github-actions.sh
parent: Scripts
grand_parent: Documentation
nav_order: 2
---

# test-github-actions.sh

This script allows you to test GitHub Actions workflows locally using the [act](https://github.com/nektos/act) tool. It provides comprehensive capabilities for testing workflows with proper certificate handling, architecture selection, and environment configuration.

## Location

`/scripts/test-github-actions.sh`

## Purpose

The primary purpose of this script is to:

1. Provide a simple interface for testing GitHub Actions workflows locally
2. Handle certificate management automatically for testing
3. Support different architecture configurations (arm64/amd64)
4. Allow testing specific workflows and jobs

## Prerequisites

- [act](https://github.com/nektos/act) must be installed
- Docker must be running
- The repository must be properly configured

## Usage

```bash
./scripts/test-github-actions.sh [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `--workflow FILE` | Specify the workflow file to run (e.g., build-test.yml) |
| `--job JOB_ID` | Run a specific job from the workflow |
| `--event EVENT` | Specify the GitHub event (default: push) |
| `--platform PLATFORM` | Specify the platform (arm64 or amd64) |
| `--list` | List all available workflows and jobs |
| `--docker-socket` | Mount Docker socket to allow Docker commands in workflows |
| `--secret KEY=VALUE` | Add a secret |
| `--env KEY=VALUE` | Add an environment variable |
| `--help` | Show help message |

## Examples

### List Available Workflows and Jobs

```bash
./scripts/test-github-actions.sh --list
```

### Test a Specific Workflow

```bash
./scripts/test-github-actions.sh --workflow build-test.yml
```

### Test a Specific Job

```bash
./scripts/test-github-actions.sh --workflow publish-container.yml --job push-to-registry
```

### Simulate a Pull Request Event

```bash
./scripts/test-github-actions.sh --event pull_request
```

### Specify Platform Architecture

```bash
./scripts/test-github-actions.sh --platform arm64
```

## Features

### Automatic Certificate Handling

The script automatically sets up test certificates for your local workflow testing, eliminating the need to configure real certificates for local tests.

### Architecture Support

It detects and configures the appropriate architecture (arm64 or amd64) based on your local system, with option to override.

### Docker Socket Integration

When the `--docker-socket` option is used, the script mounts the Docker socket into the test containers, allowing workflows to interact with the Docker daemon.

### Secret and Environment Variable Management

Easily add secrets and environment variables for your workflow tests with the `--secret` and `--env` options.

## Troubleshooting

If you encounter issues:

1. Make sure act is installed correctly (`act --version`)
2. Ensure Docker is running (`docker ps`)
3. Check for any error messages in the script output
4. Verify that your workflow file is valid YAML
5. Try running with fewer customizations (remove platform, docker socket options)

For more detailed information about using act, see [Installing Act](../../development/installing-act.md).