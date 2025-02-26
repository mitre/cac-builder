# Setting Up Your Local Development Environment

This guide provides step-by-step instructions for setting up a complete local development environment for the ComplianceAsCode Builder project.

## Prerequisites

Before starting, ensure you have:

1. **Git**: For version control ([Installation Guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git))
2. **Docker**: For containerization
   - [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
   - [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
   - [Docker Engine for Linux](https://docs.docker.com/engine/install/)
3. **Docker Compose**: Included with Docker Desktop or [installed separately](https://docs.docker.com/compose/install/)

## Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/mitre/cac-builder.git

# Change to the project directory
cd cac-builder
```

## Step 2: Set Up Your Certificate Environment

For local development, you'll need a certificate setup:

### Option 1: Use an Existing Certificate

If you have a CA certificate bundle:

```bash
# Use an existing CA bundle
./setup.sh --cert /path/to/your/ca-bundle.pem
```

### Option 2: Create an Empty Certificate for Testing

For testing without a proper certificate:

```bash
# Create the certificate directories
mkdir -p certs/org

# Create an empty certificate file
touch certs/org/mitre-ca-bundle.pem
```

## Step 3: Choose Your Build Type

The project supports two build types:

### Full Build (Pre-built Products)

```bash
# Set up for full build (includes pre-built products)
./setup.sh --build-type full
```

### Minimal Build (Faster Initial Setup)

```bash
# Set up for minimal build (build products on-demand)
./setup.sh --build-type minimal
```

## Step 4: Build and Start the Container

```bash
# Build the Docker container
docker-compose build

# Start the container in detached mode
docker-compose up -d
```

## Step 5: Test Your Environment

```bash
# Connect to the running container
docker exec -it compliance-as-code bash

# Inside the container, test building a product
build-product rhel10

# Exit the container
exit
```

Check the `output/` directory for generated SCAP content.

## Setting Up for GitHub Actions Local Testing

To test GitHub Actions workflows locally:

### Install Act

Follow the instructions in [Installing Act](installing-act.md) to set up Act on your system.

### Test a Workflow

```bash
# Make the test script executable
chmod +x scripts/test-github-actions.sh

# List available workflows
./scripts/test-github-actions.sh --list

# Test a specific workflow
./scripts/test-github-actions.sh --workflow build-test.yml
```

## Setting Up Your Editor

### VSCode Configuration

If using Visual Studio Code:

1. Install the Docker extension
2. Install the YAML extension for workflow editing
3. Consider adding a `.vscode/settings.json` file:

```json
{
  "files.associations": {
    "*.Dockerfile": "dockerfile",
    ".actrc": "plaintext"
  },
  "yaml.schemas": {
    "https://json.schemastore.org/github-workflow.json": "/.github/workflows/*.yml"
  }
}
```

### Environment Variables

If needed, set up local environment variables:

```bash
# For Linux/macOS
export CA_PATH="/path/to/ca-bundle.pem"

# For Windows PowerShell
$env:CA_PATH = "C:\path\to\ca-bundle.pem"
```

## Troubleshooting Common Issues

### Docker Permission Issues

```bash
# Add your user to the docker group (Linux)
sudo usermod -aG docker $USER
newgrp docker

# Or on macOS/Docker Desktop
sudo chmod 666 /var/run/docker.sock
```

### Certificate Issues

If you encounter SSL certificate errors:

```bash
# Inside the container
echo $SSL_CERT_FILE
cat /etc/pki/ca-trust/source/anchors/mitre-ca-bundle.pem
update-ca-trust
```

### Docker Disk Space Issues

If Docker runs out of disk space:

```bash
# Prune unused containers and images
docker system prune -a
```

## Next Steps

- See [Local Development](local-development.md) for workflow details
- See [Workflow Options](workflow-options.md) for different usage patterns
- See [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines

## Related Documentation

- [Docker Configuration](BUILD-TYPES.md#docker-configuration)
- [Certificate Management](CERTIFICATES.md)
- [GitHub Actions Testing](installing-act.md)
