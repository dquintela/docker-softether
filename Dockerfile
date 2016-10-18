FROM i386/ubuntu:16.04
MAINTAINER Diogo Quintela <dquintela@gmail.com>

# Persist on final image
ENV SOFTETHER_BIN /usr/local/bin
ENV SOFTETHER_INSTALL /usr/local/softether

# ENV like, but does not persist on final image
ARG BUILD_DIR=/tmp/SoftEtherVPN
ARG SOFTETHER_CPU=32bit
ARG DEBIAN_FRONTEND=noninteractive

RUN set -xe \
&& apt-get update \
&& apt-get install -q -y libreadline6 libssl1.0.0 libncurses5 \
&& apt-get install -q -y git make gcc libreadline6-dev libssl-dev libncurses5-dev \
&& git clone --depth=1 https://github.com/SoftEtherVPN/SoftEtherVPN.git ${BUILD_DIR} \
&& cd ${BUILD_DIR} \
&& cp src/makefiles/linux_${SOFTETHER_CPU}.mak Makefile \
&& make CC=gcc \
&& make install \
INSTALL_BINDIR=${SOFTETHER_BIN}/ \
INSTALL_VPNSERVER_DIR=${SOFTETHER_INSTALL}/vpnserver/ \
INSTALL_VPNBRIDGE_DIR=${SOFTETHER_INSTALL}/vpnbridge/ \
INSTALL_VPNCLIENT_DIR=${SOFTETHER_INSTALL}/vpnclient/ \
INSTALL_VPNCMD_DIR=${SOFTETHER_INSTALL}/vpncmd/ \
&& apt-get remove -y --auto-remove --purge git make gcc libreadline6-dev libssl-dev libncurses5-dev \
&& apt-get clean \
&& apt-get autoclean \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf ${BUILD_DIR}

WORKDIR ${SOFTETHER_INSTALL}
