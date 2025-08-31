#!/bin/bash
set -e

echo "🔌 Testing PostgreSQL SSL connection..."

# Check if required files exist
if [ ! -f "certs/rootCA.crt" ] || [ ! -f "certs/admin.crt" ] || [ ! -f "keys/admin.key" ]; then
    echo "❌ Certificate files not found!"
    echo "Please run ./generate-certificates.sh first."
    exit 1
fi

# Check if PostgreSQL container is running
if ! docker ps | grep -q postgres-ssl; then
    echo "❌ PostgreSQL SSL container is not running!"
    echo "Please run ./run-postgres-ssl.sh first."
    exit 1
fi

echo "🔐 Attempting to connect with certificate authentication..."

# Ensure proper permissions on client key
chmod 600 keys/admin.key

# Test connection with certificate authentication
psql "host=localhost port=5432 dbname=mydb user=admin sslmode=verify-full sslrootcert=certs/rootCA.crt sslcert=certs/admin.crt sslkey=keys/admin.key" \
     -c "SELECT 'SSL Connection Successful!' as message, version() as postgresql_version;"

echo "✅ SSL connection test completed successfully!"
