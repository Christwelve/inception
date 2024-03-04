#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' 

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if all required environment variables are set
REQUIRED_VARS="DB_NAME DB_HOST DB_PORT DB_USER DB_PASSWORD WP_DIR WP_URL WP_TITLE WP_USER WP_PASSWORD WP_USER_MAIL WP_ADMIN WP_ADMIN_PASSWORD WP_ADMIN_MAIL"
for var in $REQUIRED_VARS; do
    if [ -z "${!var}" ]; then
        echo -e "${YELLOW}WARNING: The environment variable $var is not set. The script may not run as expected.${NC}"
    fi
done

# Wait for MariaDB to fully start
echo -e "${YELLOW}Waiting for MariaDB to be ready...${NC}"
until mysqladmin ping -h"$DB_HOST" -P "$DB_PORT" --user="$DB_USER" --password="$DB_PASSWORD" --silent; do
    echo -e "${YELLOW}Waiting for MariaDB to be ready...${NC}"
    sleep 5
done

# Ensure the WordPress directory exists
if [ ! -d "$WP_DIR" ]; then
    mkdir -p "$WP_DIR"
    chown www-data:www-data "$WP_DIR"
    chmod 755 "$WP_DIR"
    echo -e "${GREEN}WordPress directory created.${NC}"
else
    echo -e "${YELLOW}WordPress directory already exists.${NC}"
fi

# Remove existing WP-CLI and download a specific stable version
echo -e "${GREEN}Installing WP-CLI...${NC}"
rm -f /usr/local/bin/wp
wget https://github.com/wp-cli/wp-cli/releases/download/v2.4.0/wp-cli-2.4.0.phar -O wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Ensure the WordPress core is downloaded
if [ ! -f "$WP_DIR/wp-config.php" ]; then
    echo -e "${GREEN}Downloading and configuring WordPress...${NC}"
    wp core download --allow-root --path="$WP_DIR"
    wp config create --allow-root \
                     --dbname="$DB_NAME" \
                     --dbuser="$DB_USER" \
                     --dbpass="$DB_PASSWORD" \
                     --dbhost="$DB_HOST:$DB_PORT" \
                     --path="$WP_DIR"
else
    echo -e "${YELLOW}WordPress already downloaded and configured.${NC}"
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root --path="$WP_DIR"; then
    echo -e "${GREEN}Installing WordPress...${NC}"
    wp core install --allow-root \
                    --url="$WP_URL" \
                    --title="$WP_TITLE" \
                    --admin_user="$WP_ADMIN" \
                    --admin_password="$WP_ADMIN_PASSWORD" \
                    --admin_email="$WP_ADMIN_MAIL" \
                    --path="$WP_DIR"
else
    echo -e "${YELLOW}WordPress is already installed.${NC}"
fi

# Install and activate theme
theme=$(wp theme list --status=active --field=name --allow-root --path="$WP_DIR")
if [[ "$theme" != "twentytwentyfour" ]]; then
    echo -e "${GREEN}Installing and activating theme twentytwentyfour...${NC}"
    wp theme install twentytwentyfour --activate --allow-root --path="$WP_DIR"
else
    echo -e "${YELLOW}Theme twentytwentyfour is already active.${NC}"
fi

# Configure post url structure
echo -e "${GREEN}Configuring post url structure...${NC}"
wp rewrite structure '/%postname%/' --allow-root --path="$WP_DIR"

# Create user 
if ! wp user get "$WP_USER" --allow-root --path="$WP_DIR" >/dev/null 2>&1; then
    echo -e "${GREEN}Creating user $WP_USER...${NC}"
    wp user create "$WP_USER" "$WP_USER_MAIL" --user_pass="$WP_PASSWORD" --role=author --allow-root --path="$WP_DIR"
else
    echo -e "${YELLOW}User $WP_USER already exists.${NC}"
fi

# Ensure the PHP-FPM run directory exists
if [ ! -d /run/php ]; then
    echo -e "${GREEN}Creating PHP-FPM run directory...${NC}"
    mkdir -p /run/php
    echo -e "${GREEN}PHP-FPM run directory created.${NC}"
fi

# Set the correct permissions
echo -e "${GREEN}Setting permissions for PHP-FPM run directory...${NC}"
chmod -R 755 /run/php
chown -R www-data:www-data /run/php

echo -e "${GREEN}Starting PHP-FPM...${NC}"
/usr/sbin/php-fpm7.4 -F
