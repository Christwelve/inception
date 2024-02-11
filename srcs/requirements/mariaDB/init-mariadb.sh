#!/bin/bash
service mysql start;

DB_NAME=mariadb
DB_USER=cmeng
DB_PASSWORD=inception
# sudo systemctl start mariadb

# sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
# sudo mysql -u root -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
# sudo mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
# sudo mysql -u root -e "FLUSH PRIVILEGES;"

mysql -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# service mariadb stop;

# mysqld_safe;

exec mysqld