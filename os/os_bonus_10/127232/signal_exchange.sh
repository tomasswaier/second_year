#!/bin/bash

USER_MESSAGE=$1

function handle_signal1() {
    echo "script1 received SIGUSR1"
    kill -USR2 $CHILD_PID
}

function handle_signal2() {
    echo "script1 received SIGUSR2"
    echo "script1 says: '$USER_MESSAGE'"
}


# traps
trap 'handle_signal1' USR1
trap 'handle_signal2' USR2

#start the child process
echo "script1: Starting child process..."
./second_script.sh "$USER_MESSAGE" &
CHILD_PID=$!

echo "script1: Child process started with PID $CHILD_PID."

# Loop to wait for signals
while :; do
    wait
done

