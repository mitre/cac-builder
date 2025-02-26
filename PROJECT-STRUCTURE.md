# ComplianceAsCode Builder Project Structure

This document explains the project structure and organization of the ComplianceAsCode builder.

## Directory Structure

```
cac-builder/
├── README.md               # Main documentation
├── Dockerfile              # Main Dockerfile for full builds
├── Dockerfile.optimized    # Optimized Dockerfile for minimal builds
├── docker-compose.yml      # Docker Compose configuration
├── setup.sh                # Main setup script
├── PROJECT-STRUCTURE.md    # This file
│
├── .github/                # GitHub-specific files
│   └── workflows/          # GitHub Actions workflows
│       ├── build-test.yml  # Testing workflow
│       ├── publish-container.yml  # Container publishing workflow
│       └── README.md       # Workflow documentation
│
├── certs/                  # Certificate directory
│   ├── README.md           # Certificate documentation
│   └── org/                # Organization certificates
│       ├── mitre-ca-bundle.pem  # MITRE CA bundle
│       └── extra-ca-bundle.pem  # Extra organization cert (if any)
│
├── docs/                   # Documentation directory
│   ├── README.md           # Documentation index
│   ├── BUILD-TYPES.md      # Build type documentation
│   ├── CERTIFICATES.md     # Certificate documentation
│   └── workflow-options.md # Workflow options documentation
│
├── output/                 # Build output directory
│   └── ...                 # Generated SCAP content files
│
├── scripts/                # Setup and maintenance scripts
│   ├── README.md           # Scripts documentation
│   ├── organize-certs.sh   # Certificate organization script
│   ├── prepare-ci.sh       # CI preparation script
│   ├── reorganize.sh       # Project structure script
│   └── update-dockerfiles.sh # Dockerfile symlink script
│
└── utils/                  # Container utility scripts
    ├── README.md           # Utils documentation
    ├── build-common-products.sh # Script to build common products
    ├── build-product.sh    # Script to build specific products
    ├── copy-extra-cert.sh  # Certificate helper script
    ├── init-environment.sh # Environment initialization script
    └── welcome.sh          # Container welcome message script
```

## Key Components

### Root Directory

The root directory contains the main configuration files:

- `README.md`: Main project documentation
- `Dockerfile`: Container definition for full builds
- `Dockerfile.optimized`: Container definition for minimal builds
- `docker-compose.yml`: Docker Compose service definition
- `setup.sh`: Main setup script used to initialize the environment
- `PROJECT-STRUCTURE.md`: This document

### GitHub Workflows (`.github/workflows/`)

CI/CD workflows that automate building, testing, and publishing:

- `build-test.yml`: Tests that containers build successfully
- `publish-container.yml`: Publishes container images to GitHub Container Registry
- For more details, see [.github/workflows/README.md](.github/workflows/README.md)

### Certificates (`certs/`)

The `certs/` directory stores CA certificates:

- `org/`: Organization-specific certificates
  - `mitre-ca-bundle.pem`: MITRE CA certificate bundle
  - `extra-ca-bundle.pem`: Additional organization certificate (if provided)
- For more details, see [docs/CERTIFICATES.md](docs/CERTIFICATES.md)

### Documentation (`docs/`)

The `docs/` directory contains detailed project documentation:

- `BUILD-TYPES.md`: Explanation of different build types
- `CERTIFICATES.md`: Certificate management documentation
- `workflow-options.md`: Documentation on workflow options

### Scripts (`scripts/`)

The `scripts/` directory contains setup and maintenance scripts:

- `organize-certs.sh`: Script to organize certificates
- `update-dockerfiles.sh`: Script to create Dockerfile symlinks
- `prepare-ci.sh`: Script to prepare CI environment
- `reorganize.sh`: Script to reorganize project structure

### Utilities (`utils/`)

The `utils/` directory contains scripts that are copied into the container:

- `build-common-products.sh`: Builds common products (RHEL, Ubuntu)
- `build-product.sh`: Builds a specific product
- `copy-extra-cert.sh`: Helper for copying extra certificates
- `init-environment.sh`: Initializes the build environment
- `welcome.sh`: Displays welcome message in the container

### Output (`output/`)

The `output/` directory stores the built SCAP content files.

## File Relationships

1. `setup.sh` uses scripts from the `scripts/` directory
2. `Dockerfile` and `Dockerfile.optimized` copy utilities from the `utils/` directory
3. Docker container mounts the `output/` directory to store build artifacts
4. Certificate files from `certs/org/` are copied into the container
5. GitHub workflows use the container definitions and scripts to automate builds

## Best Practices

1. Add new documentation to the `docs/` directory
2. Add new setup/maintenance scripts to the `scripts/` directory
3. Add new container utilities to the `utils/` directory
4. Keep the root directory clean with only essential files
