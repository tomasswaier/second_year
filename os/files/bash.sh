#!/bin/bash
# we load every file in public
for file in $(find /public -type f); 
do	
	#file##*/ is a regex that removes everything before last / character 
	printf "\nFile ${file##*/}\n"	
	# wc -l retunr num of lines 
	printf "Lines $(wc -l < "$file")\n"
	# wc -w retunr num of words
	printf "Words $(wc -w < "$file")\n"
	# {content = content $0} puts everything into single variable ,gsub returns count of all lines (since now it's in one variable it returns one number ) 
	printf "Special $(awk '{content = content $0} END {print gsub(/[!@#$%^&*(),.{}<>?/\\:;"'\''\-]/,"", content)}' "$file")\n"

# 1> pipes output into specified file and 2> pipes errors into another one
done 1> result.txt 2> errors.log

