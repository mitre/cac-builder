#!/usr/bin/env bash
# Create symlinks for Dockerfiles based on build type

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remove old symlinks if they exist
rm -f "$SCRIPT_DIR/full.Dockerfile" "$SCRIPT_DIR/minimal.Dockerfile"

# Create new symlinks
ln -sf "$SCRIPT_DIR/Dockerfile" "$SCRIPT_DIR/full.Dockerfile"
ln -sf "$SCRIPT_DIR/Dockerfile.optimized" "$SCRIPT_DIR/minimal.Dockerfile"

echo "Dockerfile symlinks created:"
echo "full.Dockerfile -> Dockerfile"
echo "minimal.Dockerfile -> Dockerfile.optimized"
