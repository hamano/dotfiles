#!/bin/bash

if [[ -z $1 ]]; then
    echo 'usage: polybar.sh <command>'
    exit 1
fi


function detect_temp() {
    # for Intel
    if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
        echo "/sys/class/thermal/thermal_zone0/temp"
    fi
    # for AMD
    if [[ -f /sys/class/hwmon/hwmon4/temp1_input ]]; then
        echo "/sys/class/hwmon/hwmon4/temp1_input"
    fi
    # for GPD
    if [[ -f /sys/devices/virtual/thermal/thermal_zone6/temp ]]; then
        echo "/sys/devices/virtual/thermal/thermal_zone6/temp"
    fi
}

function start() {
    export TEMP_HWMON_PATH=$(detect_temp)
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

