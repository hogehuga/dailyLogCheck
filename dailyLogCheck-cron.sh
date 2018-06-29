#!/bin/sh

# git clon path
GITDIR="/opt/dailyHttpdLogCheck"

$GITDIR/dailyHttpdLogcheck.sh | $GITDIR/pushSlack.sh
