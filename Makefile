# DUC Capital Platform Documentation Makefile

.PHONY: help install serve build pdf deploy clean test

# Default target
help:
	@echo "DUC Capital Platform Documentation - Available Commands:"
	@echo ""
	@echo "  make install    - Install Python dependencies"
	@echo "  make serve      - Start local documentation server"
	@echo "  make build      - Build HTML documentation"
	@echo "  make pdf        - Generate PDF documentation"
	@echo "  make deploy     - Deploy to GitHub Pages"
	@echo "  make clean      - Clean build artifacts"
	@echo "  make test       - Test documentation build"
	@echo "  make all        - Build everything (HTML + PDF)"
	@echo ""

# Install dependencies
install:
	@echo "📦 Installing dependencies..."
	python3 -m venv venv
	./venv/bin/pip install --upgrade pip
	./venv/bin/pip install -r requirements.txt
	./venv/bin/pip install mkdocs-with-pdf beautifulsoup4 libsass
	@echo "✅ Dependencies installed"

# Serve documentation locally
serve:
	@echo "🚀 Starting documentation server..."
	@echo "📍 Visit http://127.0.0.1:8000"
	./venv/bin/mkdocs serve

# Build HTML documentation
build:
	@echo "🏗️ Building HTML documentation..."
	./venv/bin/mkdocs build
	@echo "✅ HTML documentation built in ./site/"

# Generate PDF documentation
pdf:
	@echo "📄 Generating PDF documentation..."
	./venv/bin/python generate_pdfs.py
	@echo "✅ PDF documentation generated in ./pdfs/"

# Build everything
all: build pdf
	@echo "✅ All documentation formats built successfully"

# Deploy to GitHub Pages
deploy: build pdf
	@echo "🚀 Deploying to GitHub Pages..."
	@echo "📄 Copying PDFs to site directory..."
	mkdir -p site/pdfs
	cp -r pdfs/* site/pdfs/ 2>/dev/null || true
	./venv/bin/mkdocs gh-deploy --force
	@echo "✅ Documentation deployed to GitHub Pages"

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf site/
	rm -rf pdfs/
	rm -f mkdocs-*.yml
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	@echo "✅ Build artifacts cleaned"

# Test documentation build
test:
	@echo "🧪 Testing documentation build..."
	./venv/bin/mkdocs build --strict
	@echo "✅ Documentation build test passed"

# Development setup
dev: install
	@echo "🛠️ Setting up development environment..."
	./venv/bin/pip install mkdocs-material-extensions
	@echo "✅ Development environment ready"

# Update dependencies
update:
	@echo "🔄 Updating dependencies..."
	./venv/bin/pip install --upgrade -r requirements.txt
	./venv/bin/pip freeze > requirements.txt
	@echo "✅ Dependencies updated"

# Check for broken links
check-links:
	@echo "🔍 Checking for broken links..."
	./venv/bin/mkdocs build --strict
	@echo "✅ No broken links found"

# Create a release
release: clean all
	@echo "📦 Creating release package..."
	mkdir -p releases
	tar -czf releases/duc-docs-$(shell date +%Y%m%d).tar.gz site/ pdfs/
	@echo "✅ Release package created"