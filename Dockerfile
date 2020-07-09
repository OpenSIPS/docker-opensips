FROM debian:buster
LABEL maintainer="Bob Wang <bobw@exetel.com.au>"

USER root

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ARG OPENSIPS_VERSION=3.0
ARG OPENSIPS_BUILD=releases

#install basic components
RUN apt update -qq && apt-get install -y gnupg2

#add keyserver, repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 049AD65B
RUN echo "deb http://apt.opensips.org buster ${OPENSIPS_VERSION}-${OPENSIPS_BUILD}" >/etc/apt/sources.list.d/opensips.list

RUN apt-get update -qq && apt-get install -y opensips

EXPOSE 5060/udp

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
