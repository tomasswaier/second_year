#!/bin/bash
declare -A login_counts
last -f wtmp.2020 | while IFS= read -r line; do
    name=$(echo "$line" | awk '{print $1}')
    session_start=$(echo "$line" | awk '{print $7}')
    session_start_hour=${session_start%:*}
    session_end=$(echo "$line" | awk '{print $9}')
    session_end_hour=${session_end%:*}
    
    if { [ "$session_start_hour" -ge 22 ] || [ "$session_start_hour" -lt 5 ]; } && \
       { [ "$session_end_hour" -gt 22 ] || [ "$session_end_hour" -lt 5 ]; }; then
        ((login_counts["$name"]++))
        echo "$name ,$session_start, $session_end"
    fi 2> /dev/null
done

N=10

for user in "${!login_counts[@]}"; do
    echo "$user"
done | sort -nr 

