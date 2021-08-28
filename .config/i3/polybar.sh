#!/bin/bash

if [[ -z $1 ]]; then
    echo 'usage: polybar.sh <command>'
    exit 1
fi

function start() {
    for d in $(polybar -m | cut -d: -f1); do
        MONITOR=$d polybar -r -c ~/.config/i3/polybar.conf top &
    done
}

function stop() {
	pkill polybar
}

case $1 in
    "start") start;;
    "stop") stop;;
esac
