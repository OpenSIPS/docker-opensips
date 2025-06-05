FROM debian:bullseye
LABEL maintainer="Razvan Crainea <razvan@opensips.org>"

USER root

# Set Environment Variables
ENV DEBIAN_FRONTEND=noninteractive

ARG OPENSIPS_VERSION=master
ARG OPENSIPS_GIT_REPO=https://github.com/OpenSIPS/opensips.git
ARG OPENSIPS_BUILD_MODULES
ARG OPENSIPS_BUILD_PKGS
ARG OPENSIPS_BUILD_ARGS

WORKDIR /usr/src/opensips
#install basic components
RUN apt-get -y update -qq && apt-get -y install \
	git \
	bison \
	flex \
	make \
	patch \
	pkg-config \
	libssl-dev \
	libncurses5-dev

RUN test -n "${OPENSIPS_BUILD_PKGS}" && \
		apt-get -y install ${OPENSIPS_BUILD_PKGS} || true

RUN git clone -b ${OPENSIPS_VERSION} ${OPENSIPS_GIT_REPO} .

RUN cp Makefile.conf.template Makefile.conf

RUN echo cfg_dir=../etc/opensips/ >> Makefile.conf
RUN echo PREFIX=/usr >> Makefile.conf
RUN echo LIBDIR=lib/x86_64-linux-gnu >> Makefile.conf
RUN echo "include_modules=${OPENSIPS_BUILD_MODULES}" >> Makefile.conf

RUN make ${OPENSIPS_BUILD_ARGS} install

EXPOSE 5060/udp

RUN rm -rf /var/lib/apt/lists/*
RUN sed -i "s#log_stderror=no#log_stderror=yes#g" /etc/opensips/opensips.cfg
RUN sed -i "s#/run/opensips#/run#g" /etc/opensips/opensips.cfg

EXPOSE 5060/udp

ENTRYPOINT ["/usr/sbin/opensips", "-F"]
