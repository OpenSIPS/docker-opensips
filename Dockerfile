FROM debian:buster
LABEL maintainer="Bob Wang <bobw@exetel.com.au>"

USER root

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ARG OPENSIPS_VERSION=3.0
ARG OPENSIPS_BUILD=releases

#install basic components and set local timezone
RUN apt update -qq && apt-get install -y gnupg2 ca-certificates

#install required opensips and modules
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 049AD65B
RUN echo "deb http://apt.opensips.org buster ${OPENSIPS_VERSION}-${OPENSIPS_BUILD}" >/etc/apt/sources.list.d/opensips.list

RUN apt update -qq && apt -y install opensips

ARG OPENSIPS_CLI=false
RUN if [ ${OPENSIPS_CLI} = true ]; then \
    echo "deb https://apt.opensips.org buster cli-${OPENSIPS_BUILD}" >/etc/apt/sources.list.d/opensips-cli.list \
    && apt update -qq && apt -y install opensips-cli \
    && rm -fr /usr/local/bin/opensips-cli /usr/local/lib/python3.6/dist-packages/opensipscli* \
    ;fi

ARG OPENSIPS_JSON_MODULE=false
RUN if [ ${OPENSIPS_JSON_MODULE} = true ]; then \
    apt-get -y install opensips-json-module \
    ;fi

ARG OPENSIPS_REDIS_MODULE=false
RUN if [ ${OPENSIPS_REDIS_MODULE} = true ]; then \
    apt-get -y install opensips-redis-module \
    ;fi

ARG OPENSIPS_HTTP_MODULE=false
RUN if [ ${OPENSIPS_HTTP_MODULE} = true ]; then \
    apt-get -y install opensips-http-modules \
    ;fi

ARG OPENSIPS_MYSQL_MODULE=false
RUN if [ ${OPENSIPS_MYSQL_MODULE} = true ]; then \
    apt-get -y install opensips-mysql-module \
    ;fi

ARG OPENSIPS_DIALPLAN_MODULE=false
RUN if [ ${OPENSIPS_DIALPLAN_MODULE} = true ]; then \
    apt-get -y install opensips-dialplan-module \
    ;fi

ARG OPENSIPS_RESTCLIENT_MODULE=false
RUN if [ ${OPENSIPS_RESTCLIENT_MODULE} = true ]; then \
    apt-get -y install opensips-restclient-module \
    ;fi

RUN rm -rf /var/lib/apt/lists/*

EXPOSE 5060/udp

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
