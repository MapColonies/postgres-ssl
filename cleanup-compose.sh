#!/bin/bash
set -e

echo "🧹 Cleaning up PostgreSQL SSL Docker Compose setup..."

# Stop and remove containers, networks, and volumes
echo "Stopping and removing Docker Compose services..."
docker compose down --volumes --remove-orphans 2>/dev/null || true

# Remove Docker images
echo "Removing Docker images..."
docker rmi postgres-ssl 2>/dev/null || true
docker rmi postgresql-ssl-setup-postgres-ssl 2>/dev/null || true

# Remove .env file
echo "Removing .env file..."
rm -f .env

# Optional: Remove certificate files (uncomment if you want to clean everything)
# echo "Removing certificate files..."
# rm -rf certs/ keys/ *.pem

echo "✅ Docker Compose cleanup completed!"
