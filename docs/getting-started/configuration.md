---
layout: default
title: Configuration
parent: Getting Started
nav_order: 3
---

# Configuring ComplianceAsCode Builder

After installing the ComplianceAsCode Builder, you may want to customize your configuration. This guide covers the various configuration options available.

## Configuration Overview

Configuration can be done through:

1. Command-line options to the setup script
2. Environment variables in a `.env` file
3. Docker Compose overrides

## Using the .env File

You can create a `.env` file in the project root directory to set persistent configuration:

```bash
# Example .env file
BUILD_TYPE=full
CA_CERT_PATH=/path/to/your-ca-cert.pem
EXTRA_CERT_PATH=/path/to/extra-cert.pem
```

Available environment variables:

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `BUILD_TYPE` | Container build type (full or minimal) | `full` |
| `CA_CERT_PATH` | Path to CA certificate | `./certs/org/mitre-ca-bundle.pem` |
| `EXTRA_CERT_PATH` | Path to extra organization certificate | none |
| `OUTPUT_DIR` | Local directory for build output | `./output` |
| `CONTAINER_TAG` | Tag for the built container | `latest` |

## Certificate Configuration

### Default Certificate Location

By default, ComplianceAsCode Builder will look for a certificate at:
```
./certs/org/mitre-ca-bundle.pem
```

### Using Custom Certificates

1. **Custom CA Certificate**:
   ```bash
   ./setup.sh --cert /path/to/ca-bundle.pem
   ```

2. **Extra Organization Certificate**:
   ```bash
   ./setup.sh --extra-cert /path/to/org-cert.pem
   ```

3. **Disabling Certificate Installation**:
   ```bash
   ./setup.sh --no-cert
   ```

## Docker Compose Customization

You can customize the Docker Compose configuration by creating a `docker-compose.override.yml` file:

```yaml
version: '3'
services:
  compliance-as-code:
    environment:
      - CUSTOM_ENV_VAR=value
    volumes:
      - /custom/path:/mount/in/container
```

## Network Configuration

If you're behind a corporate proxy, you may need to configure Docker to use your proxy:

1. Create or edit `~/.docker/config.json`:
   ```json
   {
     "proxies": {
       "default": {
         "httpProxy": "http://proxy.example.com:8080",
         "httpsProxy": "http://proxy.example.com:8080",
         "noProxy": "localhost,127.0.0.1"
       }
     }
   }
   ```

2. Restart Docker after making these changes.

## Build Type Configuration

ComplianceAsCode Builder supports two main build types:

1. **Full Build**:
   - Pre-builds common products (RHEL10, Ubuntu 24.04)
   - Larger container size but faster access to products
   - Configured with `--build-type full`

2. **Minimal Build**:
   - Only prepares the build environment
   - Smaller container size and faster build time
   - Products are built on-demand
   - Configured with `--build-type minimal`

## Next Steps

Once you've configured your environment, you're ready to build your first ComplianceAsCode product.