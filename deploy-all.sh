#!/bin/bash

# Complete deployment script for games.steadiczech.com
# This will copy everything needed to your server

echo "🚀 Complete deployment to games.steadiczech.com..."

# Build the project first
echo "📦 Building project..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed. Exiting."
    exit 1
fi

echo "✅ Build completed successfully"

# Create deployment package
TEMP_DIR="/tmp/games-complete-deploy-$(date +%s)"
mkdir -p "$TEMP_DIR"

echo "📋 Copying all necessary files..."

# Copy built React app
cp -r dist/* "$TEMP_DIR/"

# Copy games directory
cp -r games "$TEMP_DIR/"

# Copy server files
cp server.js "$TEMP_DIR/"
cp package.json "$TEMP_DIR/"

# Copy setup scripts
cp apache-setup.sh "$TEMP_DIR/"
cp apache-games.conf "$TEMP_DIR/"

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

# Create a README with setup instructions
cat > "$TEMP_DIR/README.md" << 'EOF'
# Games Website Deployment

## Quick Setup

1. Run the Apache setup script:
   ```bash
   chmod +x apache-setup.sh
   ./apache-setup.sh
   ```

2. Test the website:
   ```bash
   curl http://games.steadiczech.com
   curl http://games.steadiczech.com/api/games
   ```

## Manual Setup (if needed)

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start the API server:
   ```bash
   node server.js
   ```

3. Configure Apache with the provided apache-games.conf file

## File Structure

- `index.html` - React app
- `assets/` - CSS and JS bundles
- `games/` - All game files
- `server.js` - API server
- `games.json` - Game cards data
- `apache-setup.sh` - Automated setup script
- `apache-games.conf` - Apache configuration
EOF

echo "📤 Uploading everything to server..."

# Upload everything to server
scp -r "$TEMP_DIR"/* server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html/

if [ $? -eq 0 ]; then
    echo "✅ Upload completed successfully!"
    echo "🌐 Files uploaded to: /media/server/Storage/www/games.steadiczech.com/html/"
    echo ""
    echo "📋 Next steps on your server:"
    echo "1. SSH to server: ssh server@172.251.232.135"
    echo "2. cd /media/server/Storage/www/games.steadiczech.com/html/"
    echo "3. chmod +x apache-setup.sh"
    echo "4. ./apache-setup.sh"
    echo ""
    echo "The setup script will:"
    echo "  - Install Node.js dependencies"
    echo "  - Set up the API server as a systemd service"
    echo "  - Configure Apache with proper CORS headers"
    echo "  - Enable required Apache modules"
    echo "  - Set proper file permissions"
else
    echo "❌ Upload failed. Please check your SSH connection and server path."
    echo ""
    echo "Manual upload commands:"
    echo "scp -r dist/* server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html/"
    echo "scp -r games server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html/"
    echo "scp server.js package.json server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html/"
    echo "scp apache-setup.sh apache-games.conf server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html/"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "🎮 Your games website is ready to deploy!"
