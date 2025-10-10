#!/bin/bash

# SteadiCzech Games Server Deployment Script
# Deploys to server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html

set -e  # Exit on any error

# Configuration
SERVER_HOST="172.251.232.135"
SERVER_USER="server"
SERVER_PATH="/media/server/Storage/www/games.steadiczech.com/html"
LOCAL_PROJECT_DIR="/Volumes/HomeDisk/Codebase/GamesWebsite"
BUILD_DIR="dist"
GAMES_DIR="games"
PHP_FILES=("save-game.php" "config.php" "migrate-games.php" "games.json")
PUBLIC_FILES=("favicon.ico" "og-image.png" "placeholder.svg")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to test SSH connection
test_ssh_connection() {
    print_step "Testing SSH connection to server..."
    if ssh -o ConnectTimeout=10 -o BatchMode=yes "$SERVER_USER@$SERVER_HOST" "echo 'SSH connection successful'" 2>/dev/null; then
        print_status "SSH connection successful!"
        return 0
    else
        print_error "SSH connection failed!"
        print_warning "Please ensure:"
        echo "1. SSH key is set up for passwordless authentication"
        echo "2. Server is accessible at $SERVER_HOST"
        echo "3. User '$SERVER_USER' exists on the server"
        echo ""
        echo "To set up SSH key authentication:"
        echo "ssh-copy-id $SERVER_USER@$SERVER_HOST"
        return 1
    fi
}

# Function to build the project
build_project() {
    print_step "Building the project..."
    
    # Check if we're in the right directory
    if [ ! -f "package.json" ]; then
        print_error "package.json not found! Please run this script from the project root."
        exit 1
    fi
    
    # Install dependencies if node_modules doesn't exist
    if [ ! -d "node_modules" ]; then
        print_status "Installing dependencies..."
        npm install
    fi
    
    # Build the project
    print_status "Running build command..."
    npm run build
    
    if [ $? -ne 0 ]; then
        print_error "Build failed! Please check for errors."
        exit 1
    fi
    
    print_status "Build completed successfully!"
}

