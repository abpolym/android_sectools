#!/bin/sh
usage() { echo "Usage: ${FUNCNAME[1]} $1" && return 0; }
[ $# -ne 1 ] && [[ $# -ne 2 ]] && usage "[-v] <port>" && exit 1
[ $# -eq 1 ] && PORT=$1 || PORT=$2
[ $# -eq 2 ] && echo "PORT: $PORT"
PORT16="$(echo "obase=16; $PORT" | bc)"
PORT16="$(printf "%04s" "$PORT16")"
[ $# -eq 2 ] && echo "hex(PORT): $PORT16"
PROTOCOL="$(adb shell 'netstat | grep "'":$PORT"' " | busybox awk '"'"'{print $1}'"'" | sed $'s/\r//g')"
[ -z "$PROTOCOL" ] && echo "No such open port" && exit 127
[ $# -eq 2 ] && echo "PROTOCOL: ${PROTOCOL}"
INODE="$(adb shell 'cat /proc/net/'"$PROTOCOL"' | grep '":$PORT16 "' | busybox awk '"'"'{print $10}'"'" | sed $'s/\r//g')"
[ $# -eq 2 ] && echo "INODE: $INODE"
PROCESS="$(adb shell 'for i in /proc/*/fd; do ls -l "$i" | grep '"$INODE"' &>/dev/null && echo "$i"; done' | sed $'s/\r//g')"
echo "$PROCESS" | while read p; do 
	p="${p#/proc/}"
	p="${p%/fd}"
	[ $# -eq 2 ] && echo "PROCESS: $p"
	adb shell 'ps | grep '"$p"
done
