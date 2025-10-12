#!/bin/bash

# Server setup script for games.steadiczech.com
# Run this on your Linux server after uploading the files

echo "🚀 Setting up games.steadiczech.com on server..."

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

echo "🔧 Setting up systemd service..."

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
echo "🚀 Starting games website service..."
sudo systemctl daemon-reload
sudo systemctl enable games-website.service
sudo systemctl start games-website.service

# Check service status
echo "📊 Checking service status..."
sudo systemctl status games-website.service --no-pager

echo ""
echo "🔧 Setting up Nginx configuration..."

# Create nginx configuration
sudo tee /etc/nginx/sites-available/games.steadiczech.com > /dev/null << 'EOF'
server {
    listen 80;
    server_name games.steadiczech.com;
    root /media/server/Storage/www/games.steadiczech.com/html;
    index index.html;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Main application
    location / {
        try_files $uri $uri/ /index.html;
        
        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # Games directory with proper CORS headers for UE4 games
    location /games/ {
        alias /media/server/Storage/www/games.steadiczech.com/html/games/;
        
        # CORS headers for UE4 games
        add_header Cross-Origin-Embedder-Policy "require-corp" always;
        add_header Cross-Origin-Opener-Policy "same-origin" always;
        add_header Cross-Origin-Resource-Policy "cross-origin" always;
        
        # Set proper MIME types
        location ~* \.(wasm)$ {
            add_header Content-Type "application/wasm";
            add_header Cross-Origin-Embedder-Policy "require-corp" always;
            add_header Cross-Origin-Opener-Policy "same-origin" always;
        }
        
        location ~* \.(data)$ {
            add_header Content-Type "application/octet-stream";
            add_header Cross-Origin-Embedder-Policy "require-corp" always;
            add_header Cross-Origin-Opener-Policy "same-origin" always;
        }
        
        location ~* \.(js)$ {
            add_header Content-Type "application/javascript";
        }
        
        location ~* \.(css)$ {
            add_header Content-Type "text/css";
        }
        
        location ~* \.(html)$ {
            add_header Content-Type "text/html";
        }
        
        location ~* \.(png|jpg|jpeg|gif)$ {
            add_header Content-Type "image/png";
        }
    }

    # API routes - proxy to Node.js server
    location /api/ {
        proxy_pass http://localhost:3002;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # CORS headers for API
        add_header Access-Control-Allow-Origin "*" always;
        add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type" always;
        
        # Handle preflight requests
        if ($request_method = 'OPTIONS') {
            add_header Access-Control-Allow-Origin "*";
            add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS";
            add_header Access-Control-Allow-Headers "Content-Type";
            add_header Access-Control-Max-Age 1728000;
            add_header Content-Type "text/plain charset=UTF-8";
            add_header Content-Length 0;
            return 204;
        }
    }

    # Error pages
    error_page 404 /index.html;
    error_page 500 502 503 504 /50x.html;
    
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
EOF

# Enable the site
sudo ln -sf /etc/nginx/sites-available/games.steadiczech.com /etc/nginx/sites-enabled/

# Test nginx configuration
echo "🔍 Testing Nginx configuration..."
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx configuration is valid"
    echo "🔄 Reloading Nginx..."
    sudo systemctl reload nginx
else
    echo "❌ Nginx configuration has errors. Please check the configuration."
    exit 1
fi

# Set proper permissions
echo "🔐 Setting permissions..."
sudo chown -R server:server /media/server/Storage/www/games.steadiczech.com/html/
chmod -R 755 /media/server/Storage/www/games.steadiczech.com/html/

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "🌐 Your website should now be available at: http://games.steadiczech.com"
echo ""
echo "📊 Useful commands:"
echo "  Check service status: sudo systemctl status games-website.service"
echo "  Restart service: sudo systemctl restart games-website.service"
echo "  View service logs: sudo journalctl -u games-website.service -f"
echo "  Test nginx config: sudo nginx -t"
echo "  Reload nginx: sudo systemctl reload nginx"
echo ""
echo "🔧 Next steps:"
echo "1. Make sure your domain games.steadiczech.com points to this server (172.251.232.135)"
echo "2. Test the website: curl http://games.steadiczech.com"
echo "3. Test the API: curl http://games.steadiczech.com/api/games"
echo "4. Consider setting up SSL/HTTPS for production use"
