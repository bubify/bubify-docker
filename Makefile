SHELL := /bin/bash
.PHONY: docker frontend backend clean clean-db

docker:
	docker build -t bubify .

frontend:
	docker exec -it bubify bash -c 'cd frontend && npm ci'

backend:
	docker exec -it bubify bash -c 'cd backend && mvn compile'

start:
	docker compose up -d

clean:
	-docker-compose down
	-docker rm -f bubify
	-docker rm -f bubify-mysql
	-docker volume rm bubify-frontend-build
	-docker volume rm bubify-frontend-node_modules
	-docker volume rm bubify-frontend-profile_pictures

clean-db:
	-docker rm -f mysql
	-docker volume rm -f mysql-db