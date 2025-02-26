#!/usr/bin/env bash
# Script to reorganize the project structure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create necessary directories
echo "Creating directory structure..."
mkdir -p "$SCRIPT_DIR/scripts" "$SCRIPT_DIR/utils" "$SCRIPT_DIR/docs"

# Move documentation files
echo "Moving documentation files..."
mv "$SCRIPT_DIR/BUILD-TYPES.md" "$SCRIPT_DIR/docs/"
mv "$SCRIPT_DIR/CERTIFICATES.md" "$SCRIPT_DIR/docs/"
mv "$SCRIPT_DIR/workflow-options.md" "$SCRIPT_DIR/docs/"

# Move setup and maintenance scripts
echo "Moving setup and maintenance scripts..."
cp "$SCRIPT_DIR/organize-certs.sh" "$SCRIPT_DIR/scripts/"
cp "$SCRIPT_DIR/update-dockerfiles.sh" "$SCRIPT_DIR/scripts/"

# Move helper scripts used by the container
echo "Moving container utility scripts..."
cp "$SCRIPT_DIR/build-common-products.sh" "$SCRIPT_DIR/utils/"
cp "$SCRIPT_DIR/build-product.sh" "$SCRIPT_DIR/utils/"
cp "$SCRIPT_DIR/copy-extra-cert.sh" "$SCRIPT_DIR/utils/"
cp "$SCRIPT_DIR/init-environment.sh" "$SCRIPT_DIR/utils/"
cp "$SCRIPT_DIR/welcome.sh" "$SCRIPT_DIR/utils/"

# Update Dockerfile paths
echo "Updating Dockerfile paths..."
sed -i.bak 's/COPY \.\/build-product.sh/COPY \.\/utils\/build-product.sh/g' "$SCRIPT_DIR/Dockerfile"
sed -i.bak 's/COPY \.\/init-environment.sh/COPY \.\/utils\/init-environment.sh/g' "$SCRIPT_DIR/Dockerfile"
sed -i.bak 's/COPY \.\/build-common-products.sh/COPY \.\/utils\/build-common-products.sh/g' "$SCRIPT_DIR/Dockerfile"
sed -i.bak 's/COPY \.\/welcome.sh/COPY \.\/utils\/welcome.sh/g' "$SCRIPT_DIR/Dockerfile"
sed -i.bak 's/COPY \.\/copy-extra-cert.sh/COPY \.\/utils\/copy-extra-cert.sh/g' "$SCRIPT_DIR/Dockerfile"

# Update Dockerfile.optimized paths
echo "Updating Dockerfile.optimized paths..."
sed -i.bak 's/COPY \.\/build-product.sh/COPY \.\/utils\/build-product.sh/g' "$SCRIPT_DIR/Dockerfile.optimized"
sed -i.bak 's/COPY \.\/init-environment.sh/COPY \.\/utils\/init-environment.sh/g' "$SCRIPT_DIR/Dockerfile.optimized"
sed -i.bak 's/COPY \.\/welcome.sh/COPY \.\/utils\/welcome.sh/g' "$SCRIPT_DIR/Dockerfile.optimized"
sed -i.bak 's/COPY \.\/build-common-products.sh/COPY \.\/utils\/build-common-products.sh/g' "$SCRIPT_DIR/Dockerfile.optimized"
sed -i.bak 's/COPY \.\/copy-extra-cert.sh/COPY \.\/utils\/copy-extra-cert.sh/g' "$SCRIPT_DIR/Dockerfile.optimized"

# Update setup.sh to use scripts directory
echo "Updating setup.sh paths..."
sed -i.bak 's/bash "\$SCRIPT_DIR\/update-dockerfiles.sh"/bash "\$SCRIPT_DIR\/scripts\/update-dockerfiles.sh"/g' "$SCRIPT_DIR/setup.sh"

# Clean up backup files
rm "$SCRIPT_DIR/Dockerfile.bak" "$SCRIPT_DIR/Dockerfile.optimized.bak" "$SCRIPT_DIR/setup.sh.bak"

# Create a new README for each directory
echo "Creating README files for new directories..."

# Scripts directory README
cat >"$SCRIPT_DIR/scripts/README.md" <<'EOF'
# Scripts Directory

This directory contains setup and maintenance scripts for the ComplianceAsCode builder project.

## Available Scripts

- `organize-certs.sh`: Script to organize certificates into a structured directory
- `update-dockerfiles.sh`: Script to create symlinks for Dockerfiles based on build type

These scripts are used by the main setup process and for project maintenance.
EOF

# Utils directory README
cat >"$SCRIPT_DIR/utils/README.md" <<'EOF'
# Utils Directory

This directory contains utility scripts that are copied into the Docker container and used at runtime.

## Available Utilities

- `build-common-products.sh`: Script to build common products (RHEL, Ubuntu)
- `build-product.sh`: Script to build a specific product
- `copy-extra-cert.sh`: Helper script to copy extra certificates into the container
- `init-environment.sh`: Script to initialize the build environment
- `welcome.sh`: Welcome message script for the container

These scripts are copied into the container during build and are available in the container's PATH.
EOF

# Docs directory README
cat >"$SCRIPT_DIR/docs/README.md" <<'EOF'
# Documentation Directory

This directory contains documentation for the ComplianceAsCode builder project.

## Available Documentation

- `BUILD-TYPES.md`: Explanation of different build types (full vs. minimal)
- `CERTIFICATES.md`: Information about certificate management
- `workflow-options.md`: Details about different workflow options

See the main README.md in the project root for usage instructions.
EOF

echo "Reorganization complete!"
echo "You may want to remove the original scripts from the project root after verifying everything works."
