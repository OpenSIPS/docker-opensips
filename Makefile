NAME ?= opensips
OPENSIPS_VERSION ?= 3.0
OPENSIPS_BUILD ?= nightly
OPENSIPS_DOCKER_TAG ?= latest

all: build start

.PHONY: build start
build:
	docker build \
		--build-arg=BUILD=$(OPENSIPS_BUILD) \
		--build-arg=VERSION=$(OPENSIPS_VERSION) \
		--tag="opensips/opensips:$(OPENSIPS_DOCKER_TAG)" \
		.

start:
	docker run -d --name $(NAME) opensips/opensips:$(OPENSIPS_VERSION)
