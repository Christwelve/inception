#!/bin/bash

sleep 10

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    wp config create --allow-root \
                     --dbname=$SQL_DATABASE \
                     --dbuser=$SQL_USER \
                     --dbpass=$SQL_PASSWORD \
                     --dbhost=mariadb:3306 \
                     --path='/var/www/wordpress'
fi

if [ ! $(wp core is-installed --allow-root --path='/var/www/wordpress') ]; then
    wp core install --allow-root \
                    --url=$WP_URL \
                    --title=$WP_TITLE \
                    --admin_user=$WP_ADMIN_USER \
                    --admin_password=$WP_ADMIN_PASSWORD \
                    --admin_email=$WP_ADMIN_EMAIL \
                    --path='/var/www/wordpress'
fi

if [ ! $(wp user get $WP_USER --allow-root --path='/var/www/wordpress') ]; then
    wp user create --allow-root \
                   $WP_USER $WP_USER_EMAIL \
                   --user_pass=$WP_USER_PASSWORD \
                   --role=$WP_USER_ROLE \
                   --path='/var/www/wordpress'
fi

if [ ! -d /run/php ]; then
    mkdir /run/php
fi

/usr/sbin/php-fpm7.3 -F