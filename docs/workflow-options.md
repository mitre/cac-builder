# ComplianceAsCode Workflow Options

This document outlines different approaches to building and using the ComplianceAsCode content with the cac-builder tooling.

## Available Workflow Options

### 1. Full Build Workflow

The full build workflow pre-builds common compliance profiles during container creation:

```bash
./setup.sh --build-type full
docker-compose build
docker-compose up -d
```

**Characteristics:**

- Takes ~30 minutes to build the container
- Container size is larger (~2-3GB)
- Common profiles (RHEL10, Ubuntu 24.04) are immediately available
- Good for users who regularly work with standard platforms
- Most convenient for frequent use

**Use cases:**

- Security auditing teams who regularly scan standard OS platforms
- Compliance engineers focused on specific target platforms
- Development environments where build time is less important than usage speed
- CI/CD pipelines where the container is built once and used many times

### 2. Minimal Build Workflow

The minimal build workflow prepares the build environment but defers building specific products:

```bash
./setup.sh --build-type minimal
docker-compose build
docker-compose up -d
```

**Characteristics:**

- Takes ~5-10 minutes to build the container
- Container size is smaller (~1GB)
- Products are built on-demand when needed
- First product build takes ~15 minutes
- Good for users who need occasional or varied platform support

**Use cases:**

- Security researchers working with multiple different platforms
- Testing and development environments with limited disk space
- One-off compliance checks against specific platforms
- Environments where initial container build time is more critical than time to first use

### 3. On-Demand Product Building

Once the container is running (with either build type), you can build specific products on demand:

```bash
# Connect to the container
docker exec -it compliance-as-code bash

# Build a specific product
build-product rhel10

# Build multiple products as needed
build-product ubuntu2404
build-product rhel9
```

### 4. Common Products Quick Start

For minimal build users who want to build multiple common products at once:

```bash
# Connect to the container
docker exec -it compliance-as-code bash

# Build common products
build-common-products
```

This will build RHEL10 and Ubuntu 24.04 products in sequence.

## Workflow Comparison

| Aspect | Full Build | Minimal Build |
|--------|------------|--------------|
| Container build time | ~30 minutes | ~5-10 minutes |
| Container size | ~2-3GB | ~1GB |
| Time to first product use | Immediate | ~15 minutes |
| Disk space required | Higher | Lower |
| Best for | Regular use of common platforms | Varied platform needs |
| Build process | All at once | On-demand |

## Performance Optimization Tips

1. **Parallel Building**
   - The `build-product` script uses `make -j$(nproc)` to use all available cores
   - Ensure your Docker container has sufficient CPU allocation

2. **Volume Mounting**
   - The build output is mounted to the host in `./output/`
   - For faster builds, consider using a fast SSD for this directory

3. **Container Resources**
   - Increase memory allocation for Docker if builds are failing
   - Recommended: At least 4GB RAM for the container

4. **Content Update Strategy**
   - Content is cloned during image build
   - To get the latest content: `docker-compose build --no-cache`

## Integrating with Development Workflow

For developers working on ComplianceAsCode content:

```bash
# Clone the repository locally
git clone https://github.com/ComplianceAsCode/content.git

# Mount your local repository into the container
docker run -it --rm -v ./content:/content -v ./output:/output compliance-as-code bash

# Now make changes in your local repository and build inside the container
cd /content
make rhel10
```

## Integration with CI/CD Pipelines

Example GitHub Actions workflow:

```yaml
name: Build SCAP Content

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up cac-builder
        run: |
          ./setup.sh --build-type minimal
          
      - name: Build container
        run: docker-compose build
        
      - name: Build RHEL10 content
        run: |
          docker-compose up -d
          docker exec compliance-as-code build-product rhel10
          
      - name: Archive SCAP content
        uses: actions/upload-artifact@v2
        with:
          name: scap-content
          path: output/
```

## Choosing the Right Workflow

- Choose **full build** if you prioritize immediate access to common profiles and have sufficient resources
- Choose **minimal build** if you prioritize faster container builds and flexibility for different platforms
- Use **on-demand building** for specific compliance profiles not included in the default build
- Consider **container resources** when deciding between full and minimal builds
