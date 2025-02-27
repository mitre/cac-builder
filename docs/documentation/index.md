---
layout: default
title: Documentation
nav_order: 3
has_children: true
permalink: /documentation/
---

# Documentation

This section contains detailed documentation on all aspects of the ComplianceAsCode Builder project.

## Overview

ComplianceAsCode Builder is a Docker-based environment for working with the [ComplianceAsCode/content](https://github.com/ComplianceAsCode/content) project. It provides tooling for generating SCAP content and remediation scripts for various platforms.

## Documentation Categories

- [Project Structure](project-structure/) - Learn about the organization of the codebase
- [Build Types](build-types/) - Understand the different build configurations
- [Certificate Management](certificate-management/) - Configure certificates for secure connections
- [Workflow Options](workflow-options/) - Understand the different workflow patterns

## SCAP Content Types

The ComplianceAsCode builder can generate various types of SCAP content:

1. **XCCDF** (Extensible Configuration Checklist Description Format)
   - Primary compliance standard format
   - Contains benchmarks, rules, and profiles
   - Example: `ssg-rhel10-xccdf.xml`

2. **OVAL** (Open Vulnerability and Assessment Language)
   - Technical checking mechanisms
   - Used by XCCDF for automated testing
   - Example: `ssg-rhel10-oval.xml`

3. **DataStreams**
   - Collection format that bundles XCCDF, OVAL, and other content
   - Provides a single file for distribution
   - Example: `ssg-rhel10-ds.xml`

4. **Ansible Playbooks**
   - Remediation scripts in Ansible format
   - Automatically fix non-compliant settings
   - Located in `build/ansible`

5. **Bash Scripts**
   - Remediation scripts in Bash format
   - Fix non-compliant settings on Linux systems
   - Located in `build/bash`