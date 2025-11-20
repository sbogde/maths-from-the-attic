# Makefile for LaTeX to Website conversion

# Path to LaTeX source
LATEX_SOURCE = ../antiques-roadshow-algebra-en/main.tex
LATEX_DIR = ../antiques-roadshow-algebra-en

.PHONY: all clean website pdf html serve

# Default target
all: website

# Generate PDF
pdf:
	@echo "Compiling LaTeX to PDF..."
	cd $(LATEX_DIR) && pdflatex -interaction=nonstopmode main.tex
	cd $(LATEX_DIR) && pdflatex -interaction=nonstopmode main.tex
	@cp $(LATEX_DIR)/main.pdf docs/thesis.pdf 2>/dev/null || true

# Generate HTML using pandoc
html:
	@echo "Converting LaTeX to HTML..."
	@mkdir -p docs
	pandoc $(LATEX_SOURCE) \
		--standalone \
		--mathjax \
		--toc \
		--toc-depth=2 \
		--css=style.css \
		--metadata title="The Uniform (Co-Irreducible) Dimension of Rings and Modules" \
		-o docs/index.html

# Generate complete website (HTML + assets)
website: html pdf
	@echo "Website built in docs/"

# Serve website locally
serve:
	@echo "Starting local server at http://localhost:8000"
	@cd docs && python3 -m http.server 8000

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	cd $(LATEX_DIR) && rm -f *.aux *.log *.toc *.out *.pdf
	rm -rf docs/
