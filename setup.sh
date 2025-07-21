#!/bin/bash
set -e

echo "🚀 PostgreSQL SSL Complete Setup"
echo "================================="

# Make all scripts executable
echo "📋 Making scripts executable..."
chmod +x *.sh

echo ""
echo "✅ Setup complete! You can now:"
echo ""
echo "1. Generate certificates:"
echo "   ./generate-certificates.sh"
echo ""
echo "2a. Start with Docker Compose (recommended):"
echo "    ./run-docker-compose.sh"
echo ""
echo "2b. Or start with Docker directly:"
echo "    ./run-postgres-ssl.sh"
echo ""
echo "3. Test the connection:"
echo "   ./test-connection.sh"
echo ""
echo "4a. Clean up Docker Compose:"
echo "    ./cleanup-compose.sh"
echo ""
echo "4b. Clean up Docker:"
echo "    ./cleanup.sh"
echo ""
echo "📖 For more details, see README.md"
