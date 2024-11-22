#!/bin/bash
echo "Moje PID je $$"

trap 'echo "Ja nekoncim!"' SIGINT

echo "Uspat ma stale mozes pomocou CTRL+Z"
while :
do
echo zijem
sleep 3
done
