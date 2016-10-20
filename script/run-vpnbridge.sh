#!/usr/bin/env bash
set -e

DAEMON=$SOFTETHER_BIN/vpnbridge

# Start daemon
exec ./run-daemon.sh $DAEMON || exit $?

