#!/bin/bash

# Fix Games Loading Issues Script
# This script fixes the "Failed to load games from server" error

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

echo "🔧 Fixing Games Loading Issues"
echo "=============================="

# Step 1: Build with production environment
print_status "Building with production environment..."
VITE_ENVIRONMENT=production npm run build

# Step 2: Deploy built files
print_status "Deploying built files..."
rsync -avz --delete dist/ "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/"

# Step 3: Copy essential files
print_status "Copying essential files..."
scp games.json "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/" 2>/dev/null || print_warning "games.json not found"
scp save-game.php "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/" 2>/dev/null || print_warning "save-game.php not found"
scp config.php "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/" 2>/dev/null || print_warning "config.php not found"

# Step 4: Copy games directory
print_status "Copying games directory..."
if [ -d "games" ]; then
    rsync -avz games/ "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/games/"
else
    print_warning "Games directory not found"
fi

# Step 5: Fix file permissions
print_status "Fixing file permissions..."
ssh "$SERVER_USER@$SERVER_HOST" "chmod -R 755 $SERVER_PATH && chmod 644 $SERVER_PATH/*.php $SERVER_PATH/*.json 2>/dev/null || true"

# Step 6: Create corrected games.json with proper URLs
print_status "Creating corrected games.json..."
ssh "$SERVER_USER@$SERVER_HOST" "cat > $SERVER_PATH/games.json << 'EOF'
[
  {
    \"title\": \"Defence\",
    \"image\": \"https://games.steadiczech.com/games/defence/cover.png\",
    \"description\": \"Defend agains hordes of enemies, Fun little strategy game. Created by Epic Games\"
  },
  {
    \"title\": \"Shootout\",
    \"image\": \"https://games.steadiczech.com/games/shootout/cover.png\",
    \"description\": \"As Cowboy try to get all the red boxes before time runs out.\"
  }
]
EOF"

# Step 7: Test the API endpoint
print_status "Testing games.json accessibility..."
if curl -s "https://games.steadiczech.com/games.json" | grep -q "Defence"; then
    print_status "✅ games.json is accessible and contains correct data"
else
    print_error "❌ games.json is not accessible or has incorrect data"
fi

# Step 8: Test the website
print_status "Testing website..."
if curl -s "https://games.steadiczech.com/" | grep -q "Featured Games"; then
    print_status "✅ Website is loading correctly"
else
    print_warning "⚠️  Website might have issues loading"
fi

print_status "🎉 Games loading fix completed!"
echo ""
echo "🌐 Your website: https://games.steadiczech.com"
echo "📊 Games API: https://games.steadiczech.com/games.json"
echo ""
echo "The error 'Failed to load games from server' should now be resolved."
