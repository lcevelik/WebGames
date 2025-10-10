#!/bin/bash

# SSH Setup Helper for SteadiCzech Games Deployment
# This script helps set up SSH key authentication for passwordless deployment

SERVER_HOST="172.251.232.135"
SERVER_USER="server"

echo "🔑 SSH Setup Helper for SteadiCzech Games"
echo "=========================================="
echo ""

# Check if SSH key exists
if [ ! -f ~/.ssh/id_rsa ] && [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "No SSH key found. Generating a new one..."
    echo ""
    read -p "Enter your email address for the SSH key: " email
    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519
    echo ""
    echo "SSH key generated successfully!"
    echo ""
fi

# Find the public key
if [ -f ~/.ssh/id_ed25519.pub ]; then
    PUBLIC_KEY_FILE=~/.ssh/id_ed25519.pub
elif [ -f ~/.ssh/id_rsa.pub ]; then
    PUBLIC_KEY_FILE=~/.ssh/id_rsa.pub
else
    echo "❌ No public key found!"
    exit 1
fi

echo "📋 Your public key:"
echo "==================="
cat "$PUBLIC_KEY_FILE"
echo ""
echo ""

echo "📝 Next steps:"
echo "=============="
echo "1. Copy the public key above"
echo "2. SSH into your server: ssh $SERVER_USER@$SERVER_HOST"
echo "3. Add the key to authorized_keys:"
echo "   mkdir -p ~/.ssh"
echo "   echo '$(cat "$PUBLIC_KEY_FILE")' >> ~/.ssh/authorized_keys"
echo "   chmod 700 ~/.ssh"
echo "   chmod 600 ~/.ssh/authorized_keys"
echo ""
echo "4. Test the connection:"
echo "   ssh $SERVER_USER@$SERVER_HOST 'echo Connection successful!'"
echo ""
echo "5. Once SSH is working, you can run:"
echo "   ./deploy-to-server.sh"
echo ""

# Test connection
echo "🧪 Testing SSH connection..."
if ssh -o ConnectTimeout=5 -o BatchMode=yes "$SERVER_USER@$SERVER_HOST" "echo 'SSH connection successful'" 2>/dev/null; then
    echo "✅ SSH connection is working!"
    echo "You can now run: ./deploy-to-server.sh"
else
    echo "❌ SSH connection failed. Please follow the setup steps above."
fi
