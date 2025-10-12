import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const PORT = 3002;
const gamesJsonPath = path.join(__dirname, 'games.json');

// Read games from JSON file
const readGames = () => {
  try {
    const data = fs.readFileSync(gamesJsonPath, 'utf8');
    return JSON.parse(data);
  } catch (error) {
    console.error('Error reading games.json:', error);
    return [];
  }
};

// Write games to JSON file
const writeGames = (games) => {
  try {
    fs.writeFileSync(gamesJsonPath, JSON.stringify(games, null, 2));
    return true;
  } catch (error) {
    console.error('Error writing games.json:', error);
    return false;
  }
};

// Parse JSON from request body
const parseJSON = (req) => {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
    });
    req.on('end', () => {
      try {
        resolve(JSON.parse(body));
      } catch (error) {
        reject(error);
      }
    });
  });
};

// Send JSON response
const sendJSON = (res, statusCode, data) => {
  res.writeHead(statusCode, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
  });
  res.end(JSON.stringify(data));
};

// Handle CORS preflight
const handleCORS = (req, res) => {
  if (req.method === 'OPTIONS') {
    res.writeHead(200, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type'
    });
    res.end();
    return true;
  }
  return false;
};

const server = http.createServer(async (req, res) => {
  // Handle CORS
  if (handleCORS(req, res)) return;

  const url = new URL(req.url, `http://${req.headers.host}`);
  const pathname = url.pathname;

  try {
    // GET /api/games - Get all games
    if (pathname === '/api/games' && req.method === 'GET') {
      const games = readGames();
      sendJSON(res, 200, games);
      return;
    }

    // POST /api/games - Add new game
    if (pathname === '/api/games' && req.method === 'POST') {
      const gameData = await parseJSON(req);
      const { title, image, description, url } = gameData;
      
      // Validate required fields
      if (!title || !image || !description) {
        sendJSON(res, 400, { error: 'Title, image, and description are required' });
        return;
      }
      
      // Read existing games
      const games = readGames();
      
      // Check if game already exists (by title)
      const existingGame = games.find(game => game.title === title);
      if (existingGame) {
        sendJSON(res, 409, { error: 'Game with this title already exists' });
        return;
      }
      
      // Create new game object
      const newGame = {
        title,
        image,
        description,
        url: url || undefined
      };
      
      // Add to games array
      games.push(newGame);
      
      // Write back to file
      const success = writeGames(games);
      if (!success) {
        sendJSON(res, 500, { error: 'Failed to save game' });
        return;
      }
      
      sendJSON(res, 201, { message: 'Game added successfully', game: newGame });
      return;
    }

    // PUT /api/games/:title - Update game
    if (pathname.startsWith('/api/games/') && req.method === 'PUT') {
      const title = decodeURIComponent(pathname.split('/')[3]);
      const gameData = await parseJSON(req);
      const { image, description, url } = gameData;
      
      const games = readGames();
      const gameIndex = games.findIndex(game => game.title === title);
      
      if (gameIndex === -1) {
        sendJSON(res, 404, { error: 'Game not found' });
        return;
      }
      
      // Update game
      games[gameIndex] = {
        ...games[gameIndex],
        image: image || games[gameIndex].image,
        description: description || games[gameIndex].description,
        url: url !== undefined ? url : games[gameIndex].url
      };
      
      const success = writeGames(games);
      if (!success) {
        sendJSON(res, 500, { error: 'Failed to update game' });
        return;
      }
      
      sendJSON(res, 200, { message: 'Game updated successfully', game: games[gameIndex] });
      return;
    }

    // DELETE /api/games/:title - Delete game
    if (pathname.startsWith('/api/games/') && req.method === 'DELETE') {
      const title = decodeURIComponent(pathname.split('/')[3]);
      
      const games = readGames();
      const gameIndex = games.findIndex(game => game.title === title);
      
      if (gameIndex === -1) {
        sendJSON(res, 404, { error: 'Game not found' });
        return;
      }
      
      // Remove game
      games.splice(gameIndex, 1);
      
      const success = writeGames(games);
      if (!success) {
        sendJSON(res, 500, { error: 'Failed to delete game' });
        return;
      }
      
      sendJSON(res, 200, { message: 'Game deleted successfully' });
      return;
    }

    // 404 for other routes
    sendJSON(res, 404, { error: 'Route not found' });

  } catch (error) {
    console.error('Server error:', error);
    sendJSON(res, 500, { error: 'Internal server error' });
  }
});

// Start server
server.listen(PORT, '0.0.0.0', () => {
  console.log(`Game server running on http://0.0.0.0:${PORT}`);
  console.log('Available endpoints:');
  console.log('  GET    /api/games     - Get all games');
  console.log('  POST   /api/games     - Add new game');
  console.log('  PUT    /api/games/:title - Update game');
  console.log('  DELETE /api/games/:title - Delete game');
});