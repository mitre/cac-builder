---
layout: default
title: Getting Started
nav_order: 2
has_children: true
permalink: /getting-started/
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

Follow these detailed guides to get started:

- [Prerequisites](prerequisites/) - What you need before you begin
- [Installation](installation/) - Detailed installation instructions
- [Configuration](configuration/) - How to configure your environment
- [Building Your First Product](first-build/) - Step-by-step guide to building SCAP content
- [Troubleshooting](troubleshooting/) - Common issues and solutions