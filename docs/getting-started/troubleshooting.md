---
layout: default
title: Troubleshooting
parent: Getting Started
nav_order: 5
---

# Troubleshooting ComplianceAsCode Builder

This guide addresses common issues you might encounter when using ComplianceAsCode Builder and provides solutions.

## Docker-Related Issues

### Container Won't Start

**Issue**: The container fails to start after running `docker-compose up -d`.

**Solutions**:
1. Check Docker logs:
   ```bash
   docker-compose logs
   ```

2. Verify Docker is running:
   ```bash
   docker info
   ```

3. Ensure you have sufficient permissions:
   ```bash
   # Linux users may need to run Docker with sudo or add user to docker group
   sudo docker-compose up -d
   ```

4. Check for port conflicts:
   ```bash
   # If other services are using the same ports
   docker-compose down
   docker-compose up -d
   ```

### Disk Space Issues

**Issue**: Build fails with disk space errors.

**Solutions**:
1. Clear Docker cache:
   ```bash
   docker system prune -a
   ```

2. Free up disk space on your host system

3. Increase Docker's disk allocation (in Docker Desktop settings)

## Build Failures

### Certificate Issues

**Issue**: Build fails with SSL/certificate errors.

**Solutions**:
1. Verify your certificates are correctly installed:
   ```bash
   ./setup.sh --cert /path/to/ca-bundle.pem
   ```

2. For testing purposes, you can disable certificate verification:
   ```bash
   ./setup.sh --no-cert
   ```

3. Check for proxy issues if you're behind a corporate firewall

### Python Dependency Issues

**Issue**: Build fails with Python package errors.

**Solution**:
Rebuild the container to ensure all dependencies are installed:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Product-Specific Issues

### Product Build Failures

**Issue**: Specific product fails to build.

**Solutions**:
1. Update the ComplianceAsCode content:
   ```bash
   # Inside the container
   cd /content
   git pull
   ```

2. Ensure you're using the correct product name:
   ```bash
   # Check available products
   ./build_product.py --list-products
   ```

3. Try building with verbose output:
   ```bash
   build-product rhel10 --verbose
   ```

### Missing Output Files

**Issue**: Build completes but some output files are missing.

**Solution**:
Check for build warnings or errors in the output. Some products might not generate all file types.

## Connection Issues

### Can't Connect to the Container

**Issue**: Unable to connect to the container with `docker exec`.

**Solutions**:
1. Verify the container is running:
   ```bash
   docker ps | grep compliance-as-code
   ```

2. If not running, start it:
   ```bash
   docker-compose up -d
   ```

3. Try connecting with the full container ID:
   ```bash
   docker ps
   docker exec -it <full-container-id> bash
   ```

## Repository and Git Issues

### Git Authentication Failures

**Issue**: Git operations fail with authentication errors.

**Solution**:
If using GitHub Container Registry or making Git operations:
```bash
# Set up Git credentials in the container
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Performance Issues

### Slow Builds

**Issue**: Builds are taking too long.

**Solutions**:
1. Use a minimal build type if you only need specific products:
   ```bash
   ./setup.sh --build-type minimal
   ```

2. Allocate more resources to Docker (CPU/memory in Docker Desktop settings)

3. Use the pre-built products if available (in full build mode)

## Getting Additional Help

If you're still experiencing issues:

1. Check the [GitHub Issues](https://github.com/mitre/cac-builder/issues) to see if others have reported similar problems
2. Report new issues with detailed information about your environment and the specific error messages
3. Join the ComplianceAsCode community discussions for assistance