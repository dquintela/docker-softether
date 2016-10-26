#!/usr/bin/env bash
set -e
. ./version.sh

DAEMON=$SOFTETHER_BIN/vpnbridge

# Start daemon
exec ./run-daemon.sh $DAEMON || exit $?

