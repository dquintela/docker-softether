#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal! Stopping $SOFTETHER_BIN/vpnbridge" 
  $SOFTETHER_BIN/vpnbridge stop
}

trap _term SIGTERM

echo "Starting $SOFTETHER_BIN/vpnbridge...";
$SOFTETHER_BIN/vpnbridge start

echo "Waiting for $SOFTETHER_BIN/vpnbridge to end...";
# Find PIDs of vpnbridge
while [[ $(ps -e | awk '$4=="vpnbridge"') ]]; do sleep 1; done


