#! /bin/bash
#
# Meno: Tomáš Meravý Murárik
# Kruzok: Ing .Abd Alrahman Saleh 1.29 
# Datum: štvrtok 14:00
# Zadanie: zadanie06
#
# Text zadania:
#
# Zistite, ktori pouzivatelia sa prihlasuju na server OS v noci (teda cas prihlasenia
# je od 22:00 do 05:00). Do uvahy berte len ukoncene spojenia za poslednu dobu
# (odkedy system zaznamenava tieto informacie).
# Ak bude skript spusteny s prepinacom -n <pocet>, zistite, ktori pouzivatelia
# sa prihlasili v noci viac ako <pocet> krat.
# Dodrzte format vystupu uvedeny v priklade.
# Pomocka: pouzite prikaz last a udaje zo suboru /public/samples/wtmp.2020
#
# Syntax:
# zadanie.sh [-h] [-n <pocet>]
#
# Format vypisu bude nasledovny:
# Output: '<meno pouzivatela> <pocet nocnych prihlaseni> <datum a cas posledneho nocneho prihlasenia>'
#
# Priklad vystupu:
# Output: 'sedlacek 5 03-23 23:12'
# Output: 'tubel 2 03-23 22:55'
# Output: 'kubikm 4 03-23 02:31'
#
#
# Program musi osetrovat pocet a spravnost argumentov. Program musi mat help,
# ktory sa vypise pri zadani argumentu -h a ma tvar:
# Meno programu (C) meno autora
#
# Usage: <meno_programu> <arg1> <arg2> ...
#    <arg1>: xxxxxx
#    <arg2>: yyyyy
#
# Parametre uvedene v <> treba nahradit skutocnymi hodnotami.
# Ked ma skript prehladavat adresare, tak vzdy treba prehladat vsetky zadane
# adresare a vsetky ich podadresare do hlbky.
# Pri hladani maxim alebo minim treba vzdy najst maximum (minimum) vo vsetkych
# zadanych adresaroch (suboroch) spolu. Ked viacero suborov (adresarov, ...)
# splna maximum (minimum), treba vypisat vsetky.
#
# Korektny vystup programu musi ist na standardny vystup (stdout).
# Chybovy vystup programu by mal ist na chybovy vystup (stderr).
# Chybovy vystup musi mat tvar (vratane apostrofov):
# Error: 'adresar, subor, ... pri ktorom nastala chyba': popis chyby ...
# Ak program pouziva nejake pomocne vypisy, musia mat tvar:
# Debug: vypis ...
#
# Poznamky: (sem vlozte pripadne poznamky k vypracovanemu zadaniu)
#
# Riesenie:

declare -A login_data
N=-1
if [[ $1 == "-n" && $2 =~ ^[0-9]+$ ]];then
	N="$2"
elif [[ $1 == "-h" || ( $1 == "-n" && ! $2 =~ ^[0-9]+$ ) ]]; then
    	echo "zadanie.sh (C) Tomáš Meravý Murárik"
    	echo
    	echo "Usage: zadanie.sh [-h] [-n <pocet>]"
    	echo "   -h         : Displays this help message."
    	echo "   -n <pocet> : Display users who logged in at nighttime more than <pocet> times."
    	exit 0
elif [[ -n $1 ]]; then
	echo "Error: Invalid arguments. Use -h for help." >&2
	exit 1
fi


while IFS= read -r line; do
    name=$(echo "$line" | awk '{print $1}')
    session_start=$(echo "$line" | awk '{print $7}')
    session_start_hour=${session_start%:*}
    #session_end=$(echo "$line" | awk '{print $9}')
    #session_end_hour=${session_end%:*}
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

for user in "${!login_data[@]}"; do
    count=$(echo "${login_data["$user"]}" | cut -d',' -f1)
    last_login=$(echo "${login_data["$user"]}" | cut -d',' -f2)
    if [[ $count -gt $N ]];then
    	echo "Output: '$user $count $last_login'"
    #elif [[ $N == -1 ]];then
    #	echo "Output: '$user $count $last_login'"
    fi	
done 
