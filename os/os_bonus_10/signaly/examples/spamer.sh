#!/bin/bash

trap "rm /tmp/spamer; exit 0" INT

if [ -e /tmp/spamer ];
then
	echo "Spamer uz bezi"
	exit 0
fi

echo $$> /tmp/spamer

while :
do
	sleep 2
	wall "Ja len spamujem"
done
