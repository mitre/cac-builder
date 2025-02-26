# ComplianceAsCode Container Build Options

This document explains the different build options available for the ComplianceAsCode container.

## Full Build vs. Minimal Build

### Full Build (`Dockerfile`)

The full build pre-builds common compliance profiles during container creation:

```bash
./setup.sh --build-type full
```

**Characteristics:**

- Takes ~30 minutes to build the container
- Container size is larger (~2-3GB)
- Common profiles (RHEL10, Ubuntu 24.04) are immediately available
- Good for users who regularly work with standard platforms

**When to use:**

- You frequently work with the same platforms
- You have powerful hardware for container builds
- You prefer immediate access to built profiles
- Time to first use is more important than build time

### Minimal Build (`Dockerfile.optimized`)

The minimal build only prepares the build environment without building any products:

```bash
./setup.sh --build-type minimal
```

**Characteristics:**

- Takes ~5-10 minutes to build the container
- Container size is smaller (~1GB)
- Products are built on first use
- First product build takes ~15 minutes
- Good for users who need occasional or varied platform support

**When to use:**

- You work with many different platforms
- You need to conserve disk space
- You prefer faster container builds
- Build time is more important than time to first use

## How To Choose

1. If you regularly work with RHEL and Ubuntu, use the full build
2. If you work with varied platforms or have limited disk space, use the minimal build
3. If you prefer to build once and use many times, use full build
4. If you prefer fast setup and don't mind waiting for first product build, use minimal build

## Switching Between Build Types

You can switch between build types without losing data:

```bash
# Switch to minimal build
./setup.sh --build-type minimal
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Switch to full build
./setup.sh --build-type full
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

Your output files in the `./output/` directory will remain unchanged.
