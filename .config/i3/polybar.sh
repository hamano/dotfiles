#!/bin/bash

if [[ -z $1 ]]; then
    echo 'usage: polybar.sh <command>'
    exit 1
fi

function set_env() {
    # for Intel
    if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
        export TEMP_HWMON_PATH=/sys/class/thermal/thermal_zone0/temp
    fi
    # for AMD
    if [[ -f /sys/class/hwmon/hwmon4/temp1_input ]]; then
        export TEMP_HWMON_PATH=/sys/class/hwmon/hwmon4/temp1_input
    fi
    # for GPD
    if [[ -f /sys/devices/virtual/thermal/thermal_zone6/temp ]]; then
        export TEMP_HWMON_PATH=/sys/devices/virtual/thermal/thermal_zone6/temp
    fi
    HOST=$(hostname)
    if [[ $HOST == "x1c" ]]; then
        export POLYBAR_ETH_INTERFACE=enp0s31f6
        export POLYBAR_WLAN_INTERFACE=wlp2s0
    fi
    if [[ $HOST == "t14" ]]; then
        export POLYBAR_ETH_INTERFACE=enp6s0
        export POLYBAR_WLAN_INTERFACE=wlp3s0
    fi
}

function start() {
    set_env
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

