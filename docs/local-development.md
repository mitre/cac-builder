# Local Development

This document provides instructions for local development and testing of the ComplianceAsCode Builder project.

## Testing GitHub Actions Workflows Locally

GitHub Actions workflows can be tested locally before committing using [act](https://github.com/nektos/act), a tool that runs GitHub Actions locally.

### Prerequisites

1. Install `act` - See [Installing Act](installing-act.md) for detailed installation instructions for all platforms
2. Docker must be installed and running

### Running Local Workflow Tests

Use the provided script to test workflows:

```bash
# List available workflows and jobs
./scripts/test-workflows.sh --list

# Test a specific workflow
./scripts/test-workflows.sh --workflow build-test.yml

# Test a specific job in a workflow
./scripts/test-workflows.sh --workflow publish-container.yml --job push-to-registry

# Simulate a specific event (e.g., pull_request)
./scripts/test-workflows.sh --event pull_request
```

### How Local Testing Works

The local testing process:

1. Creates a test environment with the necessary certificates and configuration
2. Uses Docker to simulate GitHub's runner environment
3. Executes the workflow steps in isolated containers
4. Shows outputs similar to what you'd see in GitHub's UI

### Limitations

Local testing with `act` has some limitations:

- Some GitHub-specific features may not work fully (e.g., certain GitHub context variables)
- Secrets handling is different locally
- Performance may differ from GitHub-hosted runners
- Container registry interactions will need proper credentials

## Developing and Testing Container Changes

To test changes to the Docker containers:

1. Make changes to the Dockerfile or Dockerfile.optimized
2. Run the setup script: `./setup.sh`
3. Build the container: `docker-compose build`
4. Start the container: `docker-compose up -d`
5. Connect to the container: `docker exec -it compliance-as-code bash`
6. Test your changes inside the container

## Documentation Development

When updating documentation:

1. Ensure cross-links between documents are maintained
2. Test all code examples
3. Update the appropriate README files
4. Consider impact on GitHub Pages if implemented

## Submitting Changes

After local testing:

1. Commit your changes: `git commit -am 'Add feature XYZ'`
2. Push to your fork: `git push origin my-feature`
3. Create a pull request
4. GitHub Actions will run the workflows automatically on your PR

For more details, see [CONTRIBUTING.md](../CONTRIBUTING.md).
