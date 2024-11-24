#! /bin/bash
#
# Meno: <meno>
# Kruzok: <kruzok>
# Datum: <datum>
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
