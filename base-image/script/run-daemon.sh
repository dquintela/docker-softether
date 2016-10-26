#!/usr/bin/env bash
set -e

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "error executing $*"; }

DAEMON=$1

[ -n "$DAEMON" ] || die "Daemon name not given"
[ -x "$DAEMON" ] || die "Daemon $DAEMON is not a valid executable"

stopdaemon() {
  echo "Stopping $DAEMON ..."
  $DAEMON stop || exit $? 

  # Wait for processes of daemon to end
  # If we don't stop on time, docker with timeout on 10 secs (?) 
  # and send KILL
  echo "Waiting $DAEMON to end ..."
  while [[ $(ps -e | awk '$4=="$DAEMON"') ]]; do sleep 1; done
  echo "Stopped $DAEMON ..."
}

_trap() {
  echo -e "\nCaught signal!"
  stopdaemon
  exit 0
}

# Register trap to stopdaemon on signal / docker stop
trap _trap HUP INT QUIT TERM

# start service in background here
echo "Starting $DAEMON ..."
try $DAEMON start

echo "[hit enter key to exit] or run 'docker stop <container>'"
read

# stop service and clean up here
stopdaemon
exit 0
