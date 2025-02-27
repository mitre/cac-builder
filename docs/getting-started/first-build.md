---
layout: default
title: Building Your First Product
parent: Getting Started
nav_order: 4
---

# Building Your First ComplianceAsCode Product

This guide walks you through building your first SCAP content product using ComplianceAsCode Builder.

## Prerequisites

Before proceeding, ensure you have:

1. Installed the ComplianceAsCode Builder
2. Configured your environment as needed
3. Started the container with `docker-compose up -d`

## Step 1: Connect to the Container

First, connect to the running container:

```bash
docker exec -it compliance-as-code bash
```

You should now have a shell prompt inside the container.

## Step 2: Explore Available Products

The ComplianceAsCode project supports many different products. To see what's available:

```bash
# Inside the container
cd /content
./build_product.py --list-products
```

This will display all available products you can build.

## Step 3: Build a Product

Let's build RHEL 10 content as an example:

```bash
# Inside the container, using the provided utility
build-product rhel10
```

The build process will:

1. Generate XCCDF files (security checklists)
2. Create OVAL definitions (technical checks)
3. Compile DataStream files (bundled content)
4. Generate remediation scripts (Ansible, Bash)

This may take a few minutes depending on your system performance.

## Step 4: Verify the Build

Once the build completes, verify the generated files:

```bash
# Inside the container
ls -la /output
```

You should see various files including:
- `ssg-rhel10-ds.xml` (DataStream file)
- `ssg-rhel10-xccdf.xml` (XCCDF benchmark)
- `ansible/` directory (with Ansible remediation playbooks)
- `bash/` directory (with Bash remediation scripts)

## Step 5: Build Additional Products

You can build additional products using the same command:

```bash
# Build Ubuntu 24.04 content
build-product ubuntu2404

# Build CentOS 9 content
build-product centos9
```

## Step 6: Access Output Files

The generated files are available both inside the container and on your host system:

- Inside container: `/output/`
- Host system: `./output/` (in your project directory)

You can use these files with SCAP scanning tools like OpenSCAP.

## Working with Profiles

Each product contains multiple security profiles. To list available profiles for RHEL 10:

```bash
# Inside the container
oscap info /output/ssg-rhel10-ds.xml
```

To build content for a specific profile only:

```bash
# Example: Build only the DISA STIG profile for RHEL 10
build-product rhel10 --profile stig
```

## Next Steps

Now that you've built your first product, you can:

1. Learn how to customize security profiles
2. Explore different build types
3. Try scanning systems with the generated content