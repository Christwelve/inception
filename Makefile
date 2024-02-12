
SRC 	= 	srcs/
REQ 	= 	$(SRC)requirements/
COMPOSE =	$(SRC)docker-compose.yml
MARIA   =	$(REQ)mariadb/
WPRESS  =	$(REQ)wordpress/
ENV		=	--env-file $(SRC).env

DB 		=	$(HOME)/data/db_volume
WP		=	$(HOME)/data/wp_volume

GREEN	=	\033[1;32m
RED		=	\033[1;31m
YELLOW	=	\033[1;33m
CLEAR	=	\033[0m



build:
	mkdir -p $(DB)
	mkdir -p $(WP)
	ls $(HOME)/data/
	docker-compose -f $(COMPOSE) $(ENV) up -d --build
	@echo "$(GREEN)*** Build containers ***$(CLEAR)"

clean:
	docker-compose -f $(COMPOSE) down
	@echo "$(RED)*** Cleaned containers ***$(CLEAR)"

fclean: clean
	rm -rf $(DB) && mkdir -p $(DB)
	rm -rf $(WP) && mkdir -p $(WP)
	@echo "$(RED)*** Cleaned mariadb and wordpress data ***$(CLEAR)"

status:
	docker ps

re: clean build

logs:
	@echo "$(YELLOW)*** Mariadb logs ***$(CLEAR)"
	docker logs mariadb
	@echo "$(YELLOW)*** Wordpress logs ***$(CLEAR)"
	docker logs wordpress

reset:
	docker system prune -af

all: build