ID ?= 0

default:
	$(call run,default)

rust:
	$(call run,$@)

stop:
	docker stop $$(docker ps -aq)

clean:
	docker rm $$(docker ps -aq)

build:
	docker build -f Dockerfile . -t leighmcculloch/devenv/default:latest

build-extra:
	docker build -f Dockerfile-rust . -t leighmcculloch/devenv/rust:latest

define run
	docker network create devenv || true
	docker run -d -i -t \
		--name="devenv-$(1)-$(ID)" \
		--network="devenv" \
		-e DISPLAY=docker.for.mac.localhost:0 \
		-v="$$HOME/.ssh/id_rsa:/root/.ssh/id_rsa" \
		-v="$$PWD:/root/devel/devenv" \
		-v="/var/run/docker.sock:/var/run/docker.sock" \
		leighmcculloch/devenv/$(1) \
		|| docker start "devenv-$(1)-$(ID)"
	docker ps
	docker attach --detach-keys="ctrl-a,d" "devenv-$(1)-$(ID)" || true
	docker ps
endef
