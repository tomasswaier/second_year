#!/bin/bash

echo "Losovac caka na vyzvu k losovaniu."

function losuj()
{
    echo -n $(($RANDOM%10+1))
}

trap 'losuj' USR1

./y.sh &
wait


echo nieco
