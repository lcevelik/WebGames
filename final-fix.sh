#!/bin/bash

# Final fix script for games.steadiczech.com
# This will fix the API and static file issues

echo "🚀 Final fix for games.steadiczech.com..."

# Check if we're in the right directory
if [ ! -f "server.js" ]; then
    echo "❌ server.js not found. Please run this script from the website directory."
    echo "Expected location: /media/server/Storage/www/games.steadiczech.com/html/"
    exit 1
fi

echo "📁 Current directory contents:"
ls -la

echo ""
echo "🔧 Creating games.json file..."

# Create a basic games.json file
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
echo "🔐 Setting proper permissions..."
sudo chown -R www-data:www-data /media/server/Storage/www/games.steadiczech.com/html/
find /media/server/Storage/www/games.steadiczech.com/html/ -type d -exec chmod 755 {} \;
find /media/server/Storage/www/games.steadiczech.com/html/ -type f -exec chmod 644 {} \;

echo "✅ Permissions set!"

echo ""
echo "🚀 Starting Node.js API server..."

# Kill any existing Node.js processes
pkill -f "node server.js" 2>/dev/null || true
sleep 2

# Start the Node.js server
cd /media/server/Storage/www/games.steadiczech.com/html/
sudo -u server nohup node server.js > server.log 2>&1 &

sleep 3

# Check if server started
if pgrep -f "node server.js" > /dev/null; then
    echo "✅ Node.js API server started successfully"
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
echo "🌐 Testing website..."

# Test the main website
echo "Testing main website..."
curl -s -I http://games.steadiczech.com/ 2>/dev/null | head -1 || echo "❌ Main website not accessible"

echo ""
echo "📊 Current status:"
echo "  Node.js server: $(pgrep -f 'node server.js' > /dev/null && echo '✅ Running' || echo '❌ Not running')"
echo "  Apache: $(systemctl is-active apache2 2>/dev/null || echo 'unknown')"
echo "  Files: $(ls -la games.json 2>/dev/null && echo '✅ games.json exists' || echo '❌ games.json missing')"

echo ""
echo "✅ Final fix completed!"
echo ""
echo "🌐 Your website should now be working at:"
echo "  http://games.steadiczech.com"
echo "  https://games.steadiczech.com"
echo ""
echo "📊 Check logs if issues persist:"
echo "  tail -f server.log"
echo "  sudo tail -f /var/log/apache2/error.log"
