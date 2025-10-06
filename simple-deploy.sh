#!/bin/bash

# Simple Deployment Script - Works with existing build
# This script copies your current build to the new server

echo "🚀 Simple Deployment Script for SteadiCzech Games"
echo "=================================================="

# Configuration
SERVER_PATH="/media/server/Storage/www/games.com"
CURRENT_DIR="/Users/liborcevelik/Desktop/GamesWebsite"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if server path exists
if [ ! -d "$SERVER_PATH" ]; then
    print_error "Server path does not exist: $SERVER_PATH"
    print_warning "Please create the directory first:"
    echo "sudo mkdir -p $SERVER_PATH"
    echo "sudo chown -R \$USER:\$USER $SERVER_PATH"
    exit 1
fi

print_status "Copying files to server..."

# Copy all files except node_modules and .git
rsync -av --exclude 'node_modules' --exclude '.git' --exclude '.DS_Store' "$CURRENT_DIR/" "$SERVER_PATH/"

if [ $? -eq 0 ]; then
    print_status "Files copied successfully!"
else
    print_error "Failed to copy files!"
    exit 1
fi

# Set permissions
print_status "Setting file permissions..."
chmod -R 755 "$SERVER_PATH/"
chmod 644 "$SERVER_PATH/games.json"
chmod 644 "$SERVER_PATH/save-game.php"
chmod 644 "$SERVER_PATH/config.php"

# Run migration script
print_status "Running migration script..."
cd "$SERVER_PATH"
php migrate-games.php

if [ $? -eq 0 ]; then
    print_status "Migration completed successfully!"
else
    print_warning "Migration script had issues, but files are copied."
fi

print_status "Deployment completed! 🎉"
echo ""
echo "📋 Next steps:"
echo "1. Visit your website: https://games.steadiczech.com"
echo "2. Test game loading and functionality"
echo "3. Check browser console for any errors"
echo "4. Test adding a new game"
echo ""
echo "🔍 If you encounter issues:"
echo "- Check Apache error logs: /var/log/apache2/error.log"
echo "- Verify file permissions"
echo "- Ensure PHP is working: php -v"
echo ""
print_status "Your SteadiCzech Games website is ready! 🚀"
