#!/usr/bin/env python3
"""
Simple HTTP Server for Testing SteadiCzech Games Locally
This server serves the built files and simulates the PHP backend
"""

import http.server
import socketserver
import json
import os
import urllib.parse
from pathlib import Path

class GamesHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Handle games.json request
        if self.path == '/games.json':
            self.send_games_json()
            return
        
        # Handle other requests normally
        super().do_GET()
    
    def do_POST(self):
        # Handle save-game.php request
        if self.path == '/save-game.php':
            self.handle_save_game()
            return
        
        # Handle other POST requests
        self.send_error(404, "Not Found")
    
    def send_games_json(self):
        """Send the games.json file"""
        try:
            games_file = Path('games.json')
            if games_file.exists():
                with open(games_file, 'r') as f:
                    games_data = f.read()
                
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(games_data.encode())
            else:
                # Return empty games array if file doesn't exist
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(b'[]')
        except Exception as e:
            self.send_error(500, f"Error reading games.json: {str(e)}")
    
    def handle_save_game(self):
        """Handle the save-game.php POST request"""
        try:
            # Read the POST data
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            
            # Parse JSON data
            game_data = json.loads(post_data.decode('utf-8'))
            
            # Read existing games
            games_file = Path('games.json')
            games = []
            if games_file.exists():
                with open(games_file, 'r') as f:
                    games = json.load(f)
            
            # Add new game
            games.append({
                'title': game_data.get('title', ''),
                'image': game_data.get('image', ''),
                'description': game_data.get('description', '')
            })
            
            # Save updated games
            with open(games_file, 'w') as f:
                json.dump(games, f, indent=2)
            
            # Send success response
            response = {'message': 'Game saved successfully'}
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(response).encode())
            
        except Exception as e:
            # Send error response
            response = {'error': f'Failed to save game: {str(e)}'}
            self.send_response(500)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(response).encode())

def main():
    PORT = 3000
    
    # Change to the directory containing the files
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    print(f"🚀 Starting SteadiCzech Games Local Server")
    print(f"📁 Serving from: {os.getcwd()}")
    print(f"🌐 Server running at: http://localhost:{PORT}")
    print(f"🎮 Games API: http://localhost:{PORT}/games.json")
    print(f"💾 Save Game API: http://localhost:{PORT}/save-game.php")
    print(f"🧪 Test Page: http://localhost:{PORT}/test-local.html")
    print(f"\nPress Ctrl+C to stop the server")
    print("=" * 50)
    
    with socketserver.TCPServer(("", PORT), GamesHTTPRequestHandler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print(f"\n\n🛑 Server stopped")
            print("✅ Local testing complete!")

if __name__ == "__main__":
    main()
