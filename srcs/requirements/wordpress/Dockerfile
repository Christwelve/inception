FROM debian:bullseye

# Install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install wget php7.4 php-fpm php-mysql mariadb-client && \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    rm -rf /var/lib/apt/lists/* # Clean up

# Copy configuration files and scripts
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

# Define volume for WordPress files
VOLUME ["/var/www/html"]

ENTRYPOINT ["/bin/bash", "/init.sh"]
