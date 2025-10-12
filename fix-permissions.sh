#!/bin/bash

# Fix permissions script for games.steadiczech.com
# Run this on your Linux server to fix permission issues

echo "🔧 Fixing permissions for games.steadiczech.com..."

# Check if we're in the right directory
if [ ! -f "server.js" ]; then
    echo "❌ server.js not found. Please run this script from the website directory."
    echo "Expected location: /media/server/Storage/www/games.steadiczech.com/html/"
    exit 1
fi

echo "🔐 Setting proper ownership and permissions..."

# Set ownership to www-data (Apache user) and server (for Node.js)
sudo chown -R www-data:www-data /media/server/Storage/www/games.steadiczech.com/html/

# Set directory permissions (755 = rwxr-xr-x)
find /media/server/Storage/www/games.steadiczech.com/html/ -type d -exec chmod 755 {} \;

# Set file permissions (644 = rw-r--r--)
find /media/server/Storage/www/games.steadiczech.com/html/ -type f -exec chmod 644 {} \;

# Make scripts executable
chmod +x /media/server/Storage/www/games.steadiczech.com/html/apache-setup.sh
chmod +x /media/server/Storage/www/games.steadiczech.com/html/server.js

# Set special permissions for Node.js server
sudo chown server:server /media/server/Storage/www/games.steadiczech.com/html/server.js
sudo chown server:server /media/server/Storage/www/games.steadiczech.com/html/package.json
sudo chown server:server /media/server/Storage/www/games.steadiczech.com/html/games.json

echo "✅ Permissions fixed!"

# Check Apache configuration
echo "🔍 Checking Apache configuration..."

# Test Apache config
sudo apache2ctl configtest

if [ $? -eq 0 ]; then
    echo "✅ Apache configuration is valid"
    echo "🔄 Reloading Apache..."
    sudo systemctl reload apache2
else
    echo "❌ Apache configuration has errors. Let's fix them..."
    
    # Enable required modules
    echo "🔧 Enabling required Apache modules..."
    sudo a2enmod rewrite
    sudo a2enmod headers
    sudo a2enmod proxy
    sudo a2enmod proxy_http
    sudo a2enmod expires
    
    # Enable the site
    echo "🌐 Enabling games.steadiczech.com site..."
    sudo a2ensite games.steadiczech.com.conf
    
    # Test again
    sudo apache2ctl configtest
    
    if [ $? -eq 0 ]; then
        echo "✅ Apache configuration fixed!"
        sudo systemctl reload apache2
    else
        echo "❌ Still have Apache errors. Please check manually:"
        echo "   sudo apache2ctl configtest"
    fi
fi

# Check if Node.js server is running
echo "🔍 Checking Node.js API server..."
if pgrep -f "node server.js" > /dev/null; then
    echo "✅ Node.js API server is running"
else
    echo "⚠️  Node.js API server is not running. Starting it..."
    cd /media/server/Storage/www/games.steadiczech.com/html/
    sudo -u server node server.js &
    sleep 2
    
    if pgrep -f "node server.js" > /dev/null; then
        echo "✅ Node.js API server started successfully"
    else
        echo "❌ Failed to start Node.js API server"
        echo "   Try running manually: sudo -u server node server.js"
    fi
fi

echo ""
echo "✅ Permission fix completed!"
echo ""
echo "🌐 Test your website:"
echo "  curl http://games.steadiczech.com"
echo "  curl http://games.steadiczech.com/api/games"
echo ""
echo "📊 Check services:"
echo "  sudo systemctl status apache2"
echo "  ps aux | grep 'node server.js'"
