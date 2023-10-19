NAME ?= opensips
OPENSIPS_VERSION ?= 3.4
OPENSIPS_VERSION_MINOR ?=
OPENSIPS_VERSION_REVISION ?=
OPENSIPS_BUILD ?= releases
OPENSIPS_DOCKER_TAG ?= latest
OPENSIPS_CLI ?= true
OPENSIPS_EXTRA_MODULES ?=
DOCKER_ARGS ?=

all: build start

.PHONY: build start
build:
	docker build \
		--no-cache \
		--build-arg=OPENSIPS_BUILD=$(OPENSIPS_BUILD) \
		--build-arg=OPENSIPS_VERSION=$(OPENSIPS_VERSION) \
		--build-arg=OPENSIPS_VERSION_MINOR=$(OPENSIPS_VERSION_MINOR) \
		--build-arg=OPENSIPS_VERSION_REVISION=$(OPENSIPS_VERSION_REVISION) \
		--build-arg=OPENSIPS_CLI=${OPENSIPS_CLI} \
		--build-arg=OPENSIPS_EXTRA_MODULES=$(OPENSIPS_EXTRA_MODULES) \
		$(DOCKER_ARGS) \
		--tag="opensips/opensips:$(OPENSIPS_DOCKER_TAG)" \
		.

start:
	docker run -d --name $(NAME) opensips/opensips:$(OPENSIPS_DOCKER_TAG)
