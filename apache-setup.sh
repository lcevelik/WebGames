#!/bin/bash

# Apache setup script for games.steadiczech.com
# Run this on your Linux server after uploading the files

echo "🚀 Setting up games.steadiczech.com with Apache..."

# Check if we're in the right directory
if [ ! -f "server.js" ]; then
    echo "❌ server.js not found. Please run this script from the website directory."
    echo "Expected location: /media/server/Storage/www/games.steadiczech.com/html/"
    exit 1
fi

echo "📦 Installing Node.js dependencies..."
if command -v npm &> /dev/null; then
    npm install --production
    echo "✅ Dependencies installed"
else
    echo "❌ npm not found. Please install Node.js first:"
    echo "   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -"
    echo "   sudo apt-get install -y nodejs"
    exit 1
fi

echo "🔧 Setting up systemd service for API server..."

# Create systemd service file
sudo tee /etc/systemd/system/games-website.service > /dev/null << 'EOF'
[Unit]
Description=Games Website API Server
After=network.target

[Service]
Type=simple
User=server
WorkingDirectory=/media/server/Storage/www/games.steadiczech.com/html
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

echo "✅ Systemd service created"

# Enable and start the service
echo "🚀 Starting games website API service..."
sudo systemctl daemon-reload
sudo systemctl enable games-website.service
sudo systemctl start games-website.service

# Check service status
echo "📊 Checking API service status..."
sudo systemctl status games-website.service --no-pager

echo ""
echo "🔧 Setting up Apache configuration..."

# Create Apache virtual host configuration
sudo tee /etc/apache2/sites-available/games.steadiczech.com.conf > /dev/null << 'EOF'
<VirtualHost *:80>
    ServerName games.steadiczech.com
    DocumentRoot /media/server/Storage/www/games.steadiczech.com/html
    
    # Security headers
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-XSS-Protection "1; mode=block"
    
    # Main application - serve React app
    <Directory "/media/server/Storage/www/games.steadiczech.com/html">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        
        # Handle React Router - redirect all requests to index.html
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>
    
    # Games directory with proper CORS headers for UE4 games
    <Directory "/media/server/Storage/www/games.steadiczech.com/html/games">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        
        # CORS headers for UE4 games
        Header always set Cross-Origin-Embedder-Policy "require-corp"
        Header always set Cross-Origin-Opener-Policy "same-origin"
        Header always set Cross-Origin-Resource-Policy "cross-origin"
        
        # Set proper MIME types
        <FilesMatch "\.(wasm)$">
            Header set Content-Type "application/wasm"
            Header always set Cross-Origin-Embedder-Policy "require-corp"
            Header always set Cross-Origin-Opener-Policy "same-origin"
        </FilesMatch>
        
        <FilesMatch "\.(data)$">
            Header set Content-Type "application/octet-stream"
            Header always set Cross-Origin-Embedder-Policy "require-corp"
            Header always set Cross-Origin-Opener-Policy "same-origin"
        </FilesMatch>
        
        <FilesMatch "\.(js)$">
            Header set Content-Type "application/javascript"
        </FilesMatch>
        
        <FilesMatch "\.(css)$">
            Header set Content-Type "text/css"
        </FilesMatch>
        
        <FilesMatch "\.(html)$">
            Header set Content-Type "text/html"
        </FilesMatch>
        
        <FilesMatch "\.(png|jpg|jpeg|gif)$">
            Header set Content-Type "image/png"
        </FilesMatch>
    </Directory>
    
    # API routes - proxy to Node.js server
    <Location "/api/">
        ProxyPass http://localhost:3002/
        ProxyPassReverse http://localhost:3002/
        ProxyPreserveHost On
        
        # CORS headers for API
        Header always set Access-Control-Allow-Origin "*"
        Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
        Header always set Access-Control-Allow-Headers "Content-Type"
        
        # Handle preflight requests
        RewriteEngine On
        RewriteCond %{REQUEST_METHOD} OPTIONS
        RewriteRule ^(.*)$ $1 [R=200,L]
    </Location>
    
    # Cache static assets
    <LocationMatch "\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$">
        ExpiresActive On
        ExpiresDefault "access plus 1 year"
        Header set Cache-Control "public, immutable"
    </LocationMatch>
    
    # Error pages
    ErrorDocument 404 /index.html
    ErrorDocument 500 /index.html
</VirtualHost>
EOF

# Enable required Apache modules
echo "🔧 Enabling required Apache modules..."
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod expires

# Enable the site
echo "🌐 Enabling games.steadiczech.com site..."
sudo a2ensite games.steadiczech.com.conf

# Test Apache configuration
echo "🔍 Testing Apache configuration..."
sudo apache2ctl configtest

if [ $? -eq 0 ]; then
    echo "✅ Apache configuration is valid"
    echo "🔄 Reloading Apache..."
    sudo systemctl reload apache2
else
    echo "❌ Apache configuration has errors. Please check the configuration."
    exit 1
fi

# Set proper permissions
echo "🔐 Setting permissions..."
sudo chown -R www-data:www-data /media/server/Storage/www/games.steadiczech.com/html/
sudo chmod -R 755 /media/server/Storage/www/games.steadiczech.com/html/

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "🌐 Your website should now be available at: http://games.steadiczech.com"
echo ""
echo "📊 Useful commands:"
echo "  Check API service status: sudo systemctl status games-website.service"
echo "  Restart API service: sudo systemctl restart games-website.service"
echo "  View API service logs: sudo journalctl -u games-website.service -f"
echo "  Test Apache config: sudo apache2ctl configtest"
echo "  Reload Apache: sudo systemctl reload apache2"
echo "  Check Apache status: sudo systemctl status apache2"
echo ""
echo "🔧 Next steps:"
echo "1. Make sure your domain games.steadiczech.com points to this server (172.251.232.135)"
echo "2. Test the website: curl http://games.steadiczech.com"
echo "3. Test the API: curl http://games.steadiczech.com/api/games"
echo "4. Consider setting up SSL/HTTPS for production use"
