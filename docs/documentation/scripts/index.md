---
layout: default
title: Scripts
parent: Documentation
nav_order: 5
has_children: true
---

# Scripts Reference

This section provides detailed documentation for all the scripts included in the ComplianceAsCode Builder project. These scripts are used for setup, certificate management, testing, and other important functions.

## Scripts Location

All scripts are located in the `/scripts` directory of the project repository.

## Common Script Features

Most scripts in this project:

- Use Bash as the scripting language
- Include usage instructions when run with the `--help` flag
- Follow POSIX-compliant practices when possible
- Use consistent logging and error handling patterns

## Available Scripts

Here's a quick overview of the available scripts:

| Script Name | Description |
|-------------|-------------|
| assemble-certificates.sh | Assembles certificate bundles for container use |
| organize-certs.sh | Organizes certificates into the proper directory structure |
| prepare-ci.sh | Prepares environment for CI/CD workflows |
| reorganize.sh | Reorganizes project files to support new structure |
| split-cert-for-secrets.sh | Splits certificate files for GitHub Secrets use |
| split-cert-smaller.sh | Creates smaller certificate chunks for GitHub Secrets |
| test-github-actions.sh | Tests GitHub Actions workflows locally |
| test-workflows.sh | Tests custom workflows |
| update-dockerfiles.sh | Updates Dockerfile symlinks |
| update-repo-secrets.sh | Updates repository secrets |
| update-workflow-cert-splits.sh | Updates workflow files for certificate handling |

Click on a specific script in the navigation menu to see its detailed documentation.