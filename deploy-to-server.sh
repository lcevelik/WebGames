#!/bin/bash

# Deploy script for games.steadiczech.com
# Server: server@172.251.232.135
# Target: /media/server/Storage/www/games.steadiczech.com/html

echo "🚀 Starting deployment to games.steadiczech.com..."

# Build the project first
echo "📦 Building project..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed. Exiting."
    exit 1
fi

echo "✅ Build completed successfully"

# Create a temporary directory for deployment
TEMP_DIR="/tmp/games-deploy-$(date +%s)"
mkdir -p "$TEMP_DIR"

# Copy dist files
echo "📋 Copying build files..."
cp -r dist/* "$TEMP_DIR/"

# Copy games directory
echo "🎮 Copying games directory..."
cp -r games "$TEMP_DIR/"

# Copy server.js for the API
echo "🔧 Copying server files..."
cp server.js "$TEMP_DIR/"
cp package.json "$TEMP_DIR/"

# Create a simple start script for production
cat > "$TEMP_DIR/start.sh" << 'EOF'
#!/bin/bash
# Start the games website server

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install --production
fi

# Start the server
echo "Starting games server on port 3002..."
node server.js &
SERVER_PID=$!

# Start a simple HTTP server for the static files
echo "Starting static file server on port 80..."
python3 -m http.server 80 --directory . &
HTTP_PID=$!

# Function to cleanup on exit
cleanup() {
    echo "Shutting down servers..."
    kill $SERVER_PID 2>/dev/null
    kill $HTTP_PID 2>/dev/null
    exit 0
}

# Trap signals for cleanup
trap cleanup SIGINT SIGTERM

# Wait for processes
wait
EOF

chmod +x "$TEMP_DIR/start.sh"

# Create nginx configuration
cat > "$TEMP_DIR/nginx.conf" << 'EOF'
server {
    listen 80;
    server_name games.steadiczech.com;
    root /media/server/Storage/www/games.steadiczech.com/html;
    index index.html;

    # Serve static files
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Serve games directory
    location /games/ {
        alias /media/server/Storage/www/games.steadiczech.com/html/games/;
        add_header Cross-Origin-Embedder-Policy require-corp;
        add_header Cross-Origin-Opener-Policy same-origin;
        add_header Cross-Origin-Resource-Policy cross-origin;
        
        # Set proper MIME types
        location ~* \.(wasm)$ {
            add_header Content-Type application/wasm;
        }
        location ~* \.(data)$ {
            add_header Content-Type application/octet-stream;
        }
    }

    # API routes
    location /api/ {
        proxy_pass http://localhost:3002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

echo "📤 Uploading files to server..."

# Upload files to server
scp -r "$TEMP_DIR"/* server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html/

if [ $? -ne 0 ]; then
    echo "❌ Upload failed. Please check your SSH connection and server path."
    exit 1
fi

echo "🔧 Setting up server..."

# SSH into server and set up
ssh server@172.251.232.135 << 'EOF'
cd /media/server/Storage/www/games.steadiczech.com/html

# Remove old files (be careful with this)
echo "🧹 Cleaning old files..."
rm -rf dist/ assets/ public/ 2>/dev/null

# Set proper permissions
echo "🔐 Setting permissions..."
chmod -R 755 .
chmod +x start.sh

# Install Node.js dependencies
echo "📦 Installing dependencies..."
if command -v npm &> /dev/null; then
    npm install --production
else
    echo "⚠️  npm not found. Please install Node.js on the server."
fi

# Create systemd service file
echo "⚙️  Creating systemd service..."
sudo tee /etc/systemd/system/games-website.service > /dev/null << 'EOL'
[Unit]
Description=Games Website Server
After=network.target

[Service]
Type=simple
User=server
WorkingDirectory=/media/server/Storage/www/games.steadiczech.com/html
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and start service
echo "🚀 Starting service..."
sudo systemctl daemon-reload
sudo systemctl enable games-website.service
sudo systemctl restart games-website.service

echo "✅ Deployment completed!"
echo "🌐 Website should be available at: http://games.steadiczech.com"
echo "📊 Check service status with: sudo systemctl status games-website.service"
EOF

# Cleanup
echo "🧹 Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "✅ Deployment completed successfully!"
echo "🌐 Your website should now be available at: http://games.steadiczech.com"
echo ""
echo "📋 Next steps:"
echo "1. Make sure your domain games.steadiczech.com points to 172.251.232.135"
echo "2. Configure nginx with the provided nginx.conf"
echo "3. Check the service status: ssh server@172.251.232.135 'sudo systemctl status games-website.service'"
