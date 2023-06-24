SHELL := /bin/bash
.PHONY: docker frontend backend clean clean-db setup

setup:
	bash tool.sh

docker:
	docker build -t bubify .

frontend:
	docker exec -it bubify bash -c 'cd frontend && npm ci'

backend:
	docker exec -it bubify bash -c 'cd backend && mvn compile'

start:
	docker compose up -d

clean:
	-docker compose down
	-docker rm -f bubify-frontend
	-docker rm -f bubify-backend
	-docker rm -f bubify-mysql
	-docker volume rm bubify-mysql-db
	-docker volume rm bubify-frontend-build
	-docker volume rm bubify-frontend-node_modules
	-docker volume rm bubify-frontend-profile_pictures
	-docker volume rm bubify-backend-au_backups
	-docker volume rm bubify-target

clean-db:
	-docker compose down
	-docker rm -f bubify-mysql
	-docker volume rm -f bubify-mysql-db