#!/bin/sh
usage() { echo "Usage: ${FUNCNAME[1]} $1" && return 0; }
[[ $# -ne 1 ]] && usage "<port>" && exit 1
PORT=$1
echo "$PORT"
PORT16="$(echo "obase=16; $PORT" | bc)"
echo "$PORT16"
PROTOCOL="$(adb shell 'netstat | grep '"$PORT"' | busybox awk '"'"'{print $1}'"'" | sed $'s/\r//')"
echo "PROTOCOL: ${#PROTOCOL}"
INODE="$(adb shell 'cat /proc/net/'"$PROTOCOL"' | grep '"$PORT16"' | busybox awk '"'"'{print $10}'"'" | sed $'s/\r//')"
echo "INODE: $INODE"
PROCESS="$(adb shell 'for i in /proc/*/fd; do ls -l "$i" | grep '"$INODE"' &>/dev/null && echo "$i"; done' | sed $'s/\r//')"
PROCESS="${PROCESS#/proc/}"
PROCESS="${PROCESS%/fd}"
echo "PROCESS: $PROCESS"
adb shell 'ps | grep '"$PROCESS"
