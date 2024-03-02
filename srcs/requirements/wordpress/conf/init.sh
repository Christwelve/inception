#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Exit immediately if a command exits with a non-zero status.
set -e

# Ensure the WordPress directory exists
if [ ! -d /var/www/wordpress ]; then
    mkdir -p /var/www/wordpress
    # Set permissions for the WordPress directory
    chown www-data:www-data /var/www/wordpress
    chmod 755 /var/www/wordpress
    echo -e "${GREEN}Wordpress directory created.${NC}"
else
    echo -e "${YELLOW}WordPress directory already exists.${NC}"
fi

# Remove existing WP-CLI and download a specific stable version
echo -e "${GREEN}Installing WP-CLI...${NC}"
rm -f /usr/local/bin/wp
wget https://github.com/wp-cli/wp-cli/releases/download/v2.4.0/wp-cli-2.4.0.phar -O wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp


# Wait for MariaDB to fully start
echo -e "${YELLOW}Waiting for MariaDB to be ready...${NC}"
until mysqladmin ping -h"$DB_HOST" -P 3306 --user="$DB_USER" --password="$DB_PASSWORD" --silent; do
    echo -e "${YELLOW}Waiting for DB to be ready...${NC}"
    sleep 5
done

# Ensure the WordPress core is downloaded
if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
    echo -e "${GREEN}Downloading and configuring WordPress...${NC}"
    wp core download --allow-root --path='/var/www/wordpress'
    wp config create --allow-root \
                     --dbname="$DB_NAME" \
                     --dbuser="$DB_USER" \
                     --dbpass="$DB_PASSWORD" \
                     --dbhost="$DB_HOST:$DB_PORT" \
                     --path='/var/www/wordpress'
else
    echo -e "${YELLOW}WordPress already downloaded and configured.${NC}"
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root --path='/var/www/wordpress'; then
    echo -e "${GREEN}Installing WordPress...${NC}"
    wp core install --allow-root \
                    --url="$WP_URL" \
                    --title="$WP_TITLE" \
                    --admin_user="$WP_ADMIN" \
                    --admin_password="$WP_ADMIN_PASSWORD" \
                    --admin_email="$WP_ADMIN_MAIL" \
                    --path='/var/www/wordpress'
else
    echo -e "${YELLOW}WordPress is already installed.${NC}"
fi

# echo -e "${GREEN}Installing Theme...${NC}"
# 	wp theme install twentytwentythree --activate --allow-root

# Create a WordPress user if not already existing
if ! wp user get "$WP_USER" --allow-root --path='/var/www/wordpress' >/dev/null 2>&1; then
    echo -e "${GREEN}Creating WordPress user...${NC}"
    wp user create "$WP_USER" "$WP_USER_MAIL" --allow-root \
                   --user_pass="$WP_PASSWORD" \
                   --role=author \
                   --path='/var/www/wordpress'
else
    echo -e "${YELLOW}WordPress user already exists.${NC}"
fi

# Ensure the PHP-FPM run directory exists and start PHP-FPM
if [ ! -d /run/php ]; then
    mkdir /run/php
    echo -e "${GREEN}PHP-FPM run directory created.${NC}"
fi
echo -e "${GREEN}Starting PHP-FPM...${NC}"
/usr/sbin/php-fpm7.4 -F
