USERNAME ?= lovesegfault
IMAGE ?= hqplayerd

VERSION ?= 4.29.0-110amd

.PHONY: build push

build:
	DOCKER_BUILDKIT=1 docker build -t $(USERNAME)/$(IMAGE):$(VERSION) -f Dockerfile .

push:
	docker push $(USERNAME)/$(IMAGE):$(VERSION)

default: build
