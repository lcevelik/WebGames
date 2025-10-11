#!/bin/bash

# Fix HTML files on server - remove control characters and fix malformed HTML
# This script will clean up corrupted HTML files that are causing parsing errors

SERVER_USER="server"
SERVER_HOST="172.251.232.135"
SERVER_PATH="/media/server/Storage/www/games.steadiczech.com/html"

echo "🔧 Fixing corrupted HTML files on server..."

# Function to clean HTML file
clean_html_file() {
    local file_path="$1"
    echo "Cleaning: $file_path"
    
    # Remove control characters (ASCII 0-8, 11-12, 14-31) and fix common HTML issues
    ssh "$SERVER_USER@$SERVER_HOST" "
        if [ -f '$file_path' ]; then
            # Create a backup
            cp '$file_path' '$file_path.backup.$(date +%Y%m%d_%H%M%S)'
            
            # Remove control characters and fix HTML
            sed 's/[\x00-\x08\x0B\x0C\x0E-\x1F]//g' '$file_path' | \
            sed 's/! html/<!DOCTYPE html>/g' | \
            sed 's/html lang\"en\"/<html lang=\"en\">/g' | \
            sed 's/head/<head>/g' | \
            sed 's/titletrategyame\/title/<title>Strategy Game<\/title>/g' | \
            sed 's/title_stork\/title/<title>Shootout<\/title>/g' | \
            sed 's/meta charset\"utf-\"/<meta charset=\"utf-8\">/g' | \
            sed 's/meta name\"viewport\" content\"widthdevice-width, initial-scale\"/<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">/g' | \
            sed 's/script src\"https\/\/code.jquery.com\/jquery-...min.js\"\/script/<script src=\"https:\/\/code.jquery.com\/jquery-3.6.0.min.js\"><\/script>/g' | \
            sed 's/script src\"https\/\/macdn.bootstrapcdn.com\/bootstrap\/..\/js\/bootstrap.min.js\"\/script/<script src=\"https:\/\/cdn.jsdelivr.net\/npm\/bootstrap@5.1.3\/dist\/js\/bootstrap.bundle.min.js\"><\/script>/g' | \
            sed 's/link href\"https\/\/macdn.bootstrapcdn.com\/bootstrap\/..\/css\/bootstrap.min.css\" rel\"stylesheet\"/<link href=\"https:\/\/cdn.jsdelivr.net\/npm\/bootstrap@5.1.3\/dist\/css\/bootstrap.min.css\" rel=\"stylesheet\">/g' | \
            sed 's/body/<body>/g' | \
            sed 's/\/html/<\/html>/g' > '$file_path.tmp'
            
            # Replace original with cleaned version
            mv '$file_path.tmp' '$file_path'
            
            # Set proper permissions
            chmod 644 '$file_path'
            
            echo 'Fixed: $file_path'
        else
            echo 'File not found: $file_path'
        fi
    "
}

# Clean the main index.html
echo "Cleaning main index.html..."
clean_html_file "$SERVER_PATH/index.html"

# Clean game HTML files
echo "Cleaning game HTML files..."
clean_html_file "$SERVER_PATH/games/defence/index.html"
clean_html_file "$SERVER_PATH/games/shootout/index.html"
clean_html_file "$SERVER_PATH/games/game1/index.html"

# Set proper permissions on all HTML files
echo "Setting permissions..."
ssh "$SERVER_USER@$SERVER_HOST" "
    find '$SERVER_PATH' -name '*.html' -type f -exec chmod 644 {} \;
    find '$SERVER_PATH' -type d -exec chmod 755 {} \;
"

echo "✅ HTML files cleaned and fixed!"
echo "🌐 Test your games at: https://games.steadiczech.com"
