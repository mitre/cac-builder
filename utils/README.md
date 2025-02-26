# Utils Directory

This directory contains utility scripts that are copied into the Docker container and used at runtime.

## Available Utilities

- `build-common-products.sh`: Script to build common products (RHEL, Ubuntu)
- `build-product.sh`: Script to build a specific product
- `copy-extra-cert.sh`: Helper script to copy extra certificates into the container
- `init-environment.sh`: Script to initialize the build environment
- `welcome.sh`: Welcome message script for the container

These scripts are copied into the container during build and are available in the container's PATH.
