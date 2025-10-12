#!/bin/bash

# Manual game addition script
# Usage: ./add-game-manual.sh "Game Title" "Game Description" "game-folder-name"

if [ $# -ne 3 ]; then
    echo "Usage: $0 \"Game Title\" \"Game Description\" \"game-folder-name\""
    echo "Example: $0 \"My Game\" \"A fun puzzle game\" \"my-game\""
    exit 1
fi

GAME_TITLE="$1"
GAME_DESCRIPTION="$2"
GAME_FOLDER="$3"

echo "Adding game: $GAME_TITLE"
echo "Description: $GAME_DESCRIPTION"
echo "Folder: $GAME_FOLDER"

# Create the new game entry
NEW_GAME="  {
    \"title\": \"$GAME_TITLE\",
    \"image\": \"/games/$GAME_FOLDER/cover.png\",
    \"description\": \"$GAME_DESCRIPTION\"
  }"

# Add to games.json
echo "Adding to games.json..."
echo "Please run this on your server:"
echo ""
echo "cd /media/server/Storage/www/games.steadiczech.com/html"
echo "echo '$NEW_GAME,' >> temp_game.json"
echo "head -n -1 games.json > temp_games.json"
echo "echo ',' >> temp_games.json"
echo "cat temp_game.json >> temp_games.json"
echo "echo ']' >> temp_games.json"
echo "mv temp_games.json games.json"
echo "rm temp_game.json"
echo ""
echo "Don't forget to:"
echo "1. Create the game folder: mkdir -p games/$GAME_FOLDER"
echo "2. Add a cover image: cp games/game1/cover.png games/$GAME_FOLDER/cover.png"
echo "3. Add your game files to games/$GAME_FOLDER/"
