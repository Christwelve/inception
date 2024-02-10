include ./srcs/.env



# nginx:
# 	docker build -t nginx_image ./srcs/requirements/nginx
# 	docker run -d -p 80:80 -p 443:443 --name nginx_container nginx_image

build:
	docker-compose -f srcs/docker-compose.yml up -d --build

down:
	docker-compose -f srcs/docker-compose.yml down

clean:
	docker-compose -f srcs/docker-compose.yml clean

all: build up