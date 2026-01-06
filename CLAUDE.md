# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Hugo-based academic course website for "Programming for Statistical Science" (Sta 523). The site structure includes:

- **Hugo static site**: Uses Hugo SSG with custom layouts and themes
- **Quarto presentations**: Lecture slides in `.qmd` format rendered to HTML/PDF
- **R integration**: RStudio project with R-based content and analysis

## Key Directories

- `docs/`: Generated Hugo site (published output)
- `docs/slides/`: Compiled lecture slides (HTML/PDF/QMD source)
- `layouts/`: Hugo templates and partials
- `static/`: Static assets (CSS, images, data files)
- `data/`: YAML configuration data (schedule.yaml)

## Development Commands

### Building the site
```bash
make build          # Build HTML slides, PDFs, and Hugo site
make all            # Build everything (equivalent to: make pdf build)
```

### Working with slides
```bash
make html           # Build only HTML slides from QMD files
make pdf            # Build only PDF slides from HTML files
```

### Development workflow
```bash
make open           # Build site and open docs/index.html in browser
make clean          # Remove all generated files (docs/, HTML/PDF slides)
```

### Publishing
```bash
make push           # Build, commit, and push changes to git
```

## Slide Development

Slides are created as Quarto documents (`.qmd`) using:
- **Format**: `revealjs` with custom theme (`slides.scss`)
- **Engine**: knitr for R code execution
- **Extensions**: Uses `drop` plugin and various Quarto extensions in `_extensions/`
- **Rendering**: `quarto render` for HTML, `renderthis::to_pdf()` for PDF conversion

## Configuration Files

- `config.yaml`: Hugo site configuration with menu, params, and course details
- `Makefile`: Build automation with pattern rules for QMD→HTML→PDF pipeline
- `website.Rproj`: RStudio project settings
- `data/schedule.yaml`: Course schedule data

## R Development Notes

When working with R code in this repository:
- Use `=` for assignment (not `<-`)
- When using external packages, prefer `pkg::function()` syntax
- Minimize single-line comments (only for "why", not "how")