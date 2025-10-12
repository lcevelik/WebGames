#!/bin/bash

echo "🚀 Quick Server Fix for games.steadiczech.com..."

# Check if we're on the server
if [ ! -f "server.js" ]; then
    echo "❌ This script must be run from the server directory"
    echo "Please run: cd /media/server/Storage/www/games.steadiczech.com/html"
    exit 1
fi

echo "📁 Current directory: $(pwd)"
echo "📋 Files in directory:"
ls -la

echo ""
echo "🔧 Creating games.json file..."

# Create games.json
cat > games.json << 'EOF'
[
  {
    "title": "Defence",
    "image": "/games/defence/cover.png",
    "description": "Defend against hordes of enemies, Fun little strategy game. Created by Epic Games"
  },
  {
    "title": "Shootout", 
    "image": "/games/shootout/cover.png",
    "description": "As Cowboy try to get all the red boxes before time runs out."
  },
  {
    "title": "Game1",
    "image": "/games/game1/cover.png", 
    "description": "A fun interactive game created with Scratch"
  }
]
EOF

echo "✅ games.json created!"

echo ""
echo "🔐 Setting permissions (this requires sudo)..."
sudo chown -R www-data:www-data /media/server/Storage/www/games.steadiczech.com/html/
sudo chmod -R 755 /media/server/Storage/www/games.steadiczech.com/html/

echo "✅ Permissions set!"

echo ""
echo "🚀 Starting Node.js server..."

# Kill any existing processes
pkill -f "node server.js" 2>/dev/null || true
sleep 2

# Start the server
sudo -u server nohup node server.js > server.log 2>&1 &

sleep 3

# Check if server started
if pgrep -f "node server.js" > /dev/null; then
    echo "✅ Node.js server started successfully"
    echo "📊 Server PID: $(pgrep -f 'node server.js')"
else
    echo "❌ Failed to start Node.js server"
    echo "📋 Check server.log for errors:"
    cat server.log 2>/dev/null || echo "No log file found"
fi

echo ""
echo "🔍 Testing API endpoints..."

# Test the API
echo "Testing API server..."
curl -s http://localhost:3002/api/games 2>/dev/null && echo "✅ API server responding" || echo "❌ API server not responding"

echo "Testing static files..."
curl -s http://localhost/games.json 2>/dev/null && echo "✅ Static games.json accessible" || echo "❌ Static games.json not accessible"

echo ""
echo "🎉 Quick fix completed!"
echo ""
echo "🌐 Your website should now be working at:"
echo "  http://games.steadiczech.com"
echo "  https://games.steadiczech.com"
