
FROM debian:bullseye

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install mariadb-server -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY init-mariadb.sh /tmp/init-mariadb.sh

EXPOSE 3306

ENTRYPOINT ["/tmp/init-mariadb.sh"]

