// Environment Configuration
// This file centralizes all server URLs and paths for easy migration

export interface EnvironmentConfig {
  serverUrl: string;
  apiUrl: string;
  gamesBaseUrl: string;
  defaultImageUrl: string;
  environment: 'development' | 'production';
}

// Get environment variables with fallbacks
const getEnvVar = (key: string, fallback: string): string => {
  return import.meta.env[key] || fallback;
};

// Development configuration
const developmentConfig: EnvironmentConfig = {
  serverUrl: 'http://localhost:3000',
  apiUrl: 'http://localhost:3000',
  gamesBaseUrl: 'http://localhost:3000/games',
  defaultImageUrl: 'http://localhost:3000/images/default-game-cover.png',
  environment: 'development'
};

// Production configuration
const productionConfig: EnvironmentConfig = {
  serverUrl: 'https://games.steadiczech.com',
  apiUrl: 'https://games.steadiczech.com',
  gamesBaseUrl: 'https://games.steadiczech.com/games',
  defaultImageUrl: 'https://games.steadiczech.com/images/default-game-cover.png',
  environment: 'production'
};

// Determine current environment
const isDevelopment = getEnvVar('VITE_ENVIRONMENT', 'development') === 'development';

// Export the appropriate configuration
export const config: EnvironmentConfig = isDevelopment ? developmentConfig : productionConfig;

// Helper functions for common URL operations
export const getGameImageUrl = (gameName: string): string => {
  const folderName = gameName.toLowerCase().replace(/\s+/g, '-');
  return `${config.gamesBaseUrl}/${folderName}/cover.png`;
};

export const getGameUrl = (gameName: string): string => {
  const folderName = gameName.toLowerCase().replace(/\s+/g, '-');
  return `${config.gamesBaseUrl}/${folderName}/index.html`;
};

export const getApiUrl = (endpoint: string): string => {
  return `${config.apiUrl}/${endpoint}`;
};

// Export individual values for convenience
export const {
  serverUrl,
  apiUrl,
  gamesBaseUrl,
  defaultImageUrl,
  environment
} = config;
