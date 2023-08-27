SHELL = /bin/bash

.PHONY: build update-requirements

up:
	docker compose up -d
down:
	docker compose down
build:
	DOCKER_BUILDKIT=1 docker build --no-cache . -t astronomican:latest
# build-dev will create an image that has development pacakges.
# This image is specifically used with pip-tools to update the requirements file.
build-dev:
	DOCKER_BUILDKIT=1 docker build --no-cache . --target builder -t astronomican-dev:latest
update-requirements:
	docker run --rm -u root -it -v ./:/opt/astronomican --entrypoint=/bin/bash astronomican:latest -c "pip install pip-tools && pip-compile /opt/astronomican/requirements.in -o /opt/astronomican/requirements.txt"
	sudo chown ${USER}:${USER} requirements.txt
astronomican-shell:
	docker compose exec astronomican_web /bin/bash
kea-dhcp-shell:
	docker compose exec kea_dhcp /bin/bash
kea-ctrl-agent-shell:
	docker compose exec kea_ctrl_agent /bin/bash
test-dhcp:
	docker compose exec dhcp-client-test /bin/bash -c "apt-get update && apt-get install -y dhcpcd && dhcpcd -T eno1"
