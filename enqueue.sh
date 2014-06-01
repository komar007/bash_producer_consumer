#!/bin/bash

SCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $SCDIR/common.sh

what="$2"

while true; do
	inotifywait -e delete_self "$lock" > /dev/null 2>&1
	if lock; then
		echo "$what" >> "$queue"
		unlock
		exit
	fi
done
