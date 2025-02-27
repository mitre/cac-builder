---
layout: home
title: Home
nav_order: 1
description: "ComplianceAsCode Builder - Docker-based tooling for compliance content generation"
permalink: /
---

# ComplianceAsCode Builder
{: .fs-9 }

Docker-based tooling for working with the ComplianceAsCode/content project, enabling easy generation of SCAP content for various platforms.
{: .fs-6 .fw-300 }

[Get Started](/cac-builder/getting-started/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[View on GitHub](https://github.com/mitre/cac-builder){: .btn .fs-5 .mb-4 .mb-md-0 }

---

## Quick Start

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