# ComplianceAsCode Builder

This project provides Docker-based tooling for working with the [ComplianceAsCode/content](https://github.com/ComplianceAsCode/content) project, enabling easy generation of SCAP content for various platforms.

## Quick Start

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

For detailed setup instructions, see [Setting Up Your Local Development Environment](docs/setup-local-development.md).

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

1. **Default CA Certificate**
   - Uses MITRE CA bundle at `~/.aws/mitre-ca-bundle.pem`
   - Automatically copied to `./certs/org/mitre-ca-bundle.pem`

2. **Custom CA Certificate**
   - Specify with `--cert` option
   - Example: `./setup.sh --cert /path/to/ca-bundle.pem`

3. **Extra Organization Certificate**
   - Additional certificate for special environments
   - Specify with `--extra-cert` option
   - Example: `./setup.sh --extra-cert /path/to/org-cert.pem`

For more details on certificate options, see [docs/CERTIFICATES.md](docs/CERTIFICATES.md).

## Setup and Usage

Run the setup script to prepare the environment:

```bash
# Basic setup with defaults
./setup.sh

# Or with specific options
./setup.sh --build-type minimal --cert /path/to/ca-bundle.pem
```

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

## Integration with certsuite

The generated XCCDF files can be integrated with certsuite for compliance scanning:

```bash
# Example integration
certsuite compliance scan \
  --xccdf ./output/ssg-rhel10-xccdf.xml \
  --profile xccdf_org.ssgproject.content_profile_cis
```

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

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details and review our [Code of Conduct](CODE_OF_CONDUCT.md) before participating.

## Development

For developers looking to contribute or modify this project:

- [Setup Local Development](docs/setup-local-development.md): Complete environment setup guide
- [Local Development Workflow](docs/local-development.md): Development best practices
- [Project Structure](PROJECT-STRUCTURE.md): Codebase organization

## Notices

See [NOTICE.md](NOTICE.md) for attribution and copyright notices.

## License

This project is licensed under the Apache-2.0 License - see [LICENSE](LICENSE) for details.
