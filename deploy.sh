#!/bin/bash

# SteadiCzech Games Deployment Script
# This script helps deploy the application to your new server

echo "🚀 Starting SteadiCzech Games Deployment..."

# Configuration
SERVER_PATH="/media/server/Storage/www/games.com"
BUILD_DIR="dist"
GAMES_DIR="games"
PHP_FILES=("save-game.php" "config.php" "migrate-games.php" "games.json")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Step 1: Build the application
print_status "Building application..."
npm run build

if [ $? -ne 0 ]; then
    print_error "Build failed! Please check for errors."
    exit 1
fi

# Step 2: Copy built files
print_status "Copying built files to server..."
cp -r $BUILD_DIR/* $SERVER_PATH/

# Step 3: Copy PHP files
print_status "Copying PHP files..."
for file in "${PHP_FILES[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$SERVER_PATH/"
        print_status "Copied $file"
    else
        print_warning "File not found: $file"
    fi
done

# Step 4: Copy games directory
print_status "Copying games directory..."
if [ -d "$GAMES_DIR" ]; then
    cp -r $GAMES_DIR $SERVER_PATH/
    print_status "Copied games directory"
else
    print_warning "Games directory not found: $GAMES_DIR"
fi

# Step 5: Create images directory
print_status "Creating images directory..."
mkdir -p $SERVER_PATH/images

# Step 6: Set permissions
print_status "Setting file permissions..."
chmod -R 755 $SERVER_PATH/
chmod 644 $SERVER_PATH/games.json
chmod 644 $SERVER_PATH/save-game.php
chmod 644 $SERVER_PATH/config.php

# Step 7: Run migration script
print_status "Running migration script..."
cd $SERVER_PATH
php migrate-games.php

if [ $? -eq 0 ]; then
    print_status "Migration completed successfully!"
else
    print_error "Migration failed! Please check the output above."
fi

# Step 8: Final verification
print_status "Deployment completed!"
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
print_status "Deployment script completed! 🎉"
