# Welcome to SteadiCzech Games

This project provides a gaming marketplace platform for hosting and managing browser-based games on a Synology NAS.

## Quick Start

1. Set up environment:
   ```
   VITE_SERVER_URL=https://steadiczech.com
   ```

2. Configure your Synology NAS:
   - Enable Web Station
   - Configure permissions
   - Follow the [server configuration guide](docs/server-configuration.md)

3. Start adding games:
   - Create game folders in `/volume1/web/games/`
   - Add required files (index.html, cover.png)
   - Use the "Add Game" dialog to create game cards
   - See [game management guide](docs/game-management.md)

## Documentation

- [Server Configuration](docs/server-configuration.md) - Set up your Synology NAS
- [Game Management](docs/game-management.md) - Add and manage games
- [Folder Structure](docs/folder-structure.md) - Directory layout and file requirements
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions

## Features

- Modern, responsive gaming marketplace
- Automatic game card generation
- Browser-based game hosting
- Server-side metadata storage
- Easy game management interface

## Project Info

**URL**: http://lovable.dev/projects/3b150eda-38eb-4e1e-9a65-82e2ecd9bf97
**Version**: 4.0.0

## Important Notes

1. **Game Cards vs Game Files**:
   - Game cards (metadata) are managed through the web interface
   - Actual game files must be manually uploaded to the server
   - Each game requires index.html and cover.png

2. **Server Requirements**:
   - Synology NAS with Web Station enabled (https://steadiczech.com)
   - PHP support for metadata management
   - Proper file permissions
   - Apache/Nginx configuration

3. **Game Management**:
   - Use "Add Game" dialog for metadata
   - Manually upload game files
   - Follow folder structure guidelines
   - Ensure cover.png is present

4. **File Structure**:
   - `games.json` and `save-game.php` are located in the root directory
   - Game files are stored in `/volume1/web/games/[game-name]/`
   - Each game folder must contain `index.html` and `cover.png`

For detailed setup instructions and guidelines, refer to the documentation links above.# GamesWebsite
