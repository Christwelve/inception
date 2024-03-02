#!/bin/bash

# Prepare a SQL file with initialization commands using echo commands
echo "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;" > /tmp/init.sql
echo "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';" >> /tmp/init.sql
echo "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';" >> /tmp/init.sql
echo "FLUSH PRIVILEGES;" >> /tmp/init.sql

echo -e "\033[0;32mInit SQL file created\033[0m"

# Start MariaDB in the background temporarily for initialization
mysqld_safe --skip-networking &

# Wait for MariaDB to be ready
while ! mysqladmin ping --silent; do
	echo -e "\033[0;33mWaiting for MariaDB to be ready...\033[0m"
    sleep 1
done

mysql < /tmp/init.sql
mysqladmin shutdown

echo -e "\033[0;32mMariaDB Ready\033[0m"

mysqld_safe


