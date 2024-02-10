#!/bin/bash
source .env
# service mysql start;

SQL_DATABASE=mariadb
SQL_USER=cmeng
SQL_PASSWORD=inception

sudo systemctl start mariadb

sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;"
sudo mysql -u root -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
# mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
# mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'localhost';"
# mysql -e "FLUSH PRIVILEGES;"

# service mariadb stop;

# mysqld_safe;

exec mysqld