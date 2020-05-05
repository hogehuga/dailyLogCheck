#!/bin/sh

# git clon path
GITDIR="/opt/dailyLogCheck"

$GITDIR/dailyLogCheck.sh | $GITDIR/pushSlack.sh
