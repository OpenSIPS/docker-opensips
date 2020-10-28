FROM debian:buster
LABEL maintainer="Razvan Crainea <razvan@opensips.org>"

USER root

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ARG OPENSIPS_VERSION=3.0
ARG OPENSIPS_BUILD=releases

#install basic components
RUN apt update -qq && apt install -y apt-utils gnupg2 ca-certificates rsyslog default-libmysqlclient-dev 

#add keyserver, repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 049AD65B
RUN echo "deb https://apt.opensips.org buster ${OPENSIPS_VERSION}-${OPENSIPS_BUILD}" >/etc/apt/sources.list.d/opensips.list

RUN apt update -qq && apt install -y opensips

ARG OPENSIPS_CLI=false
RUN if [ ${OPENSIPS_CLI} = true ]; then \
    echo "deb https://apt.opensips.org buster cli-${OPENSIPS_BUILD}" >/etc/apt/sources.list.d/opensips-cli.list \
    && apt update -qq && apt -y install opensips-cli \
    ;fi

ARG OPENSIPS_JSON_MODULE=false
RUN if [ ${OPENSIPS_JSON_MODULE} = true ]; then \
    apt-get -y install opensips-json-module \
    ;fi

ARG OPENSIPS_MYSQL_MODULE=false
RUN if [ ${OPENSIPS_MYSQL_MODULE} = true ]; then \
    apt-get -y install opensips-mysql-module \
    ;fi

ARG OPENSIPS_HTTP_MODULE=false
RUN if [ ${OPENSIPS_HTTP_MODULE} = true ]; then \
    apt-get -y install opensips-http-modules \
    ;fi

ARG OPENSIPS_DIALPLAN_MODULE=false
RUN if [ ${OPENSIPS_DIALPLAN_MODULE} = true ]; then \
    apt-get -y install opensips-dialplan-module \
    ;fi

RUN rm -rf /var/lib/apt/lists/*

RUN chmod 755 /etc/opensips/opensips.cfg

COPY conf/opensips_authdb.cfg /etc/opensips/opensips.cfg
COPY conf/opensips-cli.cfg /etc/opensips/opensips-cli.cfg
COPY conf/logging.conf /etc/rsyslog.d/logging.conf
COPY conf/opensips_cp-create.sql /usr/share/opensips/mysql/opensips_cp-create.sql

EXPOSE 5060/udp

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
