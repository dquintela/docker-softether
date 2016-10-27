#!/usr/bin/env bash
#
# Usage: ./check-upstream-repo.sh git@github.com:dquintela/docker-softether.git
#     But this fails short, I should only TRACKER file
#     after notification is pushed to TracisCI or CircleCI
#
set -e

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "error executing $*"; }

[ ! -z "$1" ] || die "A GIT url must be provided"

TRACKER=remote-head-$(basename $1)
PREVIOUS=""
if [ -f "$TRACKER" ] ; then
	PREVIOUS=$(<$TRACKER)
fi
CURRENT=$(git ls-remote -h $1 master | cut -f 1)

echo TRACKER = $TRACKER
echo PREVIOUS= $PREVIOUS
echo $PREVIOUS | od -tx1
echo CURRENT = $CURRENT
echo $CURRENT | od -tx1

if [ "$PREVIOUS" = "$CURRENT" ] ; then
	echo "SAME"
else
	echo "DIFFER"
	echo $CURRENT > $STATUS_FILE
fi
