#!/usr/bin/env bash
# Create symlinks for Dockerfiles based on build type

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Remove old symlinks if they exist
rm -f "$ROOT_DIR/full.Dockerfile" "$ROOT_DIR/minimal.Dockerfile"

# Create new symlinks
ln -sf "$ROOT_DIR/Dockerfile" "$ROOT_DIR/full.Dockerfile"
ln -sf "$ROOT_DIR/Dockerfile.optimized" "$ROOT_DIR/minimal.Dockerfile"

echo "Dockerfile symlinks created:"
echo "full.Dockerfile -> Dockerfile"
echo "minimal.Dockerfile -> Dockerfile.optimized"
