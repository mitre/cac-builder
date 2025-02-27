---
layout: home
title: Home
nav_order: 1
description: "ComplianceAsCode Builder - Docker-based tooling for compliance content generation"
permalink: /
---

# ComplianceAsCode Builder
{: .fs-9 }

Docker-based tooling for working with the ComplianceAsCode/content project, enabling easy generation of SCAP content for various platforms. Pre-built containers include ready-to-use SCAP content for RHEL10 and Ubuntu 24.04.
{: .fs-6 .fw-300 }

[Get Started](/cac-builder/getting-started/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[View on GitHub](https://github.com/mitre/cac-builder){: .btn .fs-5 .mb-4 .mb-md-0 }

---

## Pre-built Containers

We provide ready-to-use container images with pre-built SCAP content for RHEL10 and Ubuntu 24.04:

```bash
# Pull the full version (with pre-built content)
docker pull ghcr.io/mitre/cac-builder:full

# Run the container
docker run -it --name compliance-as-code -v $(pwd)/output:/output ghcr.io/mitre/cac-builder:full bash

# Inside the container, the pre-built products are already available
ls /content/build/
```

## Build Locally

If you prefer to build the container locally:

```bash
# Setup the environment
./setup.sh

# Build and start the container
docker-compose build
docker-compose up -d

# Connect to the container
docker exec -it compliance-as-code bash

# Build a specific product
build-product rhel10
```

For detailed setup instructions, see [Setting Up Your Local Development Environment](/cac-builder/getting-started/setup/).

## What is ComplianceAsCode Builder?

ComplianceAsCode Builder provides a containerized environment for working with SCAP content generation. It lets you:

- Generate SCAP content for various platforms (RHEL, Ubuntu, etc.)
- Test compliance rules and profiles
- Create remediation scripts (Ansible, Bash)
- Customize security benchmarks

Our Docker-based approach ensures a consistent environment for all users, regardless of their host system.

## Features

### Build Options
Two build configurations: Full (pre-built products) and Minimal (build on-demand) to suit different needs.

### Certificate Management
Flexible options for using organization certificates for secure connections.

### Multiple Output Types
XCCDF, OVAL, DataStreams, Ansible Playbooks, and more compliance formats.

### CI/CD Integration
GitHub Actions for automated builds, tests, and local workflow testing.

## Get Involved

ComplianceAsCode Builder is an open-source project that welcomes contributions from the community.

[Contributing Guidelines](/cac-builder/development/contributing/){: .btn .btn-blue }

## Help Wanted

We're looking for contributors to help with:

- Additional product support beyond RHEL10 and Ubuntu 24.04
- Performance improvements for build processes
- Enhanced CI/CD integration examples
- Additional documentation for advanced use cases
- Multi-architecture container support
- Creating downloadable build artifacts (zip/tar.gz of RHEL10 and Ubuntu 24.04 SCAP content) for the documentation site

If you're interested in working on these or other improvements, please check our [open issues](https://github.com/mitre/cac-builder/issues) or create a new one to discuss your ideas.

[View Open Issues](https://github.com/mitre/cac-builder/issues){: .btn .btn-green }