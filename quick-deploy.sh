#!/bin/bash

# Quick Deployment Script for SteadiCzech Games
# Simple one-command deployment to server@172.251.232.135

set -e

# Configuration
SERVER_HOST="172.251.232.135"
SERVER_USER="server"
SERVER_PATH="/media/server/Storage/www/games.steadiczech.com/html"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 Quick Deploy to SteadiCzech Server${NC}"
echo "=================================="

# Build the project
echo "Building project..."
npm run build

# Deploy using rsync
echo "Deploying to server..."
rsync -avz --delete dist/ "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/"

# Copy essential files
echo "Copying essential files..."
scp games.json save-game.php config.php "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/"
scp -r games/ "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/"

# Set permissions
echo "Setting permissions..."
ssh "$SERVER_USER@$SERVER_HOST" "chmod -R 755 $SERVER_PATH && chmod 644 $SERVER_PATH/*.php $SERVER_PATH/*.json"

echo -e "${GREEN}✅ Deployment completed!${NC}"
echo "Visit: https://games.steadiczech.com"
