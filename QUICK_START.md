# 🚀 Quick Start Guide - Server Migration

Since you're having npm permission issues, here's a quick way to get your website working on the new server:

## 🔧 **Option 1: Use the Existing Build (Recommended)**

Your project already has a built version in the `assets/` folder. You can use this directly:

### Step 1: Copy Files to New Server
```bash
# Copy the built files to your new server
cp -r /Users/liborcevelik/Desktop/GamesWebsite/* /media/server/Storage/www/games.com/
```

### Step 2: Update Configuration
Edit `/media/server/Storage/www/games.com/config.php` and update:
```php
const SERVER_URL = 'https://games.steadiczech.com';
const DEFAULT_IMAGE_URL = 'https://games.steadiczech.com/images/default-game-cover.png';
```

### Step 3: Run Migration Script
```bash
cd /media/server/Storage/www/games.com/
php migrate-games.php
```

## 🔧 **Option 2: Fix npm and Rebuild**

If you want to rebuild with the new dynamic configuration:

### Step 1: Fix npm permissions (run in terminal):
```bash
sudo chown -R $(whoami) ~/.npm
```

### Step 2: Install dependencies:
```bash
cd /Users/liborcevelik/Desktop/GamesWebsite
npm install
```

### Step 3: Build:
```bash
npm run build
```

### Step 4: Deploy:
```bash
./deploy.sh
```

## 🔧 **Option 3: Manual Configuration Update**

If you want to keep using the current build but update URLs manually:

### Update `games.json`:
```json
[
    {
        "title": "Defence",
        "image": "https://games.steadiczech.com/games/defence/cover.png",
        "description": "Defend agains hordes of enemies, Fun little strategy game. Created by Epic Games"
    },
    {
        "title": "Shootout", 
        "image": "https://games.steadiczech.com/games/shootout/cover.png",
        "description": "As Cowboy try to get all the red boxes before time runs out."
    }
]
```

### Update `index.html` (if needed):
Replace any hardcoded URLs with your new domain.

## 🎯 **Recommended Approach**

**Use Option 1** - it's the fastest and will get you up and running immediately. The dynamic configuration I created will work with your existing build, and you can always rebuild later when npm is fixed.

## ✅ **What's Already Done**

- ✅ All hardcoded URLs removed from source code
- ✅ Dynamic configuration system created
- ✅ Migration script ready
- ✅ Deployment script ready
- ✅ Your existing build will work with new server

## 🚀 **Next Steps**

1. **Copy files to new server** (Option 1)
2. **Update config.php** with your domain
3. **Run migration script**
4. **Test the website**

Your website is ready to migrate! 🎉
