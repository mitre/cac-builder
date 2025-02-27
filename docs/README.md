# ComplianceAsCode Builder Documentation

This directory contains the documentation for the ComplianceAsCode Builder project.

## Local Development

To preview the documentation site locally:

1. Install Jekyll and Ruby dependencies:
```bash
cd docs
gem install bundler
bundle install
```

2. Run the Jekyll server:
```bash
bundle exec jekyll serve
```

3. Open your browser to http://localhost:4000/cac-builder/

## Structure

The documentation is organized into sections:

- Getting Started - Quick guides to help you get up and running
- Documentation - Detailed guides on aspects of the project
- Development - Information for contributors and developers

## Adding new content

1. Create a Markdown file in the appropriate directory
2. Add front matter to the top of the file:
```yaml
---
layout: default
title: Your Page Title
parent: Section Name
nav_order: 1
---
```

3. Write your content in Markdown format
4. Link to other pages using relative links with the Jekyll relref shortcode:
```markdown
[Link text]({{< relref "/section/page" >}})
```

## Jekyll Theme

This documentation uses the [Just the Docs](https://just-the-docs.github.io/just-the-docs/) theme with dark mode enabled.