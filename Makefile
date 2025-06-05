NAME ?= opensips
OPENSIPS_VERSION ?= master
OPENSIPS_BUILD_ARGS ?=
OPENSIPS_BUILD_PKGS ?=
OPENSIPS_BUILD_MODULES ?=
OPENSIPS_DOCKER_TAG ?= git-$(OPENSIPS_VERSION)

all: build start

.PHONY: build start
build:
	docker build \
		--build-arg=OPENSIPS_VERSION=$(OPENSIPS_VERSION) \
		--build-arg=OPENSIPS_BUILD_MODULES="$(OPENSIPS_BUILD_MODULES)" \
		--build-arg=OPENSIPS_BUILD_ARGS=$(OPENSIPS_BUILD_ARGS) \
		--build-arg=OPENSIPS_BUILD_PKGS="$(OPENSIPS_BUILD_PKGS)" \
		$(if $(OPENSIPS_GIT_REPO),--build-arg="OPENSIPS_GIT_REPO=$(OPENSIPS_GIT_REPO)") \
		--tag="opensips/opensips:$(OPENSIPS_DOCKER_TAG)" \
		.

start:
	docker run -d --name $(NAME) opensips/opensips:$(OPENSIPS_DOCKER_TAG)
