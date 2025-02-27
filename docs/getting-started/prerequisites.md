---
layout: default
title: Prerequisites
parent: Getting Started
nav_order: 1
---

# Prerequisites for ComplianceAsCode Builder

Before you start using ComplianceAsCode Builder, you'll need to ensure your system meets the following requirements:

## System Requirements

- **Operating System**: Linux, macOS, or Windows with WSL2
- **Memory**: At least 4GB of RAM (8GB recommended)
- **Disk Space**: At least 10GB of free disk space
- **Processor**: 2+ CPU cores recommended

## Software Prerequisites

1. **Docker**
   - Docker Engine (version 20.10 or later)
   - Docker Compose (version 2.0 or later)

2. **Git**
   - For cloning the repository and version control

3. **Bash Shell**
   - Required for running setup scripts
   - Built-in on macOS and Linux
   - Available via WSL2 or Git Bash on Windows

## Required Permissions

- Docker service access (may require sudo/admin privileges)
- Write permissions to the directory where you clone the repository

## Optional Components

- **CA Certificates**: If you're behind a corporate firewall or proxy, you may need organization certificates
- **GitHub Personal Access Token**: For using GitHub Container Registry

## Checking Prerequisites

You can check if you have the necessary prerequisites with the following commands:

```bash
# Check Docker version
docker --version
docker-compose --version

# Check Git version
git --version

# Check available disk space
df -h

# Check memory
free -h  # Linux only
```

## Next Steps

Once you've confirmed your system meets these requirements, you're ready to install ComplianceAsCode Builder.