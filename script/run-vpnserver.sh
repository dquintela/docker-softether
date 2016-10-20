#!/usr/bin/env bash
set -e

warn() { "$@" || echo "WARNING: Error executing $*"; }

DAEMON=$SOFTETHER_BIN/vpnserver
VAR_LOG=/var/log/softether
SOFTETHER_LOG=$SOFTETHER_INSTALL/vpnserver

# Prepare log directories
[ -d $VAR_LOG/vpnserver-security_log ] || warn mkdir -p $VAR_LOG/vpnserver-security_log
[ -d $VAR_LOG/vpnserver-packet_log   ] || warn mkdir -p $VAR_LOG/vpnserver-packet_log
[ -d $VAR_LOG/vpnserver-server_log   ] || warn mkdir -p $VAR_LOG/vpnserver-server_log

# Make links on vpnserver's expected directories
[ -d $VAR_LOG/vpnserver-security_log ] && warn ln -s $VAR_LOG/vpnserver-security_log $SOFTETHER_LOG/security_log
[ -d $VAR_LOG/vpnserver-packet_log ] && warn ln -s $VAR_LOG/vpnserver-packet_log $SOFTETHER_LOG/packet_log
[ -d $VAR_LOG/vpnserver-server_log ] && warn ln -s $VAR_LOG/vpnserver-server_log $SOFTETHER_LOG/server_log

# Handle default configuration ?!?!


# Start daemon
exec ./run-daemon.sh $DAEMON || exit $?


