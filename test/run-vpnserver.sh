#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal! Stopping $SOFTETHER_BIN/vpnserver" 
  $SOFTETHER_BIN/vpnserver stop
}

trap _term SIGTERM

echo "Starting $SOFTETHER_BIN/vpnserver...";
$SOFTETHER_BIN/vpnserver start

echo "Waiting for $SOFTETHER_BIN/vpnserver to end...";
# Find PIDs of vpnserver
while [[ $(ps -e | awk '$4=="vpnserver"') ]]; do sleep 1; done


