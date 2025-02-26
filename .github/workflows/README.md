# GitHub Actions Workflows

This directory contains GitHub Actions workflows for automating various aspects of the ComplianceAsCode Builder project.

## Active Workflows

### 1. Build and Test (`build-test.yml`)

This workflow runs on every push and pull request to validate that the containers build successfully and function properly.

**What it does:**

- Builds both minimal and full containers
- Tests that the build environment is correctly configured
- Verifies that content can be generated

### 2. Publish Container Images (`publish-container.yml`)

This workflow publishes container images to GitHub Container Registry when changes are pushed to main or a tag is created.

**What it does:**

- Pushes minimal and full container images to ghcr.io
- Tags images appropriately based on version/branch
- Makes containers available for users without building locally

## Security Considerations

All workflows in this repository follow GitHub's security best practices:

1. **Least Privilege Principle**: Workflows are granted only the permissions they need to function:
   - Build & Test workflows: `contents: read`, `packages: read`
   - Publish workflows: `contents: read`, `packages: write`

2. **Secret Management**: Sensitive data like certificates are handled using GitHub Secrets.

3. **Pinned Action Versions**: All external actions use specific versions instead of floating tags.

4. **Workflow Token Permissions**: GitHub's `GITHUB_TOKEN` is granted only required permissions.

For more information about GitHub Actions security, see the [GitHub Actions documentation](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions).

## Usage

### Using the published containers

Pull the containers from GitHub Container Registry:

```bash
# Pull the full container (with pre-built content)
docker pull ghcr.io/mitre/cac-builder:full

# Pull the minimal container (for on-demand builds)
docker pull ghcr.io/mitre/cac-builder:minimal

# Run the container
docker run -it --rm -v ./output:/output ghcr.io/mitre/cac-builder:full bash
```

### Manually triggering workflows

The publish workflow can be manually triggered from the GitHub Actions tab in the repository.

## Planned Workflows

The following workflows are planned for future implementation:

1. **Content Build Workflow** - Automatically builds SCAP content for all platforms
2. **Documentation Verification** - Ensures documentation remains accurate
3. **Dependency Update Workflow** - Keeps dependencies current
4. **Compliance Testing Workflow** - Tests content against reference systems

See [docs/workflow-options.md](../../docs/workflow-options.md) for more information.
