



nginx:
	docker build -t nginx_image ./srcs/requirements/nginx
	docker run -d -p 80:80 -p 443:443 --name nginx_container nginx_image

# build:
# 	cd srcs && docker-compose build

# up:
# 	cd srcs && docker-compose up -d

# down:
# 	cd srcs && docker-compose down

# clean:
# 	cd srcs && docker-compose down --rmi all

# all: build up