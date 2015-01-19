#!/bin/sh
for i in `adb shell netstat | grep LISTEN | awk '{print $4}' | grep --color=none -o '[0-9]:.*' | sed $'s/\r//'`; do
	./port2process.sh "${i:2}"
done
