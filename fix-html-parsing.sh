#!/bin/bash

# Fix HTML Parsing Issues Script
# This script cleans up control characters and encoding issues in HTML files

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "🔧 Fixing HTML Parsing Issues"
echo "============================="

# Function to clean HTML file
clean_html_file() {
    local file="$1"
    local backup_file="${file}.backup"
    
    print_status "Processing $file..."
    
    # Create backup
    cp "$file" "$backup_file"
    
    # Remove control characters except newlines, tabs, and carriage returns
    # This removes characters 0-8, 11-12, 14-31 (keeping 9=tab, 10=newline, 13=carriage return)
    sed 's/[\x00-\x08\x0B\x0C\x0E-\x1F]//g' "$backup_file" > "$file"
    
    # Check if file was modified
    if ! diff -q "$file" "$backup_file" > /dev/null; then
        print_status "✅ Cleaned control characters from $file"
        # Remove backup if successful
        rm "$backup_file"
    else
        print_warning "No changes needed for $file"
        rm "$backup_file"
    fi
}

# Process all HTML files in games directory
print_status "Scanning for HTML files..."
find games -name "*.html" -type f | while read -r file; do
    clean_html_file "$file"
done

# Also process the main index.html if it exists
if [ -f "index.html" ]; then
    clean_html_file "index.html"
fi

print_status "🎉 HTML parsing fix completed!"
echo ""
echo "The control characters that were causing parse5 errors have been removed."
echo "Your games should now load without the 'control-character-in-input-stream' error."