# Function to prepare files for deployment
prepare_deployment() {
    print_step "Preparing files for deployment..."
    
    # Create a temporary deployment directory
    TEMP_DIR=$(mktemp -d)
    print_status "Using temporary directory: $TEMP_DIR"
    
    # Copy built files
    if [ -d "$BUILD_DIR" ]; then
        cp -r "$BUILD_DIR"/* "$TEMP_DIR/"
        print_status "Copied built files from $BUILD_DIR"
    else
        print_error "Build directory $BUILD_DIR not found! Please run build first."
        exit 1
    fi
    
    # Copy PHP files
    print_status "Copying PHP files..."
    for file in "${PHP_FILES[@]}"; do
        if [ -f "$file" ]; then
            cp "$file" "$TEMP_DIR/"
            print_status "Copied $file"
        else
            print_warning "File not found: $file"
        fi
    done
    
    # Copy public files
    print_status "Copying public files..."
    for file in "${PUBLIC_FILES[@]}"; do
        if [ -f "public/$file" ]; then
            cp "public/$file" "$TEMP_DIR/"
            print_status "Copied public/$file"
        elif [ -f "$file" ]; then
            cp "$file" "$TEMP_DIR/"
            print_status "Copied $file"
        else
            print_warning "File not found: $file"
        fi
    done
    
    # Copy games directory
    if [ -d "$GAMES_DIR" ]; then
        cp -r "$GAMES_DIR" "$TEMP_DIR/"
        print_status "Copied games directory"
    else
        print_warning "Games directory not found: $GAMES_DIR"
    fi
    
    # Create images directory
    mkdir -p "$TEMP_DIR/images"
    
    echo "$TEMP_DIR"
}

# Function to deploy to server
deploy_to_server() {
    local temp_dir="$1"
    
    print_step "Deploying to server..."
    
    # Create server directory if it doesn't exist
    print_status "Creating server directory if needed..."
    ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p $SERVER_PATH"
    
    # Backup existing deployment
    print_status "Creating backup of existing deployment..."
    ssh "$SERVER_USER@$SERVER_HOST" "if [ -d '$SERVER_PATH' ]; then cp -r '$SERVER_PATH' '${SERVER_PATH}.backup.$(date +%Y%m%d_%H%M%S)'; fi"
    
    # Clear existing files (except backup)
    print_status "Clearing existing deployment files..."
    ssh "$SERVER_USER@$SERVER_HOST" "find '$SERVER_PATH' -maxdepth 1 -type f -delete; find '$SERVER_PATH' -maxdepth 1 -type d ! -name '.*' -exec rm -rf {} + 2>/dev/null || true"
    
    # Copy files to server
    print_status "Copying files to server..."
    rsync -avz --delete "$temp_dir/" "$SERVER_USER@$SERVER_HOST:$SERVER_PATH/"
    
    if [ $? -ne 0 ]; then
        print_error "Failed to copy files to server!"
        exit 1
    fi
    
    # Set permissions on server
    print_status "Setting file permissions on server..."
    ssh "$SERVER_USER@$SERVER_HOST" "chmod -R 755 '$SERVER_PATH' && chmod 644 '$SERVER_PATH/games.json' '$SERVER_PATH/save-game.php' '$SERVER_PATH/config.php' 2>/dev/null || true"
    
    # Run migration script on server
    print_status "Running migration script on server..."
    ssh "$SERVER_USER@$SERVER_HOST" "cd '$SERVER_PATH' && php migrate-games.php 2>/dev/null || echo 'Migration script completed with warnings'"
    
    print_status "Deployment to server completed!"
}

# Function to verify deployment
verify_deployment() {
    print_step "Verifying deployment..."
    
    # Check if key files exist on server
    print_status "Checking key files on server..."
    ssh "$SERVER_USER@$SERVER_HOST" "ls -la '$SERVER_PATH/index.html' '$SERVER_PATH/games.json' 2>/dev/null || echo 'Some files missing'"
    
    # Check server disk space
    print_status "Checking server disk space..."
    ssh "$SERVER_USER@$SERVER_HOST" "df -h '$SERVER_PATH'"
    
    print_status "Deployment verification completed!"
}

# Function to cleanup
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        print_status "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}

# Main deployment function
main() {
    echo "🚀 SteadiCzech Games Server Deployment"
    echo "======================================"
    echo "Server: $SERVER_USER@$SERVER_HOST"
    echo "Path: $SERVER_PATH"
    echo ""
    
    # Check prerequisites
    if ! command_exists ssh; then
        print_error "SSH client not found! Please install OpenSSH."
        exit 1
    fi
    
    if ! command_exists rsync; then
        print_error "rsync not found! Please install rsync."
        exit 1
    fi
    
    # Test SSH connection
    if ! test_ssh_connection; then
        exit 1
    fi
    
    # Build project
    build_project
    
    # Prepare deployment
    TEMP_DIR=$(prepare_deployment)
    
    # Deploy to server
    deploy_to_server "$TEMP_DIR"
    
    # Verify deployment
    verify_deployment
    
    # Cleanup
    cleanup
    
    echo ""
    print_status "🎉 Deployment completed successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Visit your website: https://games.steadiczech.com"
    echo "2. Test game loading and functionality"
    echo "3. Check browser console for any errors"
    echo "4. Test adding a new game"
    echo ""
    echo "🔍 If you encounter issues:"
    echo "- Check server logs: ssh $SERVER_USER@$SERVER_HOST 'tail -f /var/log/apache2/error.log'"
    echo "- Verify file permissions: ssh $SERVER_USER@$SERVER_HOST 'ls -la $SERVER_PATH'"
    echo "- Check PHP: ssh $SERVER_USER@$SERVER_HOST 'php -v'"
    echo ""
    echo "📁 Server files location: $SERVER_PATH"
    echo "🌐 Website URL: https://games.steadiczech.com"
}

# Trap to ensure cleanup on exit
trap cleanup EXIT

# Run main function
main "$@"
