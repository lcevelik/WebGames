#!/bin/bash

# Fix Deployment Script for SteadiCzech Games
# This script fixes the deployment issue and properly deploys files

set -e

# Configuration
SERVER_HOST="172.251.232.135"
SERVER_USER="server"
SERVER_PATH="/media/server/Storage/www/games.steadiczech.com/html"

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

echo "🔧 Fixing SteadiCzech Games Deployment"
echo "======================================"

# Step 1: Build the project
print_status "Building project..."
npm run build

if [ $? -ne 0 ]; then
    print_error "Build failed!"
    exit 1
fi

# Step 2: Create server directory
print_status "Creating server directory..."
ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p $SERVER_PATH"

# Step 3: Copy built files
print_status "Copying built files..."
rsync -avz --delete dist/ "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/"

# Step 4: Copy essential files
print_status "Copying essential files..."
scp games.json "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/" 2>/dev/null || print_warning "games.json not found"
scp save-game.php "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/" 2>/dev/null || print_warning "save-game.php not found"
scp config.php "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/" 2>/dev/null || print_warning "config.php not found"

# Step 5: Copy public files
print_status "Copying public files..."
scp favicon.ico "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/" 2>/dev/null || print_warning "favicon.ico not found"
scp og-image.png "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/" 2>/dev/null || print_warning "og-image.png not found"
scp placeholder.svg "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/" 2>/dev/null || print_warning "placeholder.svg not found"

# Step 6: Copy games directory
print_status "Copying games directory..."
if [ -d "games" ]; then
    rsync -avz games/ "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/games/"
else
    print_warning "Games directory not found"
fi

# Step 7: Create images directory
print_status "Creating images directory..."
ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p $SERVER_PATH/images"

# Step 8: Set permissions
print_status "Setting permissions..."
ssh "$SERVER_USER@$SERVER_HOST" "chmod -R 755 $SERVER_PATH && chmod 644 $SERVER_PATH/*.php $SERVER_PATH/*.json 2>/dev/null || true"

# Step 9: Verify deployment
print_status "Verifying deployment..."
ssh "$SERVER_USER@$SERVER_HOST" "ls -la $SERVER_PATH"

print_status "✅ Deployment fixed and completed!"
echo ""
echo "🌐 Your website should now be available at:"
echo "   https://games.steadiczech.com"
echo ""
echo "📁 Server files location:"
echo "   $SERVER_PATH"
