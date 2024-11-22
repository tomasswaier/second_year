#!/bin/bash

echo "Losovac caka na vyzvu k losovaniu."

function losuj()
{
    echo -n $(($RANDOM%10+1))
}

trap 'losuj' USR1

while :
do
    sleep infinity &
    wait
    #skuste zakomentovat nasledujuce dva riadky a sledujte ps aux pri posielani signalu USR1
    kill -9 $!
    wait $! 2> /dev/null
    echo " je vylosovane cislo"
done
