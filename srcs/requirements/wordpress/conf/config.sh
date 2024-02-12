#!/bin/bash

sleep 5
# Ping the SQL server until it's reachable
# until nc -z -v -w30 mariadb 3306
# do
#   echo "Waiting for database connection..."
#   sleep 5
# done

cd /var/www/html

# if [ ! -f /var/www/html/wp-config.php ]; then
# Check if WordPress is already installed
if ! wp core is-installed --allow-root 2>/dev/null; then
    wp core download --allow-root

    wp config create --allow-root \
                     --dbname=$SQL_DATABASE \
                     --dbuser=$SQL_USER \
                     --dbpass=$SQL_PASSWORD \
                     --dbhost=mariadb:3306

    wp core install --allow-root \
                    --url=$WP_URL \
                    --title=$WP_TITLE \
                    --admin_user=$WP_ADMIN_USER \
                    --admin_password=$WP_ADMIN_PASSWORD \
                    --admin_email=$WP_ADMIN_EMAIL

    wp user create --allow-root \
                   $WP_USER $WP_USER_EMAIL \
                   --user_pass=$WP_USER_PASSWORD \
                   --role=$WP_USER_ROLE
fi

if [ ! -d /run/php ]; then
    mkdir /run/php
fi

/usr/sbin/php-fpm7.3 -D