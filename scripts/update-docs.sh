#!/usr/bin/env bash
# Script to update documentation and README.md with current project status

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Update version references in README
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.1.0")
VERSION_NO_V=${VERSION#v}

echo "Updating documentation for version: $VERSION"

# Update version in documentation
sed -i '' "s/X\.Y\.Z/$VERSION_NO_V/g" "$PROJECT_ROOT/README.md"

# Update status in STATUS file to match current state
cat > "$PROJECT_ROOT/PROJECT-STATUS.md" << EOF
# Project Status and Roadmap

## Current Status

CAC-Builder is currently in active development with a focus on providing a consistent, reliable build environment for ComplianceAsCode content.

### Container Support Matrix

| Feature | AMD64 (x86_64) | ARM64 (Apple Silicon) |
|---------|----------------|------------------------|
| **Minimal Container** (\`slim\`) | ✅ Full Support | ✅ Cross-Compiled Support |
| **Full Container** (\`latest\`) | ✅ Full Support | ⏳ Pending GH Actions Support |
| **Build Performance** | Standard | ⏳ Optimization Needed |
| **CI/CD Integration** | ✅ Complete | ⚠️ Partial |

## Known Limitations

### 1. GitHub Actions macOS Runners with Docker

Currently, GitHub Actions has limitations with Docker support on macOS runners, especially with ARM64 (Apple Silicon):

- **Issue**: Docker Desktop, Colima, and Lima all have issues running in GitHub Actions macOS environment
- **Status**: [GitHub Issue #2187](https://github.com/actions/runner-images/issues/2187) tracks this problem
- **Workaround**: We're using QEMU cross-compilation for ARM64 builds instead of native builds
- **Future Plan**: Implement native ARM64 builds when GitHub Actions adds stable support

### 2. Certificate Management

For users behind corporate proxies or networks with custom CA certificates:

- Large certificate bundles are split into parts to work within GitHub Actions limits
- See \`scripts/split-cert-for-secrets.sh\` and \`scripts/assemble-certificates.sh\` for implementation details
- Organization-specific certificates are handled securely

## Development Roadmap

### Short Term (Next 3 Months)

- [ ] Optimize ARM64 build performance via build flag tuning
- [ ] Add parallel building for multiple products
- [ ] Improve cache utilization for faster builds
- [ ] Add script to simplify local development setup
- [ ] Create sample workflow for CI/CD integration

### Medium Term (3-6 Months)

- [ ] Add support for container signing
- [ ] Implement compliance report generation
- [ ] Create validation tool for built content
- [ ] Extend platform coverage beyond RHEL and Ubuntu
- [ ] Add ARM64 native build support when GitHub Actions is ready

### Long Term (6+ Months)

- [ ] Add web UI for browsing built content
- [ ] Create integration with vulnerability feeds
- [ ] Support custom policy templates
- [ ] Build compliance scoring dashboard
- [ ] Integration with remediation systems

## Progress Updates

### $(date +"%B %Y")

- ✅ Updated container naming scheme, introducing \`slim\` tag
- ✅ Improved Docker workflow architecture
- ✅ Added cross-platform support strategy
- ✅ Updated GitHub Actions to latest versions

### June 2023

- ✅ Released initial version of CAC-Builder
- ✅ Basic container structure and build process
- ✅ Certificate management system for corporate environments

## How to Contribute

We welcome contributions to any of the roadmap items or to fix existing limitations. Please see our [CONTRIBUTING.md](./CONTRIBUTING.md) for details on how to help.
EOF

echo "Documentation updated"
chmod +x "$SCRIPT_DIR/update-docs.sh"
