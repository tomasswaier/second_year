#!/bin/bash

echo "Losovac caka na vyzvu k losovaniu."

function losuj()
{
    echo -n $(($RANDOM%10+1))
}

pid=
trap 'losuj' USR1
trap '[[ $pid ]] && kill "$pid"' EXIT

while :
do
    sleep infinity &
    pid=$!
    wait $pid
    #skuste zakomentovat nasledujuce dva riadky a sledujte ps aux pri posielani signalu USR1
    kill -9 $!
    wait $! 2> /dev/null
    echo " je vylosovane cislo"
    pid=
done
