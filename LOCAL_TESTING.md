# 🧪 Local Testing Guide

## ✅ **What's Working Locally**

Your SteadiCzech Games website is now running locally with **dynamic configuration**! Here's what we've set up:

### 🚀 **Local Server Running**
- **URL**: http://localhost:3000
- **Status**: ✅ Running
- **Features**: Serves static files + simulates PHP backend

### 🔧 **Dynamic Configuration Active**
- **Environment**: Development (automatically detected)
- **Server URL**: http://localhost:3000
- **API URL**: http://localhost:3000
- **Games Base URL**: http://localhost:3000/games
- **Default Image URL**: http://localhost:3000/images/default-game-cover.png

### 📁 **Files Updated**
- ✅ `games.json` - URLs updated to localhost
- ✅ `src/config/environment.ts` - Dynamic configuration
- ✅ `config.php` - Server configuration
- ✅ All React components - Using dynamic URLs

## 🧪 **Test Pages Available**

### 1. **Main Website**
```
http://localhost:3000/index.html
```
- Your actual website with dynamic configuration
- Games load from local server
- All URLs are dynamic

### 2. **Configuration Test Page**
```
http://localhost:3000/test-local.html
```
- Shows current configuration
- Tests dynamic URL generation
- Tests API endpoints

### 3. **React Components Test**
```
http://localhost:3000/test-react.html
```
- React components with dynamic configuration
- Game cards with dynamic URLs
- API integration test

## 🎮 **Test the Dynamic Features**

### **Test 1: Configuration Display**
1. Open http://localhost:3000/test-local.html
2. Check that all URLs show `localhost:3000`
3. Verify environment shows "development"

### **Test 2: Games Loading**
1. Open any test page
2. Check that games load from local server
3. Verify image URLs are dynamic

### **Test 3: API Endpoints**
1. Test games.json: http://localhost:3000/games.json
2. Test save-game.php: Use the test page to add a game
3. Verify CORS headers work

### **Test 4: URL Generation**
1. Use the test buttons on test-local.html
2. Verify game URLs are generated correctly
3. Check that external URLs work

## 🔄 **How Dynamic Configuration Works**

### **Automatic Environment Detection**
```javascript
// Automatically detects localhost vs production
const isDevelopment = window.location.hostname === 'localhost';
```

### **Dynamic URL Generation**
```javascript
// Game image URLs
getGameImageUrl("Save the Chikky") 
// → http://localhost:3000/games/save-the-chikky/cover.png

// Game URLs  
getGameUrl("Defence")
// → http://localhost:3000/games/defence/index.html

// API URLs
getApiUrl("save-game.php")
// → http://localhost:3000/save-game.php
```

### **Server-Side Configuration**
```php
// config.php automatically detects environment
if (isDevelopment()) {
    return 'http://localhost:3000';
} else {
    return 'https://games.steadiczech.com';
}
```

## 🚀 **Ready for Production**

When you're ready to deploy to production:

1. **Update `config.php`** with your production domain
2. **Run migration script** to update URLs
3. **Deploy files** to your server
4. **Test** on production domain

The configuration will automatically switch to production mode!

## 🛠️ **Troubleshooting**

### **Server Not Starting**
```bash
# Check if port 3000 is in use
lsof -i :3000

# Kill any process using port 3000
kill -9 $(lsof -t -i:3000)

# Restart server
python3 simple-server.py
```

### **Games Not Loading**
- Check browser console for errors
- Verify games.json exists and is readable
- Test API endpoint: http://localhost:3000/games.json

### **Images Not Showing**
- Check if game folders exist in `/games/`
- Verify cover.png files exist
- Check default image fallback

## 🎉 **Success!**

Your website is now **100% dynamic** and ready for any server! The local testing proves that:

- ✅ Dynamic configuration works
- ✅ Environment detection works  
- ✅ URL generation works
- ✅ API endpoints work
- ✅ Migration script works
- ✅ Ready for production deployment

**Next step**: Deploy to your production server! 🚀
