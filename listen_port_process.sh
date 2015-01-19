#!/bin/sh
printf "USER\t\tPID\tPPID\tVSIZE\tRSS\tWCHAN\tPC\tNAME\n"
for i in `adb shell netstat | grep LISTEN | awk '{print $4}' | grep --color=none -o '[0-9]:.*' | sed $'s/\r//'`; do
	PORT="${i:2}"
	printf "[%s]%*s\n\n" $PORT "${COLUMNS:-$(($(tput cols)-${#PORT}-2))}" '' | tr ' ' '-'
	./port2process.sh -v "${PORT}"
	echo
done
printf "%*s\n" "${COLUMNS:-$(tput cols)}" '' | tr ' ' '-'
