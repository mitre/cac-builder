---
layout: default
title: Installation
parent: Getting Started
nav_order: 2
---

# Installing ComplianceAsCode Builder

This guide provides detailed instructions for installing the ComplianceAsCode Builder on your system.

## Step 1: Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/mitre/cac-builder.git
cd cac-builder
```

## Step 2: Run the Setup Script

The setup script will prepare your environment and set up the necessary configuration:

```bash
./setup.sh
```

### Setup Options

The setup script accepts several options:

```bash
# For a minimal build (smaller size, build products on-demand)
./setup.sh --build-type minimal

# For a full build (pre-builds common products)
./setup.sh --build-type full

# To specify a custom CA certificate
./setup.sh --cert /path/to/your/ca-bundle.pem

# To add an extra organization certificate
./setup.sh --extra-cert /path/to/org-cert.pem

# To see all available options
./setup.sh --help
```

## Step 3: Build the Docker Container

After setup, build the Docker container:

```bash
docker-compose build
```

This process may take several minutes depending on your internet connection and system performance as it downloads and installs all necessary components.

## Step 4: Start the Container

Start the container in detached mode:

```bash
docker-compose up -d
```

## Step 5: Verify Installation

Verify that the container is running:

```bash
docker ps
```

You should see the `compliance-as-code` container listed.

## Step 6: Connect to the Container

Connect to the running container:

```bash
docker exec -it compliance-as-code bash
```

Once inside the container, you can verify the installation by checking the ComplianceAsCode version:

```bash
cd /content
git status
```

## Troubleshooting Installation

If you encounter issues during installation:

1. Check the troubleshooting guide
2. Ensure Docker is running and you have sufficient permissions
3. Review the setup script output for any error messages

## Next Steps

Now that you've installed ComplianceAsCode Builder, you can proceed to:

- Configure your environment
- Build your first product