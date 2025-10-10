# SteadiCzech Games - Server Deployment Guide

This guide explains how to deploy your games website to the SteadiCzech server.

## Server Information

- **Host**: `172.251.232.135`
- **User**: `server`
- **Path**: `/media/server/Storage/www/games.steadiczech.com/html`
- **URL**: `https://games.steadiczech.com`

## Prerequisites

1. **SSH Access**: You need SSH access to the server
2. **Node.js**: Installed locally for building the project
3. **rsync**: For efficient file transfer

## Quick Start

### 1. Set up SSH Authentication (One-time setup)

```bash
# Run the SSH setup helper
./setup-ssh.sh
```

Follow the instructions to copy your SSH key to the server.

### 2. Deploy to Server

#### Option A: Full Deployment (Recommended)
```bash
# Comprehensive deployment with backup and verification
./deploy-to-server.sh
```

#### Option B: Quick Deployment
```bash
# Simple deployment for quick updates
./quick-deploy.sh
```

## Deployment Scripts

### `deploy-to-server.sh` - Full Deployment
- ✅ Tests SSH connection
- ✅ Builds the project
- ✅ Creates backup of existing deployment
- ✅ Deploys files via rsync
- ✅ Sets proper permissions
- ✅ Runs migration scripts
- ✅ Verifies deployment
- ✅ Provides detailed logging

### `quick-deploy.sh` - Quick Deployment
- ✅ Builds the project
- ✅ Deploys via rsync
- ✅ Copies essential files
- ✅ Sets permissions
- ✅ Minimal logging

## Manual Deployment Steps

If you prefer to deploy manually:

1. **Build the project**:
   ```bash
   npm run build
   ```

2. **Copy files to server**:
   ```bash
   rsync -avz --delete dist/ server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html/
   ```

3. **Copy essential files**:
   ```bash
   scp games.json save-game.php config.php server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html/
   scp -r games/ server@172.251.232.135:/media/server/Storage/www/games.steadiczech.com/html/
   ```

4. **Set permissions**:
   ```bash
   ssh server@172.251.232.135 "chmod -R 755 /media/server/Storage/www/games.steadiczech.com/html"
   ```

## Troubleshooting

### SSH Connection Issues
```bash
# Test SSH connection
ssh server@172.251.232.135 "echo 'Connection successful'"

# If connection fails, check:
# 1. Server is accessible
# 2. SSH key is properly set up
# 3. User has correct permissions
```

### File Permission Issues
```bash
# Check file permissions on server
ssh server@172.251.232.135 "ls -la /media/server/Storage/www/games.steadiczech.com/html"

# Fix permissions if needed
ssh server@172.251.232.135 "chmod -R 755 /media/server/Storage/www/games.steadiczech.com/html"
```

### Build Issues
```bash
# Clean install dependencies
rm -rf node_modules package-lock.json
npm install

# Build again
npm run build
```

### Server Logs
```bash
# Check Apache error logs
ssh server@172.251.232.135 "tail -f /var/log/apache2/error.log"

# Check PHP errors
ssh server@172.251.232.135 "php -v"
```

## File Structure on Server

After deployment, your server should have:
```
/media/server/Storage/www/games.steadiczech.com/html/
├── index.html              # Main application
├── assets/                 # Built CSS/JS files
├── games/                  # Game files
│   ├── defence/
│   ├── ench/
│   ├── game1/
│   ├── game2/
│   └── shootout/
├── games.json             # Game configuration
├── save-game.php          # PHP backend
├── config.php             # PHP configuration
├── favicon.ico            # Favicon
├── og-image.png           # Open Graph image
└── images/                # Images directory
```

## Environment Variables

The deployment uses these environment variables:
- `VITE_ENVIRONMENT`: Set to 'production' for production builds
- Server path: `/media/server/Storage/www/games.steadiczech.com/html`

## Backup Strategy

The full deployment script automatically creates backups:
- Backup location: `${SERVER_PATH}.backup.YYYYMMDD_HHMMSS`
- Manual backup: `cp -r /media/server/Storage/www/games.steadiczech.com/html /path/to/backup`

## Support

If you encounter issues:
1. Check the deployment logs
2. Verify SSH connection
3. Check server disk space
4. Review Apache/PHP logs
5. Test individual components

## Security Notes

- SSH keys are used for authentication
- File permissions are set to 755 for directories, 644 for files
- PHP files have appropriate permissions
- Backup files are created before each deployment
