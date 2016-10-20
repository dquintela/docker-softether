#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal! Stopping $SOFTETHER_BIN/vpnclient" 
  $SOFTETHER_BIN/vpnclient stop
}

trap _term SIGTERM

echo "Starting $SOFTETHER_BIN/vpnclient...";
$SOFTETHER_BIN/vpnclient start

echo "Waiting for $SOFTETHER_BIN/vpnclient to end...";
# Find PIDs of vpnclient
while [[ $(ps -e | awk '$4=="vpnclient"') ]]; do sleep 1; done


