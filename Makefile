
SRC 	= 	srcs/
REQ 	= 	$(SRC)requirements/
COMPOSE =	$(SRC)docker-compose.yml
MARIA   =	$(REQ)mariadb/
WPRESS  =	$(REQ)wordpress/
ENV		=	--env-file $(SRC).env

DB 		=	/Users/christianmeng/Documents/projects/inception/data/mariadb
WP		=	/Users/christianmeng/Documents/projects/inception/data/wordpress

GREEN	=	\033[1;32m
RED		=	\033[1;31m
YELLOW	=	\033[1;33m
CLEAR	=	\033[0m



build:
	mkdir -p $(DB)
	mkdir -p $(WP)
	docker-compose -f $(COMPOSE) $(ENV) up -d --build
	@echo "$(GREEN)*** Build containers ***$(CLEAR)"

clean:
	docker-compose -f $(COMPOSE) down
	@echo "$(RED)*** Cleaned containers ***$(CLEAR)"

fclean: clean
	rm -rf $(DB) 
	rm -rf $(WP)
	@echo "$(RED)*** Cleaned mariadb and wordpress data ***$(CLEAR)"

prune: fclean
	docker system prune -af --volumes

status:
	docker ps

re: clean build

logs:
	@echo "$(YELLOW)*** Mariadb logs ***$(CLEAR)"
	docker logs mariadb
	@echo "$(YELLOW)*** Wordpress logs ***$(CLEAR)"
	docker logs wordpress
	@echo "$(YELLOW)*** Nginx logs ***$(CLEAR)"
	docker logs nginx

all: build