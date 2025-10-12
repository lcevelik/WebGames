#!/bin/bash

# Simple deployment script for games.steadiczech.com
# Just uploads files without server configuration

echo "🚀 Simple deployment to games.steadiczech.com..."

# Build the project
echo "📦 Building project..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed. Exiting."
    exit 1
fi

echo "✅ Build completed successfully"

# Create deployment package
TEMP_DIR="/tmp/games-simple-deploy-$(date +%s)"
mkdir -p "$TEMP_DIR"

# Copy all necessary files
echo "📋 Copying files..."
cp -r dist/* "$TEMP_DIR/"
cp -r games "$TEMP_DIR/"
cp server.js "$TEMP_DIR/"
cp package.json "$TEMP_DIR/"

# Create a simple package.json for production
cat > "$TEMP_DIR/package.json" << 'EOF'
{
  "name": "games-website",
  "version": "1.0.0",
  "type": "module",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {}
}
EOF

echo "📤 Uploading to server..."

# Upload to server
scp -r "$TEMP_DIR"/* server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html/

if [ $? -eq 0 ]; then
    echo "✅ Upload completed successfully!"
    echo "🌐 Files uploaded to: /media/server/Storage/www/games.steadiczech.com/html/"
    echo ""
    echo "📋 Manual setup required on server:"
    echo "1. SSH to server: ssh server@172.251.232.135"
    echo "2. cd /media/server/Storage/www/games.steadiczech.com/html/"
    echo "3. npm install"
    echo "4. Configure web server (nginx/apache) to serve the files"
    echo "5. Set up the Node.js server for API: node server.js"
else
    echo "❌ Upload failed. Please check your SSH connection and server path."
fi

# Cleanup
rm -rf "$TEMP_DIR"
