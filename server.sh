#!/bin/bash

SCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $SCDIR/common.sh

nconsumers=$2
worker=$3

rm -f "$lock"
echo -n > "$queue"

pids=
for i in `seq 1 1 $nconsumers`; do
	"$SCDIR/consumer.sh" $queue $i $worker &
	pids="$pids $!"
done

function finish()
{
	for pid in $pids; do
		kill -HUP $pid
	done
	echo
	echo -n waiting for consumers to finish
	while [ -n "$(ps -hp $pids)" ]; do
		sleep 1 && echo -n .
	done
	echo
	exit
}

trap finish INT

while true; do
	cat > /dev/null
done
