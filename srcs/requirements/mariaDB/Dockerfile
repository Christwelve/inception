
FROM debian:bullseye

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install mariadb-server -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY init-mariadb.sh init-mariadb.sh

RUN chmod +x init-mariadb.sh
RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld
# RUN rm -f /run/mysqld/mysqld.sock

EXPOSE 3306

CMD ["./init-mariadb.sh"]
