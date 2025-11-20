# Maths from the Attic

Website builder for the LaTeX thesis project.

## Overview

This folder contains the website generation tools for the `antiques-roadshow-algebra-en` LaTeX project. The LaTeX source remains in its original repository (pull-only for security), while this folder handles the HTML conversion and hosting.

## Quick Start

```bash
# Build the website
./build-website.sh

# Preview locally
cd docs && python3 -m http.server 8000
```

Then open http://localhost:8000 in your browser.

## Structure

- `build-website.sh` - Main build script
- `Makefile` - Alternative build automation
- `docs/` - Generated website output
  - `index.html` - Main website
  - `thesis.pdf` - PDF version
  - `style.css` - Styling
- `WEBSITE.md` - Detailed documentation

## How It Works

1. Reads LaTeX source from `../antiques-roadshow-algebra-en/main.tex`
2. Compiles to PDF using `pdflatex`
3. Converts to HTML using `pandoc`
4. Outputs everything to `docs/`

This keeps the original LaTeX repository clean (no generated files) while allowing full website functionality here.

## Requirements

```bash
brew install pandoc           # HTML conversion
brew install --cask mactex    # LaTeX compiler
```

## Make Commands

- `make website` - Build everything
- `make html` - HTML only
- `make pdf` - PDF only
- `make serve` - Start local server
- `make clean` - Remove generated files
