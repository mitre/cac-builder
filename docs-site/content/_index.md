---
title: "ComplianceAsCode Builder"
linkTitle: "Home"
---

# ComplianceAsCode Builder

{{% blocks/cover title="Welcome to ComplianceAsCode Builder" height="auto" %}}
A Docker-based tooling for working with the ComplianceAsCode/content project, enabling easy generation of SCAP content for various platforms.
{{% /blocks/cover %}}

{{% blocks/section color="primary" %}}
## What is ComplianceAsCode Builder?

ComplianceAsCode Builder provides a containerized environment for working with SCAP content generation. It lets you:

- Generate SCAP content for various platforms (RHEL, Ubuntu, etc.)
- Test compliance rules and profiles
- Create remediation scripts (Ansible, Bash) 
- Customize security benchmarks

Our Docker-based approach ensures a consistent environment for all users, regardless of their host system.
{{% /blocks/section %}}

{{% blocks/section color="secondary" %}}
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

For detailed setup instructions, see [Setting Up Your Local Development Environment](/getting-started/setup/).
{{% /blocks/section %}}

{{% blocks/section color="dark" %}}
## Features

- **Two Build Configurations**: Full (pre-built products) and Minimal (build on-demand)
- **Certificate Management**: Flexible options for using organization certificates
- **Output Types**: XCCDF, OVAL, DataStreams, Ansible Playbooks, and more
- **CI/CD Integration**: GitHub Actions for automated builds and tests
- **Local Workflow Testing**: Test GitHub Actions workflows locally
{{% /blocks/section %}}

{{% blocks/section %}}
## Get Involved

ComplianceAsCode Builder is an open-source project that welcomes contributions from the community. There are many ways to contribute:

- [Star the repository](https://github.com/mitre/cac-builder)
- [Report issues](https://github.com/mitre/cac-builder/issues)
- [Submit pull requests](https://github.com/mitre/cac-builder/pulls)
- Join our community discussions

See our [contribution guidelines](/development/contributing/) for details.
{{% /blocks/section %}}