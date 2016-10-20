#!/usr/bin/env bash
# set -x

case "$1" in
	vpnclient)
		exec ./run-vpnclient.sh
        exit $?
		;;
	vpnbridge)
		exec ./run-vpnbridge.sh
        exit $?
		;;
	vpnserver)
		exec ./run-vpnserver.sh
        exit $?
		;;
	*)
		echo "Usage: $0 {vpnclient|vpnbridge|vpnserver}"
		exit 1
		;;
esac
