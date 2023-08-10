build:
	docker compose build
up:
	docker compose up -d
down:
	docker compose down
destroy:
	docker-compose down --rmi all --volumes --remove-orphans
app:
	docker exec -it python_app /bin/bash