

FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y nginx openssl

# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=localhost"

# COPY nginx.conf /etc/nginx/sites-available/default


CMD ["nginx", "-g", "daemon off;"]



# RUN rm /etc/nginx/conf.d/default.conf

# COPY nginx.conf /etc/nginx/conf.d/