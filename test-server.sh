#!/bin/bash

# Test server script - run this on your server to diagnose issues

echo "🔍 Testing games.steadiczech.com server..."

# Check if we're in the right directory
if [ ! -f "server.js" ]; then
    echo "❌ server.js not found. Please run this script from the website directory."
    echo "Expected location: /media/server/Storage/www/games.steadiczech.com/html/"
    exit 1
fi

echo "📁 Current directory contents:"
ls -la

echo ""
echo "🔐 File permissions:"
ls -la /media/server/Storage/www/games.steadiczech.com/html/

echo ""
echo "🌐 Testing HTTP (port 80):"
curl -I http://games.steadiczech.com/ 2>/dev/null || echo "❌ HTTP not accessible"

echo ""
echo "🔒 Testing HTTPS (port 443):"
curl -I https://games.steadiczech.com/ 2>/dev/null || echo "❌ HTTPS not accessible"

echo ""
echo "📊 Apache status:"
sudo systemctl status apache2 --no-pager

echo ""
echo "🔍 Apache error logs (last 10 lines):"
sudo tail -10 /var/log/apache2/error.log

echo ""
echo "📋 Apache sites enabled:"
sudo a2ensite --list

echo ""
echo "🔧 Apache modules:"
apache2ctl -M | grep -E "(rewrite|headers|proxy|ssl)"

echo ""
echo "📁 Document root permissions:"
ls -la /media/server/Storage/www/games.steadiczech.com/html/index.html

echo ""
echo "🔍 Check if Node.js server is running:"
ps aux | grep "node server.js" | grep -v grep || echo "❌ Node.js server not running"

echo ""
echo "🌐 Test local access:"
curl -I http://localhost/ 2>/dev/null || echo "❌ Local Apache not responding"
