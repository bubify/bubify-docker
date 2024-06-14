SHELL := /bin/bash
.PHONY: docker frontend backend clean clean-db setup update build-production build-development build-testing build-testing-unit build-testing-integration up-production up-development up-testing test test-unit test-integration clean-docker

build-production:
	docker compose --profile production --env-file .env.production build

build-development:
	docker compose --profile development --env-file .env.development build

build-testing:
	docker compose --profile testing --env-file .env.testing build --build-arg TEST_TYPE=

build-testing-unit:
	docker compose --profile testing --env-file .env.testing build --build-arg TEST_TYPE=unit

build-testing-integration:
	docker compose --profile testing --env-file .env.testing build --build-arg TEST_TYPE=integration

up-production:
	docker compose --profile production --env-file .env.production up -d

up-development:
	docker compose --profile development --env-file .env.development up -d

up-testing:
	docker compose --profile testing --env-file .env.testing up -d

down-production:
	docker compose --profile production down

down-development:
	docker compose --profile development down

down-testing:
	docker compose --profile testing down

test:
	backend/test.sh

test-unit:
	backend/test.sh unit

test-integration:
	backend/test.sh integration

setup:
	bash tool.sh

update:
	git pull
	cd frontend && git checkout main && git pull origin main && cd ..
	cd backend && git checkout main && git pull origin main && cd ..

restart-backend:
	docker exec -it bubify-backend curl -X GET http://127.0.0.1:8900/internal/restart

add-achievement:
	docker exec -it bubify-backend bash -c 'cd backend/toolbox && zsh add-achievement.sh'

add-user:
	docker exec -it bubify-backend bash -c 'cd backend/toolbox && zsh add-user.sh'

clean:
	-docker compose down
	-docker rm -f bubify-frontend
	-docker rm -f bubify-backend
	-docker rm -f bubify-mysql
	-docker rm -f bubify-backend-testing
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

clean-docker:
	-docker rm -f $(docker ps -a -q)
	-docker volume rm $(docker volume ls -q)

