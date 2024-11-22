#!/bin/bash
echo
echo "PID vyberaca je $$"

./losovac.sh &
tmp=$!
echo "PID losovaca je $tmp"

trap 'kill -9 $tmp' SIGINT

while :
do
    #skuste zakomentovat nasledujuci sleep a zistite ci program bude losovat rychlejsie
    sleep 5
    echo
    echo "Volam losovaca..."
    kill -USR1 $tmp
    sleep 5
done
