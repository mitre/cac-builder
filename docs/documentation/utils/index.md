---
layout: default
title: Utilities
parent: Documentation
nav_order: 6
has_children: true
---

# Utilities Reference

This section provides detailed documentation for the utility scripts that run within the ComplianceAsCode Builder container. These utilities help with building products, managing certificates, and other container-specific tasks.

## Utilities Location

All utility scripts are located in the `/utils` directory of the project repository and are copied into the container during the build process.

## Available Utilities

Here's a quick overview of the available utility scripts:

| Utility Name | Description |
|--------------|-------------|
| build-common-products.sh | Builds commonly used ComplianceAsCode products |
| build-product.sh | Builds a specific ComplianceAsCode product |
| copy-extra-cert.sh | Copies additional certificates into the container |
| init-environment.sh | Initializes the container environment |
| welcome.sh | Displays welcome message when entering the container |

Click on a specific utility in the navigation menu to see its detailed documentation.