#!/bin/sh
[ "$1" = "-v" ] && FLAG="-v"
printf "USER      PID   PPID  VSIZE  RSS     WCHAN    PC         NAME\n"
for i in `adb shell netstat | grep LISTEN | awk '{print $4}' | grep --color=none -Eo '([0-9]|:):.*' | sed $'s/\r//'`; do
	PORT="${i##*:}"
	printf "[%s]%*s\n\n" $PORT "${COLUMNS:-$(($(tput cols)-${#PORT}-2))}" '' | tr ' ' '-'
	[ -z "$FLAG" ] && ./port2process.sh "${PORT}" || ./port2process.sh "$FLAG" "${PORT}"
	echo
done
printf "%*s\n" "${COLUMNS:-$(tput cols)}" '' | tr ' ' '-'
