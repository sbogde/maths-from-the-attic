#!/bin/bash
# Build script for LaTeX to Website conversion

set -e  # Exit on error

# Path to the LaTeX source
LATEX_SOURCE="../antiques-roadshow-algebra-en/main.tex"

echo "================================================"
echo "  LaTeX to Website Builder"
echo "================================================"
echo ""

# Check if LaTeX source exists
if [ ! -f "$LATEX_SOURCE" ]; then
  echo "❌ Error: LaTeX source not found at $LATEX_SOURCE"
  exit 1
fi

# Check for required tools
echo "Checking dependencies..."

# Try to find pandoc in common locations
PANDOC_PATH=""
if command -v pandoc >/dev/null 2>&1; then
  PANDOC_PATH="pandoc"
elif [ -f /usr/local/bin/pandoc ]; then
  PANDOC_PATH="/usr/local/bin/pandoc"
elif [ -f /opt/homebrew/bin/pandoc ]; then
  PANDOC_PATH="/opt/homebrew/bin/pandoc"
else
  echo "❌ Error: pandoc is not installed."
  echo "   Install with: brew install pandoc"
  exit 1
fi

# Try to find pdflatex in common locations
PDFLATEX_PATH=""
if command -v pdflatex >/dev/null 2>&1; then
  PDFLATEX_PATH="pdflatex"
elif [ -f /usr/local/texlive/2025/bin/universal-darwin/pdflatex ]; then
  PDFLATEX_PATH="/usr/local/texlive/2025/bin/universal-darwin/pdflatex"
elif [ -f /Library/TeX/texbin/pdflatex ]; then
  PDFLATEX_PATH="/Library/TeX/texbin/pdflatex"
else
  echo "❌ Error: pdflatex is not installed."
  echo "   Install with: brew install --cask mactex"
  exit 1
fi

echo "✅ All dependencies found"
echo ""

# Create docs directory
echo "Creating output directory..."
mkdir -p docs
echo "✅ Directory created"
echo ""

# Extract and compile TikZ diagrams to SVG
echo "Extracting TikZ diagrams..."
python3 extract-tikz.py "$LATEX_SOURCE" "$PDFLATEX_PATH"
echo ""

# Compile PDF (in the source directory)
echo "Compiling LaTeX to PDF..."
cd ../antiques-roadshow-algebra-en
$PDFLATEX_PATH -interaction=nonstopmode main.tex > /dev/null 2>&1
$PDFLATEX_PATH -interaction=nonstopmode main.tex > /dev/null 2>&1  # Second pass for references
cd - > /dev/null

if [ -f ../antiques-roadshow-algebra-en/main.pdf ]; then
  cp ../antiques-roadshow-algebra-en/main.pdf docs/thesis.pdf
  echo "✅ PDF generated: docs/thesis.pdf"
else
  echo "⚠️  Warning: PDF generation may have failed"
fi
echo ""

# Convert to HTML
echo "Converting LaTeX to HTML with pandoc..."

$PANDOC_PATH "$LATEX_SOURCE" \
  --standalone \
  --mathjax \
  --toc \
  --toc-depth=2 \
  --css=style.css \
  --lua-filter=tikzcd-filter.lua \
  -o docs/index.html

# Add favicon to HTML
echo "Adding favicon..."
sed -i.bak 's|</head>|  <link rel="icon" type="image/svg+xml" href="favicon.svg">\
</head>|' docs/index.html
rm docs/index.html.bak

echo "✅ HTML generated: docs/index.html"
echo ""

# Clean up auxiliary files in the LaTeX source directory
echo "Cleaning up LaTeX auxiliary files..."
cd ../antiques-roadshow-algebra-en
rm -f *.aux *.log *.toc *.out
cd - > /dev/null
echo "✅ Cleanup complete"
echo ""

echo "================================================"
echo "  ✅ Website build complete!"
echo "================================================"
echo ""
echo "Output location: docs/"
echo "  • HTML: docs/index.html"
echo "  • PDF:  docs/thesis.pdf"
echo ""
echo "To preview locally, run:"
echo "  cd docs && python3 -m http.server 8000"
echo ""
echo "Then open: http://localhost:8000"
echo ""
