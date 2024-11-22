#!/bin/bash

USER_MESSAGE=$1

function handle_signal1() {
    echo "script2 received SIGUSR1."
    kill -USR2 $PARENT_PID
}

function handle_signal2() {
    echo "script2 received SIGUSR2"
    echo "script2 says '$USER_MESSAGE'"
}


# Setup traps 
trap 'handle_signal1' USR1
trap 'handle_signal2' USR2

# id of parent / the script that called it
PARENT_PID=$PPID

echo "script2 running with PID $$, parent PID is $PARENT_PID."

#send and receive 
for i in {1..5}; do
    echo "script2 sending SIGUSR1 to parent (attempt $i)..."
    kill -USR1 $PARENT_PID
    sleep 1
done
