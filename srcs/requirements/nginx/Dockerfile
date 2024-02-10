
FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y nginx openssl


RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /var/run/nginx

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/inception.key -out /etc/nginx/ssl/inception.crt -subj "/C=DE/ST=BW/L=HN/O=42 Heilbronn/OU=student/CN=cmeng.42.fr/"

COPY conf/nginx.conf /etc/nginx
EXPOSE 443


CMD ["nginx", "-g", "daemon off;"]

