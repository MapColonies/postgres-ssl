#!/bin/bash
set -e

echo "🧹 Cleaning up PostgreSQL SSL setup..."

# Stop and remove container
echo "Stopping PostgreSQL container..."
docker stop postgres-ssl 2>/dev/null || true
docker rm postgres-ssl 2>/dev/null || true

# Remove Docker image
echo "Removing Docker image..."
docker rmi postgres-ssl 2>/dev/null || true

# Optional: Remove certificate files (uncomment if you want to clean everything)
# echo "Removing certificate files..."
# rm -rf certs/ keys/ *.pem

echo "✅ Cleanup completed!"
