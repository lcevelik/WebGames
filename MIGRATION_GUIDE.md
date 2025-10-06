# 🚀 Server Migration Guide

This guide will help you migrate your SteadiCzech Games website from the old server to your new Apache server setup.

## 📋 Pre-Migration Checklist

- [ ] New Apache server is set up and running
- [ ] Domain `games.steadiczech.com` is configured
- [ ] PHP is installed and working
- [ ] File permissions are set correctly
- [ ] You have access to the new server location: `/media/server/Storage/www/games.com`

## 🔧 Configuration Updates

### 1. Update Server Configuration

Edit `config.php` and update these values for your new server:

```php
// Update these URLs for your new server
const SERVER_URL = 'https://games.steadiczech.com';
const DEFAULT_IMAGE_URL = 'https://games.steadiczech.com/images/default-game-cover.png';
```

### 2. Update Environment Configuration

For **development** (localhost:3000):
- No changes needed - it's already configured

For **production** (new server):
- The configuration is already set for `games.steadiczech.com`
- If your domain is different, update `src/config/environment.ts`

## 📁 File Structure Setup

### On Your New Server (`/media/server/Storage/www/games.com`):

```
games.com/
├── index.html                 # Main website
├── games.json                 # Game metadata
├── save-game.php             # PHP API
├── config.php                # Server configuration
├── migrate-games.php          # Migration script
├── games/                     # Game files directory
│   ├── game1/
│   ├── defence/
│   ├── shootout/
│   └── ench/
├── images/                    # Default images
│   └── default-game-cover.png
└── dist/                      # Built React app (after build)
```

## 🚀 Migration Steps

### Step 1: Build the Application

```bash
# Install dependencies
npm install

# Build for production
npm run build
```

### Step 2: Upload Files to New Server

1. **Upload the built application:**
   ```bash
   # Copy the dist folder contents to your server
   cp -r dist/* /media/server/Storage/www/games.com/
   ```

2. **Upload PHP files:**
   ```bash
   cp save-game.php /media/server/Storage/www/games.com/
   cp config.php /media/server/Storage/www/games.com/
   cp migrate-games.php /media/server/Storage/www/games.com/
   cp games.json /media/server/Storage/www/games.com/
   ```

3. **Upload game files:**
   ```bash
   cp -r games/ /media/server/Storage/www/games.com/
   ```

4. **Create images directory and upload default image:**
   ```bash
   mkdir -p /media/server/Storage/www/games.com/images
   # Upload your default-game-cover.png to this directory
   ```

### Step 3: Set File Permissions

```bash
# Set proper permissions
chmod 755 /media/server/Storage/www/games.com/
chmod 644 /media/server/Storage/www/games.com/games.json
chmod 644 /media/server/Storage/www/games.com/save-game.php
chmod 644 /media/server/Storage/www/games.com/config.php
chmod -R 755 /media/server/Storage/www/games.com/games/
```

### Step 4: Run Migration Script

```bash
# Navigate to your server directory
cd /media/server/Storage/www/games.com/

# Run the migration script
php migrate-games.php
```

### Step 5: Test the Application

1. **Visit your new domain:** `https://games.steadiczech.com`
2. **Test game loading:** Check if games load correctly
3. **Test adding games:** Try adding a new game through the interface
4. **Check console:** Look for any errors in browser console

## 🔍 Troubleshooting

### Common Issues:

1. **Games not loading:**
   - Check if `games.json` exists and is readable
   - Verify file permissions
   - Check Apache error logs

2. **Images not showing:**
   - Verify `images/` directory exists
   - Check if `default-game-cover.png` is uploaded
   - Verify game cover images exist in game folders

3. **Adding games fails:**
   - Check PHP error logs
   - Verify `save-game.php` permissions
   - Ensure `games.json` is writable

4. **CORS errors:**
   - Check if CORS headers are set in `save-game.php`
   - Verify Apache configuration

### File Permission Issues:

```bash
# Fix common permission issues
chown -R www-data:www-data /media/server/Storage/www/games.com/
chmod -R 755 /media/server/Storage/www/games.com/
chmod 644 /media/server/Storage/www/games.com/games.json
```

## 🔄 Development vs Production

### Development (localhost:3000):
- Uses `http://localhost:3000` for all URLs
- Automatically detected by the configuration
- No changes needed

### Production (games.steadiczech.com):
- Uses `https://games.steadiczech.com` for all URLs
- Automatically detected by the configuration
- Make sure SSL certificate is properly configured

## 📝 Configuration Files

### Key Files to Update:

1. **`config.php`** - Server configuration
2. **`src/config/environment.ts`** - Frontend configuration
3. **`vite.config.ts`** - Build configuration

### Environment Variables:

The application now uses a centralized configuration system. All URLs are automatically generated based on the current environment (development/production).

## ✅ Post-Migration Verification

- [ ] Website loads at new domain
- [ ] All games display correctly
- [ ] Game images load properly
- [ ] Adding new games works
- [ ] No console errors
- [ ] Mobile responsiveness works
- [ ] All links and navigation work

## 🆘 Support

If you encounter issues:

1. Check Apache error logs: `/var/log/apache2/error.log`
2. Check PHP error logs: `/var/log/php/error.log`
3. Verify file permissions
4. Test PHP functionality: `php -v`
5. Check if all required PHP extensions are installed

## 🎉 Success!

Once everything is working, you can:
- Remove old server files
- Update DNS records
- Set up monitoring
- Configure backups

Your SteadiCzech Games website is now running on your new Apache server! 🚀
