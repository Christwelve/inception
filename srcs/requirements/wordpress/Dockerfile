FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install wget php7.3 php-fpm php-mysql mariadb-client
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY conf/init.sh /init.sh

CMD ["/bin/bash", "/init.sh"]