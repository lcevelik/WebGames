# Welcome to Local Games Website

This project provides a gaming marketplace platform for hosting and managing browser-based games locally.

## Quick Start

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start the development server:
   ```bash
   npm run dev
   ```

3. Access the website:
   - Open http://localhost:8080 in your browser
   - Games are served from the `/games/` directory

## Features

- Modern, responsive gaming marketplace
- Local game hosting
- Easy game management interface
- No external dependencies

## Project Structure

```
/games/           # Game files directory
  /defence/       # Defence game
  /shootout/      # Shootout game
  /game1/         # Simple HTML game 1
  /game2/         # Simple HTML game 2
/games.json       # Game metadata
/src/            # React application source
/public/         # Static assets
```

## Adding Games

1. Create a new folder in `/games/[game-name]/`
2. Add `index.html` and `cover.png` files
3. Update `/games.json` with game metadata
4. Restart the development server

## Development

- **Frontend**: React + TypeScript + Vite
- **Styling**: Tailwind CSS
- **Server**: Vite development server
- **Port**: 8080