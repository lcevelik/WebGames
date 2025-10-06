<?php
// Server Configuration
// This file centralizes all server settings for easy migration

class ServerConfig {
    // Server URLs - Update these for your new server
    const SERVER_URL = 'https://games.steadiczech.com';
    const DEFAULT_IMAGE_URL = 'https://games.steadiczech.com/images/default-game-cover.png';
    
    // File paths - Update these for your server structure
    const GAMES_JSON_FILE = 'games.json';
    const GAMES_DIRECTORY = 'games';
    const IMAGES_DIRECTORY = 'images';
    
    // Development/Production detection
    public static function isDevelopment() {
        return $_SERVER['HTTP_HOST'] === 'localhost' || 
               strpos($_SERVER['HTTP_HOST'], 'localhost:') === 0 ||
               strpos($_SERVER['HTTP_HOST'], '127.0.0.1') === 0;
    }
    
    // Get the appropriate server URL based on environment
    public static function getServerUrl() {
        if (self::isDevelopment()) {
            return 'http://localhost:3000';
        }
        return self::SERVER_URL;
    }
    
    // Get the default image URL
    public static function getDefaultImageUrl() {
        if (self::isDevelopment()) {
            return 'http://localhost:3000/images/default-game-cover.png';
        }
        return self::DEFAULT_IMAGE_URL;
    }
    
    // Get games directory path
    public static function getGamesDirectory() {
        return $_SERVER['DOCUMENT_ROOT'] . '/' . self::GAMES_DIRECTORY;
    }
    
    // Get images directory path
    public static function getImagesDirectory() {
        return $_SERVER['DOCUMENT_ROOT'] . '/' . self::IMAGES_DIRECTORY;
    }
    
    // Get games.json file path
    public static function getGamesJsonPath() {
        return $_SERVER['DOCUMENT_ROOT'] . '/' . self::GAMES_JSON_FILE;
    }
    
    // Get game image URL for a specific game
    public static function getGameImageUrl($gameName) {
        $folderName = strtolower(preg_replace('/\s+/', '-', $gameName));
        return self::getServerUrl() . '/' . self::GAMES_DIRECTORY . '/' . $folderName . '/cover.png';
    }
    
    // Get game URL for a specific game
    public static function getGameUrl($gameName) {
        $folderName = strtolower(preg_replace('/\s+/', '-', $gameName));
        return self::getServerUrl() . '/' . self::GAMES_DIRECTORY . '/' . $folderName . '/index.html';
    }
}
?>
