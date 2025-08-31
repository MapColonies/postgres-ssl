# PostgreSQL with SSL/TLS Certificate Authentication

This setup provides a complete PostgreSQL instance running in Docker with SSL/TLS encryption and certificate-based authentication (no passwords required).

## Quick Start

### Option 1: Using Docker Compose (Recommended)

1. **Navigate to the setup directory:**
   ```bash
   cd postgresql-ssl-setup
   ```

2. **Generate certificates:**
   ```bash
   ./generate-certificates.sh
   ```

3. **Start PostgreSQL with SSL using Docker Compose:**
   ```bash
   ./run-docker-compose.sh
   ```

4. **Test the connection:**
   ```bash
   ./test-connection.sh
   ```

### Option 2: Using Docker directly

1. **Navigate to the setup directory:**
   ```bash
   cd postgresql-ssl-setup
   ```

2. **Generate certificates:**
   ```bash
   ./generate-certificates.sh
   ```

3. **Start PostgreSQL with SSL:**
   ```bash
   ./run-postgres-ssl.sh
   ```

4. **Test the connection:**
   ```bash
   ./test-connection.sh
   ```

## Files Generated

After running `generate-certificates.sh`, you'll have:

- `certs/rootCA.crt` - Root Certificate Authority (public)
- `cert.pem` - Server certificate (copy of `certs/server.crt`)
- `key.pem` - Server private key (copy of `keys/server.key`)
- `certs/client.crt` - Client certificate for postgres user
- `keys/client.key` - Client private key for postgres user
- `certs/admin.crt` - Client certificate for admin user
- `keys/admin.key` - Client private key for admin user

## Connection Details

- **Host:** localhost
- **Port:** 5432
- **Database:** mydb
- **User:** admin
- **Authentication:** Certificate-based (no password)

## Manual Connection

```bash
psql "host=localhost port=5432 dbname=mydb user=admin sslmode=verify-full sslrootcert=certs/rootCA.crt sslcert=certs/admin.crt sslkey=keys/admin.key"
```

## Docker Compose Commands

Once running with Docker Compose, you can use these commands:

```bash
# View logs
docker compose logs

# Check service status
docker compose ps

# Restart services
docker compose restart

# Stop services (keeps data)
docker compose stop

# Start stopped services
docker compose start

# Stop and remove everything
docker compose down --volumes
```

## Security Features

- ✅ SSL/TLS encryption enforced
- ✅ Certificate-based authentication
- ✅ No password authentication
- ✅ Client certificate verification
- ✅ Server certificate verification

## Cleanup

### Docker Compose cleanup:
```bash
./cleanup-compose.sh
```

### Docker cleanup:
```bash
./cleanup.sh
```

## Important Security Notes

- Keep all `.key` files secure and never commit them to version control
- The `keys/` directory contains private keys and should be protected
- Certificates are valid for 365 days and will need renewal
- In production, use a proper PKI infrastructure

## Troubleshooting

1. **Connection refused:** Make sure the container is running with `docker ps`
2. **Permission denied:** Check file permissions with `ls -la keys/ certs/`
3. **Certificate errors:** Regenerate certificates with `./generate-certificates.sh`
4. **Container logs:** View with `docker logs postgres-ssl`
