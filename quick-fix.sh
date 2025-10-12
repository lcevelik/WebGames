#!/bin/bash

# Quick fix script for games.steadiczech.com
# This will fix the most common issues

echo "🚀 Quick fix for games.steadiczech.com..."

# Check if we're in the right directory
if [ ! -f "server.js" ]; then
    echo "❌ server.js not found. Please run this script from the website directory."
    echo "Expected location: /media/server/Storage/www/games.steadiczech.com/html/"
    exit 1
fi

echo "🔐 Fixing permissions..."

# Set proper ownership
sudo chown -R www-data:www-data /media/server/Storage/www/games.steadiczech.com/html/

# Set directory permissions
find /media/server/Storage/www/games.steadiczech.com/html/ -type d -exec chmod 755 {} \;

# Set file permissions
find /media/server/Storage/www/games.steadiczech.com/html/ -type f -exec chmod 644 {} \;

# Make scripts executable
chmod +x /media/server/Storage/www/games.steadiczech.com/html/*.sh

echo "✅ Permissions fixed!"

echo "🔧 Enabling required Apache modules..."
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod ssl

echo "🌐 Creating simple Apache configuration..."

# Create a simple Apache config that works for both HTTP and HTTPS
sudo tee /etc/apache2/sites-available/games.steadiczech.com.conf > /dev/null << 'EOF'
<VirtualHost *:80>
    ServerName games.steadiczech.com
    DocumentRoot /media/server/Storage/www/games.steadiczech.com/html
    
    # Redirect HTTP to HTTPS
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</VirtualHost>

<VirtualHost *:443>
    ServerName games.steadiczech.com
    DocumentRoot /media/server/Storage/www/games.steadiczech.com/html
    
    # SSL Configuration (using self-signed certificate for now)
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
    
    # Security headers
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-XSS-Protection "1; mode=block"
    
    # Main application
    <Directory "/media/server/Storage/www/games.steadiczech.com/html">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        
        # Handle React Router
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>
    
    # Games directory with CORS headers
    <Directory "/media/server/Storage/www/games.steadiczech.com/html/games">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        
        # CORS headers for UE4 games
        Header always set Cross-Origin-Embedder-Policy "require-corp"
        Header always set Cross-Origin-Opener-Policy "same-origin"
        Header always set Cross-Origin-Resource-Policy "cross-origin"
        
        # MIME types
        <FilesMatch "\.(wasm)$">
            Header set Content-Type "application/wasm"
        </FilesMatch>
        <FilesMatch "\.(data)$">
            Header set Content-Type "application/octet-stream"
        </FilesMatch>
    </Directory>
    
    # API proxy
    <Location "/api/">
        ProxyPass http://localhost:3002/
        ProxyPassReverse http://localhost:3002/
        ProxyPreserveHost On
        
        Header always set Access-Control-Allow-Origin "*"
        Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
        Header always set Access-Control-Allow-Headers "Content-Type"
    </Location>
</VirtualHost>
EOF

echo "✅ Apache configuration created!"

# Enable the site
echo "🌐 Enabling site..."
sudo a2ensite games.steadiczech.com.conf

# Test Apache configuration
echo "🔍 Testing Apache configuration..."
sudo apache2ctl configtest

if [ $? -eq 0 ]; then
    echo "✅ Apache configuration is valid"
    echo "🔄 Reloading Apache..."
    sudo systemctl reload apache2
else
    echo "❌ Apache configuration has errors"
    exit 1
fi

# Start Node.js server
echo "🚀 Starting Node.js API server..."
cd /media/server/Storage/www/games.steadiczech.com/html/
sudo -u server nohup node server.js > server.log 2>&1 &

sleep 2

if pgrep -f "node server.js" > /dev/null; then
    echo "✅ Node.js API server started"
else
    echo "❌ Failed to start Node.js server"
    echo "Check server.log for errors"
fi

echo ""
echo "✅ Quick fix completed!"
echo ""
echo "🌐 Test your website:"
echo "  HTTP:  http://games.steadiczech.com"
echo "  HTTPS: https://games.steadiczech.com"
echo ""
echo "📊 Check services:"
echo "  sudo systemctl status apache2"
echo "  ps aux | grep 'node server.js'"
