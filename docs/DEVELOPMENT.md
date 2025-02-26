# Development Guidelines

This document describes development practices and guidelines for working with the ComplianceAsCode Builder project.

## Local Development

For local development and testing, follow these steps:

1. Clone the repository
2. Set up your environment with `./setup.sh`
3. Build the container with `docker-compose build`
4. Start the container with `docker-compose up -d`
5. Connect to the container with `docker exec -it compliance-as-code bash`

## Testing GitHub Actions Workflows

You can test GitHub Actions workflows locally using the `act` tool. The project includes a helper script for this purpose.

### Prerequisites

1. Install act:
   ```bash
   brew install act  # macOS
   ```
   For other platforms, see [docs/installing-act.md](installing-act.md).

2. Make sure Docker is running on your machine.

### Running Workflow Tests

Use the `test-github-actions.sh` script to test workflows:

```bash
# Test the build workflow
./scripts/test-github-actions.sh -w build-test.yml

# Test the publish workflow
./scripts/test-github-actions.sh -w publish-container.yml
```

### Apple M-series (ARM) Compatibility

If you're using an Apple M-series (ARM) chip, you might encounter issues due to architecture differences. The script has built-in support for specifying architecture:

```bash
# For M-series MacBooks, try the arm64 architecture
./scripts/test-github-actions.sh -w build-test.yml -a arm64

# Or force amd64 architecture (default, may be slower but more compatible)
./scripts/test-github-actions.sh -w build-test.yml -a amd64
```

### Troubleshooting Workflow Tests

If workflow tests fail, check these common issues:

1. Certificate accessibility - ensure certificates are properly set up
2. Docker architecture - use the correct architecture for your system
3. Docker permissions - ensure Docker can access files
4. Secrets configuration - check the `.secrets` file is properly formatted

## Working with Certificates

The project uses certificates for secure connections. For development:

1. Place your organization's CA bundle at `./certs/org/ca-bundle.pem`
2. Certificate permissions should be set to 644 (`chmod 644 ./certs/org/ca-bundle.pem`)
3. For extra certificates, use the `--extra-cert` option with `setup.sh`
4. For GitHub Actions testing, provide certificate content in the `.secrets` file
5. For CI/CD, split large certificates into parts using `./scripts/split-cert-for-secrets.sh`

Certificate handling process:
- Certificates are copied into the Docker image at build time with proper permissions
- They are installed in `/etc/pki/ca-trust/source/anchors/` within the container
- CA trust is updated before any network operations to ensure secure connections

## Code Style Guidelines

Follow these guidelines when contributing:

1. Shell scripts:
   - Use bash (`#\!/usr/bin/env bash`)
   - Use UPPER_SNAKE_CASE for variables
   - Document functions with comments
   - Use `set -e` for proper error handling

2. Docker:
   - Use absolute paths with Docker volumes
   - Format Docker commands with arguments on separate lines
   - Follow security best practices (no hardcoded secrets)

3. GitHub Actions:
   - Explicitly set permissions using the `permissions` key
   - Use the principle of least privilege
   - Handle secrets carefully with the workflow's certificate assembly process

## Pull Request Process

1. Create a feature branch from `main`
2. Make your changes
3. Ensure all workflows pass locally with `./scripts/test-github-actions.sh`
4. Submit a pull request to `main`
5. Wait for review and approval

## Releasing New Versions

1. Update version numbers in relevant files
2. Create a tag with the version number (`vX.Y.Z`)
3. Push the tag to trigger the release workflow
4. Verify container images are published to GitHub Container Registry
