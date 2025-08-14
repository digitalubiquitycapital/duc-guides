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

# Deploy to GitHub Pages (local deployment)
deploy-local: build pdf
	@echo "🚀 Deploying to GitHub Pages from local..."
	@echo "📄 Copying PDFs to site directory..."
	mkdir -p site/pdfs
	cp -r pdfs/* site/pdfs/ 2>/dev/null || true
	@echo "🔧 Adding .nojekyll file..."
	touch site/.nojekyll
	./venv/bin/mkdocs gh-deploy --force --clean --verbose
	@echo "✅ Documentation deployed to GitHub Pages"

# Deploy via GitHub Actions (recommended)
deploy: 
	@echo "🚀 Triggering GitHub Actions deployment..."
	@echo "📝 Checking git status..."
	@git status
	@echo ""
	@echo "📦 To deploy via GitHub Actions:"
	@echo "  1. Commit your changes: make commit"
	@echo "  2. Push to main: git push origin main"
	@echo "  3. GitHub Actions will automatically deploy"
	@echo ""
	@echo "Or use 'make deploy-local' for direct deployment"

# GitHub Pages specific build
gh-pages-build: clean
	@echo "🏗️ Building for GitHub Pages..."
	@echo "🔧 Creating .nojekyll file..."
	touch docs/.nojekyll
	./venv/bin/mkdocs build --strict
	touch site/.nojekyll
	@echo "✅ Site built for GitHub Pages in ./site/"

# Commit changes (helper for deployment)
commit:
	@echo "📝 Preparing to commit changes..."
	@git add -A
	@git status
	@echo ""
	@read -p "Enter commit message: " msg; \
	git commit -m "$$msg" || echo "No changes to commit"

# Push to GitHub
push:
	@echo "⬆️ Pushing to GitHub..."
	git push origin main
	@echo "✅ Pushed to GitHub. Check Actions tab for deployment status."

# Full deployment workflow
deploy-full: build test commit push
	@echo "✅ Full deployment initiated. Check GitHub Actions for status."
	@echo "🔗 View at: https://digitalubiquitycapital.github.io/duc-guides/"

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

# GitHub Actions status
status:
	@echo "📊 Checking deployment status..."
	@echo "🔗 GitHub Actions: https://github.com/digitalubiquitycapital/duc-guides/actions"
	@echo "🌐 Live Site: https://digitalubiquitycapital.github.io/duc-guides/"
	@echo ""
	@echo "📝 Current branch:"
	@git branch --show-current
	@echo ""
	@echo "📦 Last commit:"
	@git log -1 --oneline

# Initialize GitHub Pages
init-gh-pages:
	@echo "🎯 Initializing GitHub Pages..."
	@echo "1. Go to: https://github.com/digitalubiquitycapital/duc-guides/settings/pages"
	@echo "2. Set Source: 'GitHub Actions'"
	@echo "3. Save the settings"
	@echo ""
	@echo "Then run: make deploy-full"

# Preview before deployment
preview:
	@echo "👁️ Building preview..."
	@make build
	@echo "🌐 Starting preview server..."
	@echo "Visit: http://localhost:8000"
	./venv/bin/mkdocs serve

# Validate GitHub Actions workflow
validate-workflow:
	@echo "✅ Validating GitHub Actions workflow..."
	@if [ -f .github/workflows/deploy.yml ]; then \
		echo "✓ Workflow file exists"; \
		echo "✓ Location: .github/workflows/deploy.yml"; \
	else \
		echo "✗ Workflow file missing!"; \
		echo "Run: make init-gh-pages"; \
	fi

# Create a release
release: clean all
	@echo "📦 Creating release package..."
	mkdir -p releases
	tar -czf releases/duc-docs-$(shell date +%Y%m%d).tar.gz site/ pdfs/
	@echo "✅ Release package created"