#!/usr/bin/env bash
set -e

# Display processes
# ps -xfa
# echo "0 is $0"
# echo "1 is $1"
# echo "* is $*"
# echo "@ is $@"

case "$1" in
	vpnclient)
		exec ./run-vpnclient.sh || exit $?
		;;

	vpnbridge)
		exec ./run-vpnbridge.sh || exit $?
		;;

	vpnserver)
		exec ./run-vpnserver.sh || exit $?
		;;

	*)
		. ./version.sh
		# echo "Usage: $0 {vpnclient|vpnbridge|vpnserver}"
        echo "Usage example: docker run -d -it -<image> {vpnclient|vpnbridge|vpnserver}"
        # Doesnt accept arguments; echo "Usage example: docker start <container> {vpnclient|vpnbridge|vpnserver}"
		exit 1
        ;;
esac

