---
layout: default
title: Contributing
parent: Development
nav_order: 1
---

# Contributing to ComplianceAsCode Builder

Thank you for considering contributing to ComplianceAsCode Builder! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

Please be respectful and considerate of others when contributing to this project. We expect all contributors to adhere to our [Code of Conduct]({{< relref "/development/code-of-conduct" >}}).

## Project Structure

Before contributing, please familiarize yourself with the [project structure]({{< relref "/documentation/project-structure" >}}).

## Help Wanted

We're currently looking for help with the following areas:

- Additional product support beyond RHEL10 and Ubuntu 24.04
- Performance improvements for build processes
- Enhanced CI/CD integration examples
- Additional documentation for advanced use cases
- Multi-architecture container support
- Creating downloadable build artifacts (zip/tar.gz of RHEL10 and Ubuntu 24.04 SCAP content) for the documentation site

These areas are great places to start if you're looking to make a meaningful contribution to the project.

## How to Contribute

### Setting Up the Development Environment

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/cac-builder.git`
3. Add the upstream repository: `git remote add upstream https://github.com/mitre/cac-builder.git`
4. Create a branch for your work: `git checkout -b my-feature`

### Making Changes

1. Follow the existing code style and organization
2. Add or update documentation as needed
3. Add appropriate test cases
4. Ensure all scripts are executable: `chmod +x *.sh scripts/*.sh utils/*.sh`

### Documentation

- Put general documentation in the `docs/` directory
- Update cross-links between documentation files
- Keep README.md focused on getting started quickly

### Testing Your Changes

1. Run the setup script: `./setup.sh`
2. Build the container: `docker-compose build`
3. Run the container: `docker-compose up -d`
4. Test your changes within the container

### Submitting Changes

1. Commit your changes: `git commit -am 'Add feature XYZ'`
2. Push to your branch: `git push origin my-feature`
3. Create a pull request from your branch to the upstream main branch
4. In your pull request description, explain the changes and the problem they solve

## CI/CD Workflows

When you submit a pull request, GitHub Actions will:

1. Build and test both container types
2. Check for basic functionality

For more information on CI/CD workflows, see [.github/workflows/README.md](.github/workflows/README.md).

## Documentation Guidelines

- Use Markdown for all documentation
- Include code examples where appropriate
- Link to related documentation
- Use section headers for organization

## License

By contributing to this project, you agree that your contributions will be licensed under the project's license.

## Questions

If you have questions about contributing, please open an issue in the repository.
