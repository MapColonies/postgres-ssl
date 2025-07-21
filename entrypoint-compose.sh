#!/bin/bash
set -e

echo "📋 Setting up SSL certificates for PostgreSQL (Docker Compose)..."

# Copy certificates from mounted volumes to writable locations
if [ -f /var/lib/postgresql/server.crt ] && [ -f /var/lib/postgresql/server.key ] && [ -f /var/lib/postgresql/rootCA.crt ]; then
    # Copy to temporary writable location
    cp /var/lib/postgresql/server.crt /tmp/server.crt
    cp /var/lib/postgresql/server.key /tmp/server.key
    cp /var/lib/postgresql/rootCA.crt /tmp/rootCA.crt
    
    # Set proper permissions
    chmod 600 /tmp/server.* /tmp/rootCA.crt
    chown postgres:postgres /tmp/server.* /tmp/rootCA.crt
    
    # Move to final location
    mv /tmp/server.crt /var/lib/postgresql/server.crt
    mv /tmp/server.key /var/lib/postgresql/server.key
    mv /tmp/rootCA.crt /var/lib/postgresql/rootCA.crt
    
    echo "✅ SSL certificates configured successfully!"
else
    echo "❌ SSL certificate files not found!"
    exit 1
fi

# Run the base PostgreSQL entrypoint
exec docker-entrypoint.sh postgres
