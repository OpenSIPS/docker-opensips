FROM debian:bullseye AS base
LABEL maintainer="Razvan Crainea <razvan@opensips.org>"

USER root

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ARG OPENSIPS_VERSION=3.4
ARG OPENSIPS_VERSION_MINOR
ARG OPENSIPS_VERSION_REVISION=1
ARG OPENSIPS_BUILD=releases
ARG OPENSIPS_COMPONENT

#install basic components
RUN apt-get -y update -qq && apt-get -y install gnupg2 ca-certificates

#add keyserver, repository
RUN apt-key adv --fetch-keys https://apt.opensips.org/pubkey.gpg
RUN echo "deb https://apt.opensips.org bullseye \
		$(test -z "${OPENSIPS_COMPONENT}" && \
				echo ${OPENSIPS_VERSION}-${OPENSIPS_BUILD} || \
				echo ${OPENSIPS_COMPONENT})" >/etc/apt/sources.list.d/opensips.list

RUN apt-get -y update -qq && \
    apt-get -y install \
        opensips${OPENSIPS_VERSION_MINOR:+=$OPENSIPS_VERSION.$OPENSIPS_VERSION_MINOR-$OPENSIPS_VERSION_REVISION}

ARG OPENSIPS_CLI=false
ENV OPENSIPS_CLI_ENV=${OPENSIPS_CLI}

RUN if [ ${OPENSIPS_CLI} = true ]; then \
    echo "deb https://apt.opensips.org bullseye cli-nightly" >/etc/apt/sources.list.d/opensips-cli.list \
    && apt-get -y update -qq && apt-get -y install opensips-cli \
    ;fi

ARG OPENSIPS_EXTRA_MODULES
RUN if [ -n "${OPENSIPS_EXTRA_MODULES}" ]; then \
    apt-get -y install ${OPENSIPS_EXTRA_MODULES} \
    ;fi

RUN rm -rf /var/lib/apt/lists/*
RUN sed -i "s/stderror_enabled=no/stderror_enabled=yes/g" /etc/opensips/opensips.cfg && \
    sed -i "s/syslog_enabled=yes/syslog_enabled=no/g" /etc/opensips/opensips.cfg

EXPOSE 5060/udp
HEALTHCHECK --interval=15s --timeout=5s \
   CMD  opensips-cli -x mi uptime|grep -q  "Up time" || exit 1
ENTRYPOINT ["/usr/sbin/opensips", "-F"]

FROM base AS no-healthcheck
HEALTHCHECK NONE

FROM base AS with-healthcheck
HEALTHCHECK --interval=15s --timeout=5s \
    CMD if [ "$OPENSIPS_CLI_ENV" != "true" ]; then \
            exit 0; \
        fi; \
        opensips-cli -x mi uptime | grep -q "Up Time" || exit 1
