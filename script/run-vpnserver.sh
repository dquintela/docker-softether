#!/bin/bash

# Prepare log directories
[ -d /var/log/softether/vpnserver-security_log ] || mkdir -p /var/log/softether/vpnserver-security_log
[ -d /var/log/softether/vpnserver-packet_log ] || mkdir -p /var/log/softether/vpnserver-packet_log
[ -d /var/log/softether/vpnserver-server_log ] || mkdir -p /var/log/softether/vpnserver-server_log

# Make links on vpnserver's expected directories
ln -s /var/log/softether/vpnserver-security_log ${SOFTETHER_INSTALL}/vpnserver/security_log
ln -s /var/log/softether/vpnserver-packet_log ${SOFTETHER_INSTALL}/vpnserver/packet_log
ln -s /var/log/softether/vpnserver-packet_log ${SOFTETHER_INSTALL}/vpnserver/packet_log

# Handle default configuration ?!?!

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


