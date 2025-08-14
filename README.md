# DUC Capital Platform Documentation

![DUC Logo](DUC-Logo.png)

Welcome to the comprehensive documentation for the DUC Capital Platform - an integrated suite for managing the complete capital lifecycle from deal origination through tokenization to ongoing asset management.

## 🚀 Live Documentation

Visit the documentation at: [https://digitalubiquitycapital.github.io/duc-guides/](https://digitalubiquitycapital.github.io/duc-guides/)

## 📚 Platform Components

### 📊 **Sagacity - Corporate Finance & Deal Preparation**
- **Purpose:** Front-end of capital lifecycle for deal origination, evaluation, and structuring
- **Users:** Investment bankers, M&A advisors, corporate development teams, PE professionals
- **Output:** Validated deal books ready for tokenization

### 🔗 **Bridge - Tokenization & Capital Structuring**
- **Purpose:** Transform validated deals into compliant, investor-ready tokenized assets
- **Users:** Capital markets professionals, tokenization specialists, compliance officers
- **Output:** Live tokenized instruments with investors onboarded

### 📈 **Lift - Execution & Asset Management**
- **Purpose:** Operational management and performance monitoring of tokenized assets
- **Users:** Asset managers, project managers, operations teams
- **Output:** Performance data feeding back for benchmarking and investor updates

## 🛠️ Quick Start

### Prerequisites
- Python 3.9+
- Make
- Git

### Installation & Setup

```bash
# Clone the repository
git clone https://github.com/digitalubiquitycapital/duc-guides.git
cd duc-guides

# Install dependencies using Make
make install

# Or manually:
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### Available Make Commands

```bash
make help         # Show all available commands
make install      # Install dependencies
make serve        # Start local development server
make build        # Build HTML documentation
make pdf          # Generate PDF documentation
make test         # Test documentation build
make deploy       # Deploy to GitHub Pages
make status       # Check deployment status
make preview      # Preview before deployment
make clean        # Clean build artifacts
```

## 📦 Deployment

### Automatic Deployment (GitHub Actions)

This documentation is automatically deployed to GitHub Pages when changes are pushed to the main branch.

```bash
# Full deployment workflow
make deploy-full

# Or step by step:
make build        # Build documentation
make test         # Test for errors
make commit       # Commit changes
make push         # Push to GitHub (triggers deployment)
```

### Manual Deployment

```bash
# Deploy directly from local
make deploy-local

# Or using mkdocs directly
mkdocs gh-deploy --force
```

### GitHub Actions Workflow

The `.github/workflows/deploy.yml` workflow automatically:
1. Builds the documentation on every push to main
2. Validates all links and references
3. Deploys to GitHub Pages
4. Makes the site available at the GitHub Pages URL

## 🎨 Features

- **Custom Theme**: Beautiful DUC branding with orange (#E68A6B) and charcoal (#3E4147) color scheme
- **Dark/Light Mode**: Toggle between themes for comfortable reading
- **Full-Text Search**: Search across all documentation
- **Mobile Responsive**: Optimized for all device sizes
- **PDF Export**: Download documentation for offline reading
- **Mermaid Diagrams**: Visual workflow representations
- **Code Highlighting**: Syntax highlighting for examples
- **Version Control**: Full history and rollback capability

## 📝 Documentation Structure

```
docs/
├── index.md                 # Home page
├── getting-started/         # Platform overview
│   ├── overview.md         # Understanding the platform
│   ├── lifecycle-flow.md   # Complete deal lifecycle
│   ├── choosing-app.md     # Role-based navigation
│   └── quick-start.md      # Getting started guide
│
├── sagacity/               # Deal preparation platform
│   ├── deals/             # Deal lifecycle (origination → close)
│   ├── ai-tools/          # AI-powered analysis tools
│   └── deliverables/      # Reports and outputs
│
├── bridge/                 # Tokenization platform
│   ├── tokenization/      # Asset tokenization
│   ├── structuring/       # Capital structuring
│   ├── compliance/        # KYC/AML and regulations
│   └── investors/         # Investor management
│
├── lift/                   # Asset management platform
│   ├── execution/         # Milestone tracking
│   ├── performance/       # Metrics and KPIs
│   ├── compliance/        # Covenant monitoring
│   └── portfolio/         # Portfolio management
│
├── integration/            # Platform integration
│   ├── lifecycle.md       # Deal flow integration
│   ├── data-flow.md       # Data architecture
│   └── api-reference.md   # API documentation
│
└── help/                   # Support resources
    ├── glossary.md        # Terms and definitions
    ├── faq.md            # Common questions
    └── contact.md        # Support contacts
```

## 🔧 Platform Workflow

```
Sagacity (Deal Prep) → Bridge (Tokenization) → Lift (Management)
     ↓                        ↓                      ↓
Deal Book              Token Issuance         Performance Data
                                                     ↓
                                              Feedback Loop
```

## 🤝 Contributing

We welcome contributions to improve our documentation!

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Make your changes
4. Test locally (`make test`)
5. Commit changes (`git commit -am 'Add improvement'`)
6. Push to branch (`git push origin feature/improvement`)
7. Create Pull Request

### Documentation Guidelines

- Maintain professional tone for finance audience
- Include practical examples and use cases
- Explain technical concepts clearly
- Cross-reference related topics
- Test all links and navigation
- Follow the existing structure and style

## 📊 Documentation Philosophy

This documentation is designed for **finance professionals** who understand capital markets but may be new to tokenization. It focuses on:
- Clear explanations of platform capabilities
- Role-based guidance for different users
- Practical workflows and use cases
- Integration points between applications
- Compliance and regulatory frameworks

## 🔍 Target Audiences

- Investment banking professionals
- Corporate development teams
- Capital markets specialists
- Compliance officers
- Asset and portfolio managers
- Project management teams
- Technology integration teams

## 📄 License

Copyright © 2024 Digital Ubiquity Capital. All rights reserved.

## 💬 Support

For questions about the documentation or platform:
- Open an issue in this repository
- Contact the DUC support team
- Check the [FAQ](https://digitalubiquitycapital.github.io/duc-guides/help/faq/)
- Visit our [Help Center](https://digitalubiquitycapital.github.io/duc-guides/help/finding-help/)

---

Built with ❤️ by the DUC Team using [MkDocs](https://www.mkdocs.org/) and [Material Theme](https://squidfunk.github.io/mkdocs-material/)