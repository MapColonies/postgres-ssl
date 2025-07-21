#!/bin/bash
set -e

echo "📋 Setting up SSL certificates for PostgreSQL..."

# Add certificate files from environment variables
echo "$SERVER_CRT" > /var/lib/postgresql/server.crt
echo "$SERVER_KEY" > /var/lib/postgresql/server.key
echo "$ROOT_CA_CRT" > /var/lib/postgresql/rootCA.crt

# Update file permissions of certificates
chmod 600 /var/lib/postgresql/server.* /var/lib/postgresql/rootCA.crt
chown postgres:postgres /var/lib/postgresql/server.* /var/lib/postgresql/rootCA.crt

echo "✅ SSL certificates configured successfully!"

# Run the base PostgreSQL entrypoint
exec docker-entrypoint.sh postgres
