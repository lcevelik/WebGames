#!/bin/bash

# Script to add a new game with proper title
# Usage: ./add-game.sh "Game Name" "game-folder-name"

if [ $# -ne 2 ]; then
    echo "Usage: $0 \"Game Name\" \"game-folder-name\""
    echo "Example: $0 \"Space Adventure\" \"space-adventure\""
    exit 1
fi

GAME_NAME="$1"
GAME_FOLDER="$2"
GAMES_DIR="games"
TEMPLATE_DIR="$GAMES_DIR/game-template"

# Check if game folder already exists
if [ -d "$GAMES_DIR/$GAME_FOLDER" ]; then
    echo "Error: Game folder '$GAME_FOLDER' already exists!"
    exit 1
fi

# Create game directory
mkdir -p "$GAMES_DIR/$GAME_FOLDER"

# Copy template and replace placeholder
if [ -f "$TEMPLATE_DIR/index.html" ]; then
    cp "$TEMPLATE_DIR/index.html" "$GAMES_DIR/$GAME_FOLDER/index.html"
    sed -i.bak "s/GAME_NAME/$GAME_NAME/g" "$GAMES_DIR/$GAME_FOLDER/index.html"
    rm "$GAMES_DIR/$GAME_FOLDER/index.html.bak"
    echo "Created $GAMES_DIR/$GAME_FOLDER/index.html with title: $GAME_NAME"
else
    echo "Error: Template not found at $TEMPLATE_DIR/index.html"
    exit 1
fi

# Create placeholder cover image
echo "Creating placeholder cover image..."
echo "<!-- Placeholder for cover.png -->" > "$GAMES_DIR/$GAME_FOLDER/cover.png"

echo ""
echo "✅ Game '$GAME_NAME' created successfully!"
echo "📁 Location: $GAMES_DIR/$GAME_FOLDER/"
echo "📝 Next steps:"
echo "   1. Add your game files to $GAMES_DIR/$GAME_FOLDER/"
echo "   2. Replace cover.png with actual game cover"
echo "   3. Update games.json to include the new game"
echo "   4. Restart the development server"
