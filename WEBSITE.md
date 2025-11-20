# Website Generation Guide

This LaTeX project can be automatically converted to a static website.

## Quick Start

### 1. Build the website locally

```bash
chmod +x build-website.sh
./build-website.sh
```

Or using Make:

```bash
make website
```

### 2. Preview locally

```bash
make serve
```

Then open http://localhost:8000 in your browser.

## Requirements

- **pandoc**: `brew install pandoc`
- **LaTeX**: `brew install --cask mactex` (or BasicTeX for minimal install)
- **Python 3**: For local preview server (usually pre-installed on macOS)

## Output

The build process generates:

- `docs/index.html` - The website
- `docs/thesis.pdf` - PDF version
- `docs/style.css` - Styling (already created)

## GitHub Pages Deployment

Since you can only pull (not push) to this repo, you have two options:

### Option A: Fork and Deploy

1. Fork this repository to your own GitHub account
2. Enable GitHub Pages in Settings → Pages → Source: `gh-pages` branch
3. The GitHub Action will automatically build and deploy on every commit
4. Your site will be available at: `https://yourusername.github.io/maths-from-the-attic/`

### Option B: Manual Export

1. Build locally: `./build-website.sh`
2. Create a new repository for the website
3. Copy the `docs/` folder contents
4. Enable GitHub Pages pointing to the root or docs folder

## Customization

### Styling

Edit `docs/style.css` to change colors, fonts, layout, etc.

### Content

The HTML is automatically generated from `main.tex`. To update:

1. Edit your LaTeX source
2. Rebuild: `./build-website.sh`

### Advanced: Custom Template

Create a custom pandoc template:

```bash
pandoc -D html > custom-template.html
# Edit custom-template.html
pandoc main.tex --template=custom-template.html -o docs/index.html
```

## Make Commands

- `make pdf` - Generate PDF only
- `make html` - Generate HTML only
- `make website` - Generate complete website (HTML + PDF)
- `make serve` - Start local development server
- `make clean` - Remove generated files

## Troubleshooting

**Error: pandoc not found**

```bash
brew install pandoc
```

**Error: pdflatex not found**

```bash
brew install --cask mactex
# Or for minimal install:
brew install --cask basictex
```

**Math not rendering**

- The website uses MathJax for math rendering
- Ensure you have an internet connection when viewing
- Math will render in the browser after loading MathJax

**PDF not generating**

- Check for LaTeX errors: `pdflatex main.tex`
- Ensure all packages are installed
- Run `pdflatex` twice for references

## Alternative Tools

If pandoc doesn't work well for your thesis, try:

1. **LaTeXML**: Better LaTeX→HTML conversion

   ```bash
   brew install latexml
   latexml main.tex --dest=main.xml
   latexmlpost main.xml --dest=docs/index.html
   ```

2. **TeX4ht**: Direct LaTeX→HTML

   ```bash
   htlatex main.tex
   ```

3. **PDF.js**: Embed PDF in website
   - Just create a simple HTML that embeds the PDF viewer

## Live Preview During Development

For real-time preview while editing:

```bash
# Terminal 1: Watch and rebuild
while true; do inotifywait -e modify main.tex && make website; done

# Terminal 2: Serve
make serve
```

On macOS without inotifywait:

```bash
# Terminal 1
fswatch -o main.tex | xargs -n1 -I{} make website

# Terminal 2
make serve
```
