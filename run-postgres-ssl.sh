#!/bin/bash
set -e

echo "🚀 Starting PostgreSQL with SSL/TLS support..."

# Check if certificates exist
if [ ! -f "cert.pem" ] || [ ! -f "key.pem" ] || [ ! -f "certs/rootCA.crt" ]; then
    echo "❌ SSL certificates not found!"
    echo "Please run ./generate-certificates.sh first to create the certificates."
    exit 1
fi

# Stop and remove existing container if it exists
echo "🧹 Cleaning up existing container..."
docker stop postgres-ssl 2>/dev/null || true
docker rm postgres-ssl 2>/dev/null || true

# Build the PostgreSQL SSL Docker image
echo "🔧 Building PostgreSQL SSL Docker image..."
docker build -t postgres-ssl .

# Run PostgreSQL container with SSL enabled
echo "🐳 Starting PostgreSQL container with SSL..."
docker run -d \
  --name postgres-ssl \
  -e POSTGRES_DB=mydb \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=temp_password_not_used \
  -e SERVER_CRT="$(cat cert.pem)" \
  -e SERVER_KEY="$(cat key.pem)" \
  -e ROOT_CA_CRT="$(cat certs/rootCA.crt)" \
  -p 5432:5432 \
  postgres-ssl

echo "⏳ Waiting for PostgreSQL to start..."
sleep 10

# Check if container is running
if docker ps | grep -q postgres-ssl; then
    echo "✅ PostgreSQL with SSL is running!"
    echo ""
    echo "📋 Connection Information:"
    echo "  Host: localhost"
    echo "  Port: 5432"
    echo "  Database: mydb"
    echo "  User: admin (certificate-based auth)"
    echo ""
    echo "🔐 To connect using certificates:"
    echo "  psql \"host=localhost port=5432 dbname=mydb user=admin sslmode=verify-full sslrootcert=certs/rootCA.crt sslcert=certs/admin.crt sslkey=keys/admin.key\""
    echo ""
    echo "📊 To view container logs:"
    echo "  docker logs postgres-ssl"
    echo ""
    echo "🛑 To stop the container:"
    echo "  docker stop postgres-ssl"
else
    echo "❌ Failed to start PostgreSQL container!"
    echo "Check logs with: docker logs postgres-ssl"
    exit 1
fi
