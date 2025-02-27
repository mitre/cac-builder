---
layout: default
title: Development
nav_order: 4
has_children: true
permalink: /development/
---

# Development Guide

This section provides information for developers who want to contribute to the ComplianceAsCode Builder project.

## Development Workflow

If you're interested in contributing to ComplianceAsCode Builder, here's the general workflow:

1. Fork the repository on GitHub
2. Create a new branch for your changes
3. Make your changes and test them locally
4. Submit a pull request to the main repository
5. Address any feedback from reviewers

## Developer Documentation

The following guides will help you set up your development environment and understand the project's workflow:

- [Contributing](contributing/) - Guidelines for contributing to the project
- [Local Development](local-workflow/) - How to set up your local development environment
- [Installing Act](installing-act/) - How to set up the Act tool for testing GitHub Actions locally

## GitHub Actions Workflows

This project includes several GitHub Actions workflows for automating builds, tests, and deployments:

- Build and test containers
- Publishing images to GitHub Container Registry
- Documentation site generation

For more information on testing these workflows locally, see the [Installing Act](installing-act/) guide.