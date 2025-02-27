---
layout: default
title: build-product.sh
parent: Utilities
grand_parent: Documentation
nav_order: 1
---

# build-product.sh

This utility script simplifies the process of building specific ComplianceAsCode products within the container.

## Location

`/utils/build-product.sh`

This script is available on the container's PATH, so it can be run from any directory inside the container.

## Purpose

The primary purpose of this script is to:

1. Provide a simple interface for building ComplianceAsCode products
2. Clean up previous build artifacts for the specified product
3. Copy generated files to the output directory mounted from the host
4. Provide feedback on the build process

## Usage

```bash
build-product [product-name] [options]
```

### Parameters

| Parameter | Description |
|-----------|-------------|
| `product-name` | The name of the product to build (e.g., rhel10, ubuntu2204) |

### Options

Additional options can be passed to the underlying `make` command:

```bash
build-product rhel10 --profile stig
```

## Examples

### Building RHEL 10 Content

```bash
build-product rhel10
```

### Building Ubuntu 24.04 Content

```bash
build-product ubuntu2404
```

### Building with Specific Profile

```bash
build-product rhel10 --profile stig
```

## How It Works

The script follows this process:

1. Verifies that a product name was provided
2. Cleans previous build artifacts for the specified product
3. Builds the product using the ComplianceAsCode build system
4. Copies the generated files to the `/output` directory, which is mounted from the host
5. Lists the generated files for verification

## Available Products

To see a list of available products, run the script without any arguments:

```bash
build-product
```

This will display a list of available products that can be built.

## Output

The script generates SCAP content in various formats:

- XCCDF files (security checklists)
- OVAL definitions (technical checks)
- DataStream files (bundled content)
- Ansible playbooks (remediation scripts)
- Bash scripts (remediation scripts)

These files are placed in both the `/content/build` directory inside the container and copied to the `/output` directory, which is mounted from the host's `./output` directory.

## Error Handling

If the build process fails, the script will display an error message and exit with status code 1.