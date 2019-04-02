ID ?= 0

run:
	docker network create devenv || true
	docker run -d -i -t \
		--network="devenv" \
		-e DISPLAY=docker.for.mac.localhost:0 \
		-v="$$HOME/.ssh/id_rsa:/home/leighmcculloch/.ssh/id_rsa" \
		-v="$$PWD:/home/leighmcculloch/devel/devenv" \
		-v="/var/run/docker.sock:/var/run/docker.sock" \
		-p="4567:4567" \
		-p="8080:8080" \
		-p="8000:8000" \
		--name="devenv-$(ID)" \
		leighmcculloch/devenv:latest \
		|| docker start "devenv-$(ID)"
	docker ps
	docker attach --detach-keys="ctrl-a,d" "devenv-$(ID)" || true
	docker ps

stop:
	docker stop $$(docker ps -aq --filter 'name=devenv-*') || true

clean:
	docker rm $$(docker ps -aq --filter 'name=devenv-*') || true

build:
	docker build --no-cache -t leighmcculloch/devenv:latest .

pull:
	docker pull leighmcculloch/devenv:latest
