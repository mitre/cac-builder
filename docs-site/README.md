# ComplianceAsCode Builder Documentation

This directory contains the documentation website for the ComplianceAsCode Builder project, built with [Hugo](https://gohugo.io/) and the [Docsy](https://www.docsy.dev/) theme.

## Documentation Source

**IMPORTANT:** Most documentation content is automatically synchronized from the main Markdown files in the repository. 

- Do not edit the Markdown files in the `content/` directory directly
- Instead, edit the source files in the repository root and `docs/` directory
- Run the `./scripts/sync-docs.sh` script to update the Hugo content

This ensures we maintain a single source of truth for documentation.

## Local Development

### Prerequisites

1. Install Hugo (Extended version)
   ```bash
   # macOS
   brew install hugo
   
   # Windows
   choco install hugo-extended
   
   # Linux
   snap install hugo --channel=extended
   ```

2. Install Node.js and npm (for Docsy theme dependencies)
   ```bash
   # macOS
   brew install node
   
   # Windows
   choco install nodejs
   
   # Linux
   apt install nodejs npm
   ```

### Setting Up

1. Install Docsy theme dependencies
   ```bash
   cd themes/docsy
   npm install
   ```

### Running Locally

1. Start the Hugo development server
   ```bash
   cd docs-site
   hugo server
   ```

2. View the site at http://localhost:1313/

## Adding Content

### Creating New Pages

1. Create a new page in the appropriate section
   ```bash
   hugo new content/docs/my-page.md
   ```

2. Edit the new page with your content
   ```md
   ---
   title: "My Page"
   linkTitle: "My Page"
   weight: 50
   description: Description of my page
   ---

   # My Page Content

   This is my new page.
   ```

### Page Organization

- `_index.md` files define section landing pages
- `weight` in frontmatter controls the ordering
- `linkTitle` controls the navigation menu text

## Building for Production

The site is automatically built and deployed to GitHub Pages when changes are pushed to the `main` branch.

To build manually:

```bash
hugo --minify
```

The built site will be in the `public/` directory.

## Documentation Structure

- `content/` - The documentation content
  - `_index.md` - Homepage
  - `docs/` - Main documentation
  - `getting-started/` - Getting started guides
  - `development/` - Development guides
- `static/` - Static assets like images
- `layouts/` - Custom Hugo layouts (if needed)
- `themes/docsy/` - The Docsy theme (submodule)

## Style Guide

- Use Markdown for content
- Use Hugo shortcodes for complex elements
- Follow the Docsy conventions for alerts, notes, etc.
- Use relative links for internal navigation