USERNAME ?= lovesegfault
IMAGE ?= hqplayerd

VERSION ?= 4.25.2
RELEASE ?= 1

.PHONY: build push

build:
	DOCKER_BUILDKIT=1 docker build -t $(USERNAME)/$(IMAGE):$(VERSION)-$(RELEASE) -f Dockerfile .

push:
	docker push $(USERNAME)/$(IMAGE):$(VERSION)-$(RELEASE)

default: build
