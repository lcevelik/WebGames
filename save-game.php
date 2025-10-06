<?php
// Include server configuration
require_once 'config.php';

// Enable CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Only allow POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed. Only POST requests are accepted.']);
    exit();
}

try {
    // Get POST data
    $json = file_get_contents('php://input');
    if (!$json) {
        throw new Exception('No data received. Please ensure you are sending JSON data.');
    }

    $data = json_decode($json);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('Invalid JSON format: ' . json_last_error_msg());
    }

    // Validate required fields
    if (!isset($data->title)) {
        throw new Exception('Game title is required');
    }
    if (!isset($data->image)) {
        throw new Exception('Game image path is required');
    }

    // Read existing games
    $gamesFile = ServerConfig::getGamesJsonPath();
    $games = [];
    
    if (file_exists($gamesFile)) {
        $gamesContent = file_get_contents($gamesFile);
        if ($gamesContent === false) {
            throw new Exception('Unable to read games.json. Check file permissions.');
        }
        $games = json_decode($gamesContent, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception('Error reading games.json: ' . json_last_error_msg());
        }
    }

    // Check if cover.png exists, if not use default image
    $imagePath = parse_url($data->image, PHP_URL_PATH);
    $serverPath = $_SERVER['DOCUMENT_ROOT'] . $imagePath;
    if (!file_exists($serverPath)) {
        // Use default image instead of throwing an error
        $data->image = ServerConfig::getDefaultImageUrl();
    }

    // Add new game
    $games[] = [
        'title' => $data->title,
        'image' => $data->image,
        'description' => $data->description ?? ''
    ];

    // Save updated games
    $saveResult = file_put_contents($gamesFile, json_encode($games, JSON_PRETTY_PRINT));
    if ($saveResult === false) {
        throw new Exception('Failed to save game data. Check write permissions for games.json');
    }

    http_response_code(200);
    echo json_encode(['message' => 'Game saved successfully']);

} catch (Exception $e) {
    error_log('Game save error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'error' => $e->getMessage(),
        'details' => [
            'file_permissions' => [
                'games_json' => is_writable('games.json') ? 'Writable' : 'Not writable',
                'document_root' => $_SERVER['DOCUMENT_ROOT'],
            ],
            'request_data' => json_decode($json ?? '{}'),
        ]
    ]);
}
?>