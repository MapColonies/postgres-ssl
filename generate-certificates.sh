#!/bin/bash
set -e

echo "🔐 Generating SSL certificates for PostgreSQL..."

# Create directories for certificates and keys
mkdir -p certs keys
chmod 700 certs keys

# 1. Generate Root Certificate Authority (CA)
echo "📋 Step 1: Creating Root Certificate Authority..."
openssl genrsa -out keys/rootCA.key 2048
openssl req -x509 -new -nodes -key keys/rootCA.key -sha256 -days 365 -out certs/rootCA.crt -subj "/CN=PostgreSQL-Root-CA"

# 2. Generate Server Certificate
echo "📋 Step 2: Creating Server Certificate..."
openssl genrsa -out keys/server.key 2048
openssl req -new -key keys/server.key -out server.csr -subj "/CN=localhost"
openssl x509 -req -in server.csr -CA certs/rootCA.crt -CAkey keys/rootCA.key -CAcreateserial -out certs/server.crt -days 365 -sha256

# 3. Generate Client Certificate (for postgres user)
echo "📋 Step 3: Creating Client Certificate for postgres..."
openssl genrsa -out keys/client.key 2048
openssl req -new -key keys/client.key -out client.csr -subj "/CN=postgres"
openssl x509 -req -in client.csr -CA certs/rootCA.crt -CAkey keys/rootCA.key -CAcreateserial -out certs/client.crt -days 365 -sha256

# 3b. Generate Client Certificate (for admin user)
echo "📋 Step 3b: Creating Client Certificate for admin..."
openssl genrsa -out keys/admin.key 2048
openssl req -new -key keys/admin.key -out admin.csr -subj "/CN=admin"
openssl x509 -req -in admin.csr -CA certs/rootCA.crt -CAkey keys/rootCA.key -CAcreateserial -out certs/admin.crt -days 365 -sha256

# 4. Create the required .pem files (as requested)
echo "📋 Step 4: Creating .pem files..."
cp certs/server.crt cert.pem
cp keys/server.key key.pem

# 5. Set proper permissions
echo "📋 Step 5: Setting proper permissions..."
chmod 600 keys/* certs/* *.pem
chmod 644 certs/rootCA.crt  # Root CA can be readable

# Clean up temporary files
rm -f server.csr client.csr admin.csr certs/rootCA.srl

echo "✅ Certificate generation completed!"
echo ""
echo "Generated files:"
echo "  📁 Root CA: certs/rootCA.crt"
echo "  📁 Server cert: cert.pem (copy of certs/server.crt)"
echo "  📁 Server key: key.pem (copy of keys/server.key)"
echo "  📁 Client cert (postgres): certs/client.crt"
echo "  📁 Client key (postgres): keys/client.key"
echo "  📁 Client cert (admin): certs/admin.crt"
echo "  📁 Client key (admin): keys/admin.key"
echo ""
echo "⚠️  IMPORTANT: Keep all key files secure and never commit them to version control!"
