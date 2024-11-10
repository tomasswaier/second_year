#!/bin/bash

declare -A login_data
N=-1
if [[ $1 == "-n" ]];then
	N="$2"
elif [[ $1 == "-h" ]];then
    	echo "zadanie.sh (C) Tomáš Meravý Murárik"
    	echo
    	echo "Usage: zadanie.sh [-h] [-n <pocet>]"
    	echo "   -h         : Displays this help message."
    	echo "   -n <pocet> : Display users who logged in at nighttime more than <pocet> times."
    	exit 0
fi


while IFS= read -r line; do
    name=$(echo "$line" | awk '{print $1}')
    session_start=$(echo "$line" | awk '{print $7}')
    session_start_hour=${session_start%:*}
    session_end=$(echo "$line" | awk '{print $9}')
    session_end_hour=${session_end%:*}
    login_date=$(echo "$line" | awk '{print $5 "-" $6}')

    if { [ "$session_start_hour" -ge 22 ] || [ "$session_start_hour" -lt 5 ]; } ; then
	#&& \{ [ "$session_end_hour" -gt 22 ] || [ "$session_end_hour" -lt 5 ]; }
        
        # Parse the current login data for the user
        current_data="${login_data["$name"]}"
        current_count=$(echo "$current_data" | cut -d',' -f1)
        last_login=$(echo "$current_data" | cut -d',' -f2)

        # Increment count or initialize if empty
	#echo "$line"
	#echo "$name $login_date $session_start $session_end"
        ((current_count++))
        login_data["$name"]="$current_count,$login_date $session_start"
    fi 2> /dev/null
done < <(last -f wtmp.2020)

# Sort users by nighttime login counts and get the top N
for user in "${!login_data[@]}"; do
    count=$(echo "${login_data["$user"]}" | cut -d',' -f1)
    last_login=$(echo "${login_data["$user"]}" | cut -d',' -f2)
    if [[ $count -gt $N ]];then
    	echo "Output: '$user $count $last_login"
    elif [[ $N == -1 ]];then
    	echo "Output: '$user $count $last_login"
    fi	
done 
