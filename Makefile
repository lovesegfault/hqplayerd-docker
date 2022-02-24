USERNAME ?= lovesegfault
IMAGE ?= hqplayerd

VERSION ?= 4.30.1-121amd

.PHONY: build push

build:
	DOCKER_BUILDKIT=1 docker build -t $(USERNAME)/$(IMAGE):$(VERSION) -f Dockerfile .

push:
	docker push $(USERNAME)/$(IMAGE):$(VERSION)

default: build
