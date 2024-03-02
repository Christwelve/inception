#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Exit immediately if a command exits with a non-zero status.
# set -e


# Ensure the WordPress directory exists
if [ ! -d /var/www/wordpress ]; then
    mkdir -p /var/www/wordpress
    # Set permissions for the WordPress directory
    chown www-data:www-data /var/www/wordpress
    chmod 755 /var/www/wordpress
    echo -e "${GREEN}Wordpress directory created.${NC}"
fi

# Wait for MariaDB to fully start
echo -e "${GREEN}Waiting for MariaDB to be ready...${NC}"
until wp db check --allow-root --path='/var/www/wordpress' >/dev/null 2>&1; do
  echo -e "${YELLOW}Waiting for DB to be ready...${NC}"
  sleep 5
done

# Remove existing WP-CLI and download a specific stable version
rm -f /usr/local/bin/wp
wget https://github.com/wp-cli/wp-cli/releases/download/v2.4.0/wp-cli-2.4.0.phar -O wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
echo -e "${GREEN}WP-CLI installed.${NC}"

# Ensure the WordPress core is downloaded
if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
    if ! wp core is-installed --allow-root --path='/var/www/wordpress'; then
        echo -e "${GREEN}Downloading WordPress...${NC}"
        wp core download --allow-root --path='/var/www/wordpress'
    fi

    echo -e "${GREEN}Creating wp-config.php...${NC}"
    wp config create --allow-root \
                     --dbname="$DB_NAME" \
                     --dbuser="$DB_USER" \
                     --dbpass="$DB_PASSWORD" \
                     --dbhost="mariadb:3306" \
                     --path='/var/www/wordpress'
    echo -e "${GREEN}wp-config.php file created.${NC}"
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
    echo -e "${GREEN}WordPress installed.${NC}"
    
    # Assuming you want to install a theme from the WordPress.org repository.
    # Replace 'theme-slug' with the slug of the theme you want to install.
    echo -e "${GREEN}Installing WordPress theme...${NC}"
    wp theme install theme-slug --allow-root --path='/var/www/wordpress'
    echo -e "${GREEN}WordPress theme installed.${NC}"

    # Activate the theme
    echo -e "${GREEN}Activating WordPress theme...${NC}"
    wp theme activate theme-slug --allow-root --path='/var/www/wordpress'
    echo -e "${GREEN}WordPress theme activated.${NC}"
fi

# Create a WordPress user if not already existing
if ! wp user get "$WP_USER" --allow-root --path='/var/www/wordpress' >/dev/null 2>&1; then
    echo -e "${GREEN}Creating WordPress user...${NC}"
    wp user create "$WP_USER" "$WP_USER_MAIL" --allow-root \
                   --user_pass="$WP_PASSWORD" \
                   --role=author \
                   --path='/var/www/wordpress'
    echo -e "${GREEN}WordPress user created.${NC}"
fi

# Ensure the PHP-FPM run directory exists
if [ ! -d /run/php ]; then
    mkdir /run/php
    echo -e "${GREEN}PHP-FPM run directory created.${NC}"
fi

# Start PHP-FPM
echo -e "${GREEN}Starting PHP-FPM...${NC}"
/usr/sbin/php-fpm7.4 -F




### DEBUG MODE ####

# #!/bin/bash

# # Wait for MariaDB to fully start
# sleep 10

# # Ensure the WordPress directory exists
# if [ ! -d /var/www/wordpress ]; then
#     mkdir -p /var/www/wordpress
#     # Set permissions for the WordPress directory
#     chown www-data:www-data /var/www/wordpress
#     chmod 755 /var/www/wordpress
# fi

# # Remove existing WP-CLI and download a specific stable version
# rm -f /usr/local/bin/wp
# wget https://github.com/wp-cli/wp-cli/releases/download/v2.4.0/wp-cli-2.4.0.phar -O wp-cli.phar
# chmod +x wp-cli.phar
# mv wp-cli.phar /usr/local/bin/wp

# # Ensure the WordPress core is downloaded
# if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
#     if ! wp core is-installed --allow-root --path='/var/www/wordpress' --debug; then
#         echo "Downloading WordPress..."
#         wp core download --allow-root --path='/var/www/wordpress' --debug
#     fi

#     echo "Creating wp-config.php..."
#     wp config create --allow-root \
#                      --dbname="$DB_NAME" \
#                      --dbuser="$DB_USER" \
#                      --dbpass="$DB_PASSWORD" \
#                      --dbhost="mariadb:3306" \
#                      --path='/var/www/wordpress' --debug
# fi

# # Install WordPress if not already installed
# if ! wp core is-installed --allow-root --path='/var/www/wordpress' --debug; then
#     echo "Installing WordPress..."
#     wp core install --allow-root \
#                     --url="$WP_URL" \
#                     --title="$WP_TITLE" \
#                     --admin_user="$WP_ADMIN" \
#                     --admin_password="$WP_ADMIN_PASSWORD" \
#                     --admin_email="$WP_ADMIN_MAIL" \
#                     --path='/var/www/wordpress' --debug

#     # Assuming you want to install a theme from the WordPress.org repository.
#     # Replace 'theme-slug' with the slug of the theme you want to install.
#     echo "Installing WordPress theme..."
#     wp theme install theme-slug --allow-root --path='/var/www/wordpress' --debug

#     # Activate the theme
#     echo "Activating WordPress theme..."
#     wp theme activate theme-slug --allow-root --path='/var/www/wordpress' --debug
# fi

# # Create a WordPress user if not already existing
# if ! wp user get "$WP_USER" --allow-root --path='/var/www/wordpress' >/dev/null 2>&1; then
#     echo "Creating WordPress user..."
#     wp user create "$WP_USER" "$WP_USER_MAIL" --allow-root \
#                    --user_pass="$WP_PASSWORD" \
#                    --role=author \
#                    --path='/var/www/wordpress' --debug
# fi

# # Ensure the PHP-FPM run directory exists
# if [ ! -d /run/php ]; then
#     mkdir /run/php
# fi

# # Start PHP-FPM
# /usr/sbin/php-fpm7.4 -F



