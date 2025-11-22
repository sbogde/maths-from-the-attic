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

# Generate build timestamp for cache busting
BUILD_TIMESTAMP=$(date +%s)
echo "Build timestamp: $BUILD_TIMESTAMP"

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

# Copy favicon
echo "Setting up favicon and PWA assets..."
cp docs/infinity-7-layered.svg docs/favicon.svg

# Generate PWA manifest
cp manifest-template.json docs/manifest.json

# Generate PWA icons from SVG
python3 generate-pwa-icons.py

# Copy service worker
cp sw-template.js docs/sw.js

# Add PWA meta tags and favicon to HTML
echo "Adding PWA support to HTML..."
sed -i.bak 's|</head>|  <link rel="icon" type="image/svg+xml" href="favicon.svg?v='"$BUILD_TIMESTAMP"'">\
  <link rel="manifest" href="manifest.json">\
  <meta name="theme-color" content="#2c3e50">\
  <meta name="apple-mobile-web-app-capable" content="yes">\
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">\
  <meta name="apple-mobile-web-app-title" content="Uniform Dimension">\
  <link rel="apple-touch-icon" href="icon-192.png">\
</head>|' docs/index.html

# Add service worker registration before </body>
sed -i.bak2 's|</body>|<script>\
  if ("serviceWorker" in navigator) {\
    navigator.serviceWorker.register("/sw.js?v='"$BUILD_TIMESTAMP"'")\
      .then(reg => console.log("Service Worker registered", reg))\
      .catch(err => console.log("Service Worker registration failed", err));\
  }\
</script>\
</body>|' docs/index.html

# Add cache busting to CSS link
sed -i.bak3 's|href="style.css"|href="style.css?v='"$BUILD_TIMESTAMP"'"|' docs/index.html

rm docs/index.html.bak docs/index.html.bak2 docs/index.html.bak3
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
