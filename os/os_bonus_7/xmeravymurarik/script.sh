#!/bin/bash

anonymize_ip() {
    	local ip="$1"
	# dividing the string by octets
    	IFS='.' read -r -a octet <<< "$ip"

	#forloop where we perform the untraceable operation (+1 would be fine too)
    	for i in {0..3}; do
        	octet[i]=$(( (octet[i] + 100) % 255 ))
    	done
	# return the new address in string format 
    	echo "${octet[0]}.${octet[1]}.${octet[2]}.${octet[3]}"
}

while IFS= read -r line; do
	# Extract the first field ( ip) 
    	ip=$(echo "$line" | awk '{print $1}') 
	#my function returnes new superuntraceable address

	#we call regex on line where we swap the ip with 
	#new address and append it to file
    	echo "${line/$ip/$(anonymize_ip "$ip")}" >> "anon.log"
done < "access.log"
