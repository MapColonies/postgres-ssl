#!/bin/bash
set -e

echo "🚀 Starting PostgreSQL with SSL/TLS using Docker Compose..."

# Check if certificates exist
if [ ! -f "cert.pem" ] || [ ! -f "key.pem" ] || [ ! -f "certs/rootCA.crt" ]; then
    echo "❌ SSL certificates not found!"
    echo "Please run ./generate-certificates.sh first to create the certificates."
    exit 1
fi

# Stop and remove existing containers
echo "🧹 Cleaning up existing containers..."
docker compose down --volumes 2>/dev/null || true

# Build and start services
echo "🐳 Building and starting PostgreSQL with SSL..."
docker compose up --build -d

echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5

# Wait for health check
echo "🔍 Checking PostgreSQL health..."
for i in {1..30}; do
    if docker compose ps | grep -q "healthy"; then
        break
    elif [ $i -eq 30 ]; then
        echo "❌ PostgreSQL failed to start properly!"
        echo "Check logs with: docker compose logs"
        exit 1
    fi
    sleep 2
done

# Check if container is running
if docker compose ps | grep -q "Up"; then
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
    echo "📊 Useful Docker Compose commands:"
    echo "  docker compose logs        # View logs"
    echo "  docker compose ps          # Check status"
    echo "  docker compose down        # Stop and remove"
    echo "  docker compose restart     # Restart services"
    echo ""
    echo "🛑 To stop the services:"
    echo "  docker compose down"
else
    echo "❌ Failed to start PostgreSQL container!"
    echo "Check logs with: docker compose logs"
    exit 1
fi
