USERNAME ?= lovesegfault
IMAGE ?= hqplayerd

VERSION ?= 4.28.3-107amd

.PHONY: build push

build:
	DOCKER_BUILDKIT=1 docker build -t $(USERNAME)/$(IMAGE):$(VERSION) -f Dockerfile .

push:
	docker push $(USERNAME)/$(IMAGE):$(VERSION)

default: build
