FROM i386/ubuntu:16.04
MAINTAINER Diogo Quintela <dquintela@gmail.com>

# Persist on final image
ENV SOFTETHER_BIN /usr/local/bin
ENV SOFTETHER_INSTALL /usr/local/softether

# ENV like, but does not persist on final image
ARG BUILD_DIR=/tmp/SoftEtherVPN
ARG SOFTETHER_CPU=32bit
ARG DEBIAN_FRONTEND=noninteractive

COPY script /docker-softether/

# ethtool,iptables are used by vpnserver 
# https://github.com/SoftEtherVPN/SoftEtherVPN/search?utf8=%E2%9C%93&q=UnixExec&type=Code
# https://github.com/SoftEtherVPN/SoftEtherVPN/search?utf8=%E2%9C%93&q=UnixExecSilent&type=Code
# ca-certificates is because we are using --no-install-recommends
RUN set -xe \
&& apt-get update \
&& apt-get install -q -y --no-install-recommends ca-certificates libreadline6 libssl1.0.0 libncurses5 ethtool iptables \
&& apt-get install -q -y --no-install-recommends build-essential git libreadline6-dev libssl-dev libncurses5-dev \
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
&& apt-get remove -y --auto-remove --purge build-essential git libreadline6-dev libssl-dev libncurses5-dev \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf ${BUILD_DIR} \
&& chmod +x /docker-softether/*.sh

# https://docs.docker.com/engine/reference/builder/#/healthcheck
# HEALTHCHECK
VOLUME /var/log/softether
EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp
WORKDIR ${SOFTETHER_INSTALL}
ENTRYPOINT /docker-softether/run.sh
CMD "--help"

