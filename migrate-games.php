<?php
// Game Migration Script
// This script updates existing game URLs to use the new dynamic configuration

require_once 'config.php';

echo "Starting game migration...\n";

// Read existing games.json
$gamesFile = ServerConfig::getGamesJsonPath();
$games = [];

if (file_exists($gamesFile)) {
    $gamesContent = file_get_contents($gamesFile);
    if ($gamesContent === false) {
        die("Error: Unable to read games.json. Check file permissions.\n");
    }
    $games = json_decode($gamesContent, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        die("Error: Invalid JSON in games.json: " . json_last_error_msg() . "\n");
    }
} else {
    echo "No games.json found. Creating new file...\n";
}

// Update game URLs
$updated = false;
foreach ($games as &$game) {
    $oldImage = $game['image'] ?? '';
    $oldUrl = $game['url'] ?? '';
    
    // Update image URL if it contains old hardcoded URLs
    if (strpos($oldImage, 'steadiczech.com') !== false || 
        strpos($oldImage, '172.251.232.135') !== false) {
        $gameName = $game['title'];
        $game['image'] = ServerConfig::getGameImageUrl($gameName);
        echo "Updated image URL for '{$gameName}': {$oldImage} -> {$game['image']}\n";
        $updated = true;
    }
    
    // Update game URL if it contains old hardcoded URLs
    if (strpos($oldUrl, 'steadiczech.com') !== false || 
        strpos($oldUrl, '172.251.232.135') !== false) {
        $gameName = $game['title'];
        $game['url'] = ServerConfig::getGameUrl($gameName);
        echo "Updated game URL for '{$gameName}': {$oldUrl} -> {$game['url']}\n";
        $updated = true;
    }
}

// Save updated games.json if changes were made
if ($updated) {
    $saveResult = file_put_contents($gamesFile, json_encode($games, JSON_PRETTY_PRINT));
    if ($saveResult === false) {
        die("Error: Failed to save updated games.json. Check write permissions.\n");
    }
    echo "Successfully updated games.json with new URLs.\n";
} else {
    echo "No URLs needed updating.\n";
}

echo "Migration completed!\n";
echo "Current server configuration:\n";
echo "- Server URL: " . ServerConfig::getServerUrl() . "\n";
echo "- Default Image: " . ServerConfig::getDefaultImageUrl() . "\n";
echo "- Games Directory: " . ServerConfig::getGamesDirectory() . "\n";
echo "- Games JSON: " . ServerConfig::getGamesJsonPath() . "\n";
?>
