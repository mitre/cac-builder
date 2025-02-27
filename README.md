# CAC-Builder: ComplianceAsCode Builder Container

Container for building [ComplianceAsCode](https://github.com/ComplianceAsCode/content) security compliance content.

## Available Images

| Image Tag | Description | Architectures |
|-----------|-------------|--------------|
| `ghcr.io/mitre/cac-builder:latest` | Full version with pre-built content | AMD64 |
| `ghcr.io/mitre/cac-builder:slim` | Minimal version (build as needed) | AMD64, ARM64 |
| `ghcr.io/mitre/cac-builder:X.Y.Z` | Version-specific full image | AMD64 |
| `ghcr.io/mitre/cac-builder:X.Y.Z-slim` | Version-specific minimal image | AMD64, ARM64 |

> **Note:** ARM64 support for the full image is pending stable GitHub Actions macOS Apple Silicon runners.

## Quick Start

```bash
# Pull the minimal container
docker pull ghcr.io/mitre/cac-builder:slim

# Run with mounted output directory
docker run -it --rm -v $(pwd)/output:/output ghcr.io/mitre/cac-builder:slim

# Build specific product
docker run -it --rm -v $(pwd)/output:/output ghcr.io/mitre/cac-builder:slim -c "
  cd /content
  ./build_product rhel9
  cp /content/build/ssg-rhel9-* /output/
"

# Using the full container with pre-built content
docker run -it --rm -v $(pwd)/output:/output ghcr.io/mitre/cac-builder:latest -c "
  cp /content/build/ssg-* /output/
"
```

## Multi-Architecture Support

- **AMD64 (x86_64)**: Full support for both minimal and full containers
- **ARM64 (Apple Silicon)**: Support for minimal container, full container pending GitHub Actions improvements

## Using with GitHub Actions

```yaml
- name: Build compliance content
  run: |
    docker run -v ${{ github.workspace }}/output:/output \
      ghcr.io/mitre/cac-builder:slim -c "
        cd /content && ./build_product rhel9 && \
        cp /content/build/ssg-rhel9-* /output/"
```

For full documentation, see [docs/](./docs/).

## Pre-built Containers

We provide ready-to-use container images on GitHub Container Registry:

```bash
# Pull the full version (with pre-built RHEL10 and Ubuntu 24.04)
docker pull ghcr.io/mitre/cac-builder:full

# Pull the minimal version (smaller size, build products on-demand)
docker pull ghcr.io/mitre/cac-builder:minimal

# Run the container
docker run -it --name compliance-as-code -v $(pwd)/output:/output ghcr.io/mitre/cac-builder:full bash

# Inside the container, the pre-built products are already available
ls /content/build/
```

## Quick Start (Building Locally)

```bash
# Setup the environment
./setup.sh

# Build and start the container
docker-compose build
docker-compose up -d

# Connect to the container
docker exec -it compliance-as-code bash

# Build a specific product
build-product rhel10
```

For detailed setup instructions, see our [documentation site](https://mitre.github.io/cac-builder/).

## Directory Structure

```
cac-builder/
├── certs/                    # Certificate directory
│   └── org/                  # Organization certificates
├── docs/                     # Documentation
│   ├── BUILD-TYPES.md        # Build type documentation
│   ├── CERTIFICATES.md       # Certificate documentation
│   └── workflow-options.md   # Workflow documentation
├── output/                   # Build output directory
├── scripts/                  # Setup and maintenance scripts
├── utils/                    # Container utility scripts
├── .github/workflows/        # CI/CD workflows
├── Dockerfile                # Full build Dockerfile
├── Dockerfile.optimized      # Minimal build Dockerfile
├── setup.sh                  # Setup script
└── docker-compose.yml        # Docker Compose configuration
```

For details on project structure, see [PROJECT-STRUCTURE.md](PROJECT-STRUCTURE.md).

## Build Types

The builder supports two different build configurations:

1. **Full Build**
   - Pre-builds common products (RHEL10, Ubuntu 24.04)
   - Larger container size but faster access to common profiles
   - Best for regular use with standard platforms
   - Command: `./setup.sh --build-type full`

2. **Minimal Build**
   - Only prepares the build environment, no pre-built products
   - Smaller container size and faster build time
   - Products are built on-demand when you need them
   - Command: `./setup.sh --build-type minimal`

For more details on build types, see [docs/BUILD-TYPES.md](docs/BUILD-TYPES.md).

## Certificate Options

You can configure certificates for secure connections:

1. **Default Certificate**
   - Automatically looked for in the project setup
   - Place certificate at `./certs/org/ca-bundle.pem`

2. **Custom CA Certificate**
   - Specify with `--cert` option
   - Example: `./setup.sh --cert /path/to/ca-bundle.pem`

3. **Extra Organization Certificate**
   - Additional certificate for special environments
   - Specify with `--extra-cert` option
   - Example: `./setup.sh --extra-cert /path/to/org-cert.pem`

For more details on certificate options, see [docs/CERTIFICATES.md](docs/CERTIFICATES.md).

## SCAP Content Types

The ComplianceAsCode builder can generate various types of SCAP content:

1. **XCCDF** (Extensible Configuration Checklist Description Format)
   - Primary compliance standard format
   - Contains benchmarks, rules, and profiles
   - Example: `ssg-rhel10-xccdf.xml`

2. **OVAL** (Open Vulnerability and Assessment Language)
   - Technical checking mechanisms
   - Used by XCCDF for automated testing
   - Example: `ssg-rhel10-oval.xml`

3. **DataStreams**
   - Collection format that bundles XCCDF, OVAL, and other content
   - Provides a single file for distribution
   - Example: `ssg-rhel10-ds.xml`

4. **Ansible Playbooks**
   - Remediation scripts in Ansible format
   - Automatically fix non-compliant settings
   - Located in `build/ansible`

5. **Bash Scripts**
   - Remediation scripts in Bash format
   - Fix non-compliant settings on Linux systems
   - Located in `build/bash`

For a complete list of generated content types, check the `output/` directory after building a product.

## Setup and Usage

Run the setup script to prepare the environment:

```bash
# Basic setup with defaults
./setup.sh

# Or with specific options
./setup.sh --build-type minimal --cert /path/to/ca-bundle.pem
```

You can also create a `.env` file for persistent configuration (see `.env.example` for available options).

For help with all available options:

```bash
./setup.sh --help
```

## Build and Run Container

Build and start the Docker container:

```bash
docker-compose build
docker-compose up -d
```

Connect to the container:

```bash
docker exec -it compliance-as-code bash
```

Build a specific product:

```bash
# Inside the container
build-product rhel10  # or any other product
```

Find the generated files in the `./output/` directory on your host machine.

## Workflow Options

This project supports different workflows depending on your needs:

- Regular development and usage
- CI/CD integration
- Cross-platform compliance testing

For detailed workflow options, see [docs/workflow-options.md](docs/workflow-options.md).

## CI/CD Capabilities

This project includes GitHub Actions workflows for:

- Building and testing containers
- Publishing images to GitHub Container Registry

For more details, see [.github/workflows/README.md](.github/workflows/README.md).

## Updating Content

To update to the latest ComplianceAsCode content:

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## For Team Members Behind Corporate Proxies

When using this project behind corporate proxies or firewalls:

1. **Using Pre-built Containers**:
   - The containers published to GitHub Container Registry are already configured with standard CA certificates
   - You may need to mount your organization's CA certificate:

   ```bash
   docker run -v /path/to/ca-bundle.pem:/etc/ssl/certs/ca-bundle.pem \
     -it ghcr.io/mitre/cac-builder:full
   ```

2. **Building Locally**:
   - Clone the repository
   - Place your organization's CA bundle at `./certs/org/ca-bundle.pem` if needed
   - Run `./setup.sh`
   - Build with `docker-compose build`

For details on certificate management, see [docs/CERTIFICATES.md](docs/CERTIFICATES.md).

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details and review our [Code of Conduct](CODE_OF_CONDUCT.md) before participating.

## Help Wanted / Future Improvements

We're looking for help with the following areas:

- Additional product support beyond RHEL10 and Ubuntu 24.04
- Performance improvements for build processes
- Enhanced CI/CD integration examples
- Additional documentation for advanced use cases
- Multi-architecture container support
- Creating downloadable build artifacts (zip/tar.gz of RHEL10 and Ubuntu 24.04 SCAP content) for the documentation site

If you're interested in working on these or other improvements, please check our [open issues](https://github.com/mitre/cac-builder/issues) or create a new one to discuss your ideas.

## Development

For developers looking to contribute or modify this project:

- [Documentation Site](https://mitre.github.io/cac-builder/): Comprehensive project documentation
- [Setup Local Development](https://mitre.github.io/cac-builder/getting-started/setup/): Complete environment setup guide
- [Local Development Workflow](https://mitre.github.io/cac-builder/development/local-workflow/): Development best practices
- [Project Structure](https://mitre.github.io/cac-builder/documentation/project-structure/): Codebase organization

## Notices

See [NOTICE.md](NOTICE.md) for attribution and copyright notices.

## License

This project is licensed under the Apache-2.0 License - see [LICENSE](LICENSE) for details.

## Documentation

Documentation is available in the [docs/](./docs/) directory. For project status and roadmap, see [PROJECT-STATUS.md](./PROJECT-STATUS.md).

### Documentation Maintenance

A helper script is available to update documentation with current project information:

```bash
# Update project status, version references, and documentation
./scripts/update-docs.sh
```
