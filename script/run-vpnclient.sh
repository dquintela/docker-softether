#!/usr/bin/env bash
set -e
. ./version.sh

DAEMON=$SOFTETHER_BIN/vpnclient

# Start daemon
exec ./run-daemon.sh $DAEMON || exit $?


