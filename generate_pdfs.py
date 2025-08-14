#!/usr/bin/env python3
"""
Generate PDF versions of the DUC Capital Platform documentation.
Creates separate PDFs for each application guide and a complete platform guide.
"""

import os
import subprocess
import sys
from pathlib import Path
import yaml

def check_dependencies():
    """Check if required packages are installed."""
    required_packages = ['mkdocs-pdf-export-plugin', 'weasyprint', 'cairocffi']
    missing_packages = []
    
    for package in required_packages:
        try:
            __import__(package.replace('-', '_'))
        except ImportError:
            missing_packages.append(package)
    
    if missing_packages:
        print("Missing required packages. Installing...")
        subprocess.run([sys.executable, "-m", "pip", "install"] + missing_packages)
        print("Dependencies installed successfully.")

def create_pdf_config(name, nav_section, output_file):
    """Create a temporary mkdocs.yml for specific PDF generation."""
    with open('mkdocs.yml', 'r') as f:
        base_config = yaml.safe_load(f)
    
    # Create focused config for specific section
    pdf_config = base_config.copy()
    pdf_config['site_name'] = f"DUC Capital Platform - {name}"
    
    # Add PDF export plugin
    if 'plugins' not in pdf_config:
        pdf_config['plugins'] = []
    
    # Configure PDF export
    pdf_config['plugins'].append({
        'pdf-export': {
            'enabled': True,
            'media_type': 'print',
            'verbose': False,
            'combined': True,
            'combined_output_path': f"pdfs/{output_file}",
            'theme_handler_path': 'material',
        }
    })
    
    # Filter navigation to specific section if provided
    if nav_section:
        for item in pdf_config['nav']:
            if isinstance(item, dict):
                for key in item:
                    if key == nav_section:
                        pdf_config['nav'] = [{nav_section: item[nav_section]}]
                        break
    
    # Save temporary config
    temp_config = f'mkdocs-{output_file.replace(".pdf", "")}.yml'
    with open(temp_config, 'w') as f:
        yaml.dump(pdf_config, f)
    
    return temp_config

