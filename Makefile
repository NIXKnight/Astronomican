SHELL = /bin/bash

.PHONY: build update-requirements

build:
	DOCKER_BUILDKIT=1 docker build --no-cache . -t astronomican:latest
update-requirements: build
	docker run --rm -u root -it -v ./:/opt/astronomican --entrypoint=/bin/bash astronomican:latest -c "pip install pip-tools && pip-compile /opt/astronomican/requirements.in -o /opt/astronomican/requirements.txt"
	sudo chown ${USER}:${USER} requirements.txt
