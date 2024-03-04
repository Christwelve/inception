
FROM debian:bullseye

# Install MariaDB server
RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y mariadb-server \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Copy MariaDB configuration file
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init.sh /tmp/init.sh
RUN chmod +x /tmp/init.sh
# Expose MariaDB port
EXPOSE 3306

# Create necessary directories and set permissions
RUN mkdir -p /run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /run/mysqld \
	&& rm -f /run/mysqld/mysqld.sock


# Run the initialization script during container startup
ENTRYPOINT ["/tmp/init.sh"]


