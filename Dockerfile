#
# Softether VPN Server / Client / Bridge Built from sources
#
FROM i386/ubuntu:16.04
MAINTAINER Diogo Quintela <dquintela@gmail.com>

# ENV like, but does not persist on final image
# Can be replaced by --build-arg on docker-build
ARG BUILD_DIR=/tmp/SoftEtherVPN
ARG SOFTETHER_IMAGE_VERSION
ARG SOFTETHER_CPU=32bit
ARG DEBIAN_FRONTEND=noninteractive

# Persist on final image
ENV SOFTETHER_BIN="/usr/local/bin" \
	SOFTETHER_INSTALL="/usr/local/softether" \
	SOFTETHER_IMAGE_VERSION="${SOFTETHER_IMAGE_VERSION:-v0.0.0}"

COPY script /docker-softether/

# ethtool,iptables are used by vpnserver 
# Don't install iptables, need a privileged containers (let softether detect as not found) ??
# Check if --cap-add NET_ADMIN is enough
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

# https://docs.docker.com/engine/reference/builder/#label#stopsignal
# STOPSIGNAL signal
# https://docs.docker.com/engine/reference/builder/#/healthcheck
# HEALTHCHECK
VOLUME /var/log/softether

# 443 for OpenVPN over TLS
# 500 4500 for L2TP/IPSec
# 1701 for L2TP tunnel
# 4500 for NAT traversal
# 5555 for SoftEtherVPN
EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp

# WORKDIR ${SOFTETHER_INSTALL}
WORKDIR /docker-softether

ENTRYPOINT ["/docker-softether/run.sh"]
CMD ["--help"]
