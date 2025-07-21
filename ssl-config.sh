#!/bin/bash
set -e

# Configure PostgreSQL to use SSL
echo "ssl = on" >> /var/lib/postgresql/data/postgresql.conf
echo "ssl_cert_file = '/var/lib/postgresql/server.crt'" >> /var/lib/postgresql/data/postgresql.conf
echo "ssl_key_file = '/var/lib/postgresql/server.key'" >> /var/lib/postgresql/data/postgresql.conf
echo "ssl_ca_file = '/var/lib/postgresql/rootCA.crt'" >> /var/lib/postgresql/data/postgresql.conf

# Force SSL connections only and require client certificates
# This replaces the default pg_hba.conf to enforce certificate authentication
cat > /var/lib/postgresql/data/pg_hba.conf << EOF
# TYPE  DATABASE        USER            ADDRESS                 METHOD
# Local connections for postgres superuser
local   all             postgres                                peer

# Allow postgres user with valid certificates over SSL only
hostssl all             postgres        0.0.0.0/0               cert clientcert=verify-full
hostssl all             postgres        ::/0                    cert clientcert=verify-full

# Allow all other users with valid certificates over SSL only
hostssl all             all             0.0.0.0/0               cert clientcert=verify-full
hostssl all             all             ::/0                    cert clientcert=verify-full
EOF

echo "PostgreSQL SSL configuration completed!"
