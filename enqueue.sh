#!/bin/bash

SCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $SCDIR/common.sh

while true; do
	inotifywait -e delete_self "$lock" > /dev/null 2>&1
	if lock; then
		if [ "$2" == "--" ]; then
			shift 2
			echo "$*" >> "$queue"
		else
			shift 1
			job=
			for i in `seq 1 1 $#`; do
				echo -n "${!i}" | sed "s/\([\"' ]\)/\\\\\1/g" | tr '\n' ' ' >> "$queue"
				echo -n " " >> "$queue"
			done
			echo >> "$queue"
		fi
		unlock
		exit
	fi
done
