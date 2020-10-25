NAME ?= opensips
OPENSIPS_VERSION ?= 3.1
OPENSIPS_BUILD ?= nightly
OPENSIPS_DOCKER_TAG ?= latest
OPENSIPS_CLI ?= false
OPENSIPS_JSON_MODULE ?= false
OPENSIPS_MYSQL_MODULE ?= false
OPENSIPS_HTTP_MODULE ?= false
OPENSIPS_DIALPLAN_MODULE ?= false

all: build start

.PHONY: build start

build-3.1:
	docker build \
                --build-arg=OPENSIPS_BUILD=$(OPENSIPS_BUILD) \
                --build-arg=OPENSIPS_VERSION=$(OPENSIPS_VERSION) \
                --build-arg=OPENSIPS_CLI=${OPENSIPS_CLI} \
                --build-arg=OPENSIPS_JSON_MODULE=${OPENSIPS_JSON_MODULE} \
                --build-arg=OPENSIPS_MYSQL_MODULE=${OPENSIPS_MYSQL_MODULE} \
                --build-arg=OPENSIPS_HTTP_MODULE=${OPENSIPS_HTTP_MODULE} \
                --build-arg=OPENSIPS_DIALPLAN_MODULE=${OPENSIPS_DIALPLAN_MODULE} \
                --tag="opensips/opensips:$(OPENSIPS_DOCKER_TAG)" \
		-f Dockerfile-3.1 .

build:
	docker build \
		--build-arg=OPENSIPS_BUILD=$(OPENSIPS_BUILD) \
		--build-arg=OPENSIPS_VERSION=$(OPENSIPS_VERSION) \
		--build-arg=OPENSIPS_CLI=${OPENSIPS_CLI} \
		--build-arg=OPENSIPS_JSON_MODULE=${OPENSIPS_JSON_MODULE} \
		--build-arg=OPENSIPS_MYSQL_MODULE=${OPENSIPS_MYSQL_MODULE} \
		--build-arg=OPENSIPS_HTTP_MODULE=${OPENSIPS_HTTP_MODULE} \
		--build-arg=OPENSIPS_DIALPLAN_MODULE=${OPENSIPS_DIALPLAN_MODULE} \
		--tag="opensips/opensips:$(OPENSIPS_DOCKER_TAG)" \
		.

start:
	docker run -d --name $(NAME) opensips/opensips:$(OPENSIPS_DOCKER_TAG)
