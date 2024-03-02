#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Prepare a SQL file with initialization commands using echo commands
echo "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;" > /tmp/init.sql
echo "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';" >> /tmp/init.sql
echo "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';" >> /tmp/init.sql
echo "FLUSH PRIVILEGES;" >> /tmp/init.sql

echo -e "${GREEN}Init SQL file created${NC}"

# Start MariaDB in the background temporarily for initialization
mysqld_safe --skip-networking &

# Wait for MariaDB to be ready
while ! mysqladmin ping --silent; do
    echo -e "${YELLOW}Waiting for MariaDB to be ready...${NC}"
    sleep 5
done

mysql < /tmp/init.sql
mysqladmin shutdown

echo -e "${GREEN}MariaDB Ready${NC}"

mysqld_safe