def generate_pdf(config_file):
    """Generate PDF using mkdocs with the specified config."""
    print(f"Generating PDF with {config_file}...")
    result = subprocess.run(
        ['mkdocs', 'build', '-f', config_file],
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        print(f"Error generating PDF: {result.stderr}")
        return False
    
    return True

def create_individual_pdfs():
    """Create individual PDF guides for each application."""
    
    # Create PDFs directory
    Path('pdfs').mkdir(exist_ok=True)
    
    # Define PDF generation tasks
    pdf_tasks = [
        ("Complete Platform Guide", None, "DUC_Platform_Complete.pdf"),
        ("Sagacity Guide", "Sagacity - Deal Preparation", "Sagacity_Guide.pdf"),
        ("Bridge Guide", "Bridge - Tokenization Platform", "Bridge_Guide.pdf"),
        ("Lift Guide", "Lift - Asset Management", "Lift_Guide.pdf"),
        ("Platform Overview", "Platform Overview", "Platform_Overview.pdf"),
    ]
    
    generated_pdfs = []
    
    for name, nav_section, output_file in pdf_tasks:
        print(f"\n📄 Creating {name}...")
        
        # Create temporary config
        temp_config = create_pdf_config(name, nav_section, output_file)
        
        try:
            # Generate PDF
            if generate_pdf(temp_config):
                generated_pdfs.append(output_file)
                print(f"✅ Successfully created {output_file}")
            else:
                print(f"❌ Failed to create {output_file}")
        finally:
            # Clean up temporary config
            if os.path.exists(temp_config):
                os.remove(temp_config)
    
    return generated_pdfs

def create_simple_pdfs():
    """Create PDFs using alternative method with mkdocs-with-pdf plugin."""
    
    print("\n🔧 Setting up PDF generation with mkdocs-with-pdf plugin...")
    
    # Install the plugin
    subprocess.run([sys.executable, "-m", "pip", "install", "mkdocs-with-pdf", "beautifulsoup4", "libsass"])
    
    # Create PDFs directory
    Path('pdfs').mkdir(exist_ok=True)
    
    # Read base config
    with open('mkdocs.yml', 'r') as f:
        base_config = yaml.safe_load(f)
    
    # Configure for PDF generation
    base_config['plugins'] = base_config.get('plugins', [])
    
    # Add with-pdf plugin configuration
    base_config['plugins'].append({
        'with-pdf': {
            'author': 'DUC Capital Platform Team',
            'copyright': '© 2024 DUC Capital Platform',
            'cover': True,
            'back_cover': True,
            'cover_title': 'DUC Capital Platform Documentation',
            'cover_subtitle': 'Sagacity • Bridge • Lift',
            'toc_title': 'Table of Contents',
            'output_path': 'pdfs/DUC_Platform_Complete.pdf',
            'enabled_if_env': 'ENABLE_PDF_EXPORT',
            'render_js': False,
            'headless_chrome_path': 'chromium-browser'
        }
    })
    
    # Save temporary config
    with open('mkdocs-pdf.yml', 'w') as f:
        yaml.dump(base_config, f)
    
    # Generate PDF
    print("📚 Generating complete platform documentation PDF...")
    env = os.environ.copy()
    env['ENABLE_PDF_EXPORT'] = '1'
    
    result = subprocess.run(
        ['mkdocs', 'build', '-f', 'mkdocs-pdf.yml'],
        env=env,
        capture_output=True,
        text=True
    )
    
    if result.returncode == 0:
        print("✅ Successfully created DUC_Platform_Complete.pdf")
        
        # Clean up
        if os.path.exists('mkdocs-pdf.yml'):
            os.remove('mkdocs-pdf.yml')
        
        return ['DUC_Platform_Complete.pdf']
    else:
        print(f"❌ Error: {result.stderr}")
        return []

def update_overview_with_pdf_links(pdf_files):
    """Update the overview page with links to generated PDFs."""
    
    overview_file = 'docs/getting-started/overview.md'
    
    # Read current overview
    with open(overview_file, 'r') as f:
        content = f.read()
    
    # Create PDF download section
    pdf_section = """
---

## 📚 Documentation Downloads

Download PDF versions of the documentation for offline reading:

"""
    
    if 'DUC_Platform_Complete.pdf' in pdf_files:
        pdf_section += "### Complete Documentation\n"
        pdf_section += "- 📕 [**Complete Platform Guide**](/pdfs/DUC_Platform_Complete.pdf) - Full documentation for all three applications\n\n"
    
    individual_pdfs = [f for f in pdf_files if f != 'DUC_Platform_Complete.pdf']
    if individual_pdfs:
        pdf_section += "### Individual Application Guides\n"
        for pdf in individual_pdfs:
            if 'Sagacity' in pdf:
                pdf_section += "- 📘 [**Sagacity Guide**](/pdfs/Sagacity_Guide.pdf) - Deal preparation and analysis platform\n"
            elif 'Bridge' in pdf:
                pdf_section += "- 📗 [**Bridge Guide**](/pdfs/Bridge_Guide.pdf) - Tokenization and capital structuring platform\n"
            elif 'Lift' in pdf:
                pdf_section += "- 📙 [**Lift Guide**](/pdfs/Lift_Guide.pdf) - Asset management and monitoring platform\n"
            elif 'Overview' in pdf:
                pdf_section += "- 📓 [**Platform Overview**](/pdfs/Platform_Overview.pdf) - Quick reference guide\n"
    
    pdf_section += """
!!! tip "PDF Features"
    The PDF guides include:
    - Complete table of contents with page numbers
    - Printable format optimized for reading
    - All diagrams and charts included
    - Cross-references and glossary
    - Professional formatting for sharing with stakeholders
"""
    
    # Check if PDF section already exists
    if "## 📚 Documentation Downloads" in content:
        # Replace existing section
        import re
        pattern = r'## 📚 Documentation Downloads.*?(?=\n---|\n##|\Z)'
        content = re.sub(pattern, pdf_section.strip() + '\n', content, flags=re.DOTALL)
    else:
        # Add before the final tip if it exists, otherwise at the end
        if '!!! tip "Platform Best Practice"' in content:
            content = content.replace('!!! tip "Platform Best Practice"', pdf_section + '\n!!! tip "Platform Best Practice"')
        else:
            content += pdf_section
    
    # Write updated content
    with open(overview_file, 'w') as f:
        f.write(content)
    
    print(f"\n✅ Updated {overview_file} with PDF download links")

def main():
    """Main execution function."""
    print("=" * 60)
    print("DUC Capital Platform - PDF Documentation Generator")
    print("=" * 60)
    
    # Check and install dependencies
    print("\n📦 Checking dependencies...")
    
    # Try simple method first
    pdf_files = create_simple_pdfs()
    
    if not pdf_files:
        print("\n⚠️  Simple PDF generation failed. Trying alternative method...")
        check_dependencies()
        pdf_files = create_individual_pdfs()
    
    if pdf_files:
        # Update overview page with PDF links
        update_overview_with_pdf_links(pdf_files)
        
        print("\n" + "=" * 60)
        print("✅ PDF Generation Complete!")
        print(f"📁 Generated {len(pdf_files)} PDF file(s) in the 'pdfs' directory")
        print("📄 Overview page updated with download links")
        print("=" * 60)
    else:
        print("\n❌ PDF generation failed. Please check the error messages above.")
        sys.exit(1)

if __name__ == "__main__":
    main()