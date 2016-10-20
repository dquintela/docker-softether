#!/bin/bash

case "$1" in
	vpnclient)
		exec run-vpnclient.sh
		;;
	vpnbridge)
		exec run-vpnbridge.sh
		;;
	vpnserver)
		exec run-vpnserver.sh
		;;
	--help)
	*)
		echo "Usage: run.sh {vpnclient|vpnbridge|vpnserver}"
		exit 1
		;;
esac