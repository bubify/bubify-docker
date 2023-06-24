SHELL := /bin/bash
.PHONY: docker frontend backend clean clean-db setup update

setup:
	bash tool.sh

update:
	git pull
	cd frontend && git checkout main && git pull origin main && cd ..
	cd backend && git checkout main && git pull origin main && cd ..

restart-backend:
	docker exec -it bubify-backend curl -X GET http://127.0.0.1:8900/restart

add-achievement:
	docker exec -it bubify-backend bash -c 'cd backend/toolbox && zsh add-achievement.sh'

add-user:
	docker exec -it bubify-backend bash -c 'cd backend/toolbox && zsh add-user.sh'

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
