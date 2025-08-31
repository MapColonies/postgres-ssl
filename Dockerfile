# PostgreSQL with SSL/TLS Support
FROM postgres:17

# Copy SSL configuration script (runs on first startup)
COPY ssl-config.sh /docker-entrypoint-initdb.d/ssl-config.sh

# Copy the custom entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make scripts executable
RUN chmod +x /docker-entrypoint-initdb.d/ssl-config.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Set the custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
