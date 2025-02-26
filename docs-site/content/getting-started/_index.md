---
title: "Getting Started"
linkTitle: "Getting Started"
weight: 20
menu:
  main:
    weight: 20
---

# Getting Started with ComplianceAsCode Builder

This section provides quick guides to help you get up and running with ComplianceAsCode Builder.

## Quick Start Guide

To get started with ComplianceAsCode Builder:

```bash
# Clone the repository
git clone https://github.com/mitre/cac-builder.git
cd cac-builder

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

Check the `output/` directory for generated SCAP content.

## Detailed Setup Guides

- [Prerequisites](/getting-started/prerequisites/): What you need before you begin
- [Installation](/getting-started/installation/): Detailed installation instructions
- [Configuration](/getting-started/configuration/): How to configure your environment
- [Building Your First Product](/getting-started/first-build/): Step-by-step guide to building SCAP content
- [Troubleshooting](/getting-started/troubleshooting/): Common issues and solutions