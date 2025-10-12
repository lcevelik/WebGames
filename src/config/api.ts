// API configuration
const isDevelopment = import.meta.env.DEV;
const API_BASE_URL = isDevelopment 
  ? 'http://localhost:3002' 
  : 'https://games.steadiczech.com';

export const API_ENDPOINTS = {
  GAMES: isDevelopment 
    ? `${API_BASE_URL}/api/games`
    : `${API_BASE_URL}/api/games`  // Use API server for production too
};
