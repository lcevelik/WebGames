#!/usr/bin/env python3
"""
Game Migration Script - Python Version
Updates existing game URLs to use the new dynamic configuration
"""

import json
import os
from pathlib import Path

def get_server_url():
    """Get the appropriate server URL based on environment"""
    # For local testing, use localhost
    return 'http://localhost:3000'

def get_default_image_url():
    """Get the default image URL"""
    return f'{get_server_url()}/images/default-game-cover.png'

def get_game_image_url(game_name):
    """Get the game image URL for a specific game"""
    folder_name = game_name.lower().replace(' ', '-')
    return f'{get_server_url()}/games/{folder_name}/cover.png'

def get_game_url(game_name):
    """Get the game URL for a specific game"""
    folder_name = game_name.lower().replace(' ', '-')
    return f'{get_server_url()}/games/{folder_name}/index.html'

def migrate_games():
    """Migrate games.json to use new dynamic URLs"""
    print("🚀 Starting game migration...")
    
    # Read existing games.json
    games_file = Path('games.json')
    games = []
    
    if games_file.exists():
        try:
            with open(games_file, 'r') as f:
                games = json.load(f)
            print(f"📖 Loaded {len(games)} games from games.json")
        except Exception as e:
            print(f"❌ Error reading games.json: {e}")
            return False
    else:
        print("📝 No games.json found. Creating new file...")
    
    # Update game URLs
    updated = False
    for game in games:
        old_image = game.get('image', '')
        old_url = game.get('url', '')
        
        # Update image URL if it contains old hardcoded URLs
        if 'steadiczech.com' in old_image or '172.251.232.135' in old_image:
            game['image'] = get_game_image_url(game['title'])
            print(f"🖼️  Updated image URL for '{game['title']}': {old_image} -> {game['image']}")
            updated = True
        
        # Update game URL if it contains old hardcoded URLs
        if 'steadiczech.com' in old_url or '172.251.232.135' in old_url:
            game['url'] = get_game_url(game['title'])
            print(f"🎮 Updated game URL for '{game['title']}': {old_url} -> {game['url']}")
            updated = True
    
    # Save updated games.json if changes were made
    if updated:
        try:
            with open(games_file, 'w') as f:
                json.dump(games, f, indent=2)
            print("✅ Successfully updated games.json with new URLs")
        except Exception as e:
            print(f"❌ Error saving games.json: {e}")
            return False
    else:
        print("ℹ️  No URLs needed updating")
    
    print("🎉 Migration completed!")
    print(f"🌐 Current server configuration:")
    print(f"   Server URL: {get_server_url()}")
    print(f"   Default Image: {get_default_image_url()}")
    print(f"   Games Directory: {get_server_url()}/games/")
    print(f"   Games JSON: {games_file.absolute()}")
    
    return True

if __name__ == "__main__":
    migrate_games()
