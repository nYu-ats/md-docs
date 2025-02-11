include .env

init:
	chmod +x ./api/.docker/entrypoint.sh
	chmod +x ./client/.docker/entrypoint.sh
	chmod +x ./datastore/.docker/entrypoint.sh
	docker compose up -d --build

start:
	docker compose up -d
stop:
	docker compose down