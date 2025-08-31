#!/bin/bash
set -e

echo "🔧 Generating .env file for Docker Compose..."

# Check if certificates exist
if [ ! -f "cert.pem" ] || [ ! -f "key.pem" ] || [ ! -f "certs/rootCA.crt" ]; then
    echo "❌ SSL certificates not found!"
    echo "Please run ./generate-certificates.sh first."
    exit 1
fi

# Create .env file with certificate contents
cat > .env << EOF
# SSL Certificate Environment Variables
# Generated automatically - DO NOT EDIT MANUALLY

SERVER_CRT=$(cat cert.pem)

SERVER_KEY=$(cat key.pem)

ROOT_CA_CRT=$(cat certs/rootCA.crt)
EOF

echo "✅ .env file generated successfully!"
echo "You can now use 'docker-compose up' to start PostgreSQL."
