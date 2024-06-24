#!/bin/bash

if [[ -z $1 ]]; then
    echo 'usage: polybar.sh <command>'
    exit 1
fi

function set_env() {
    case $(hostname) in
        'x1c')
            export POLYBAR_ETH_INTERFACE=enp0s31f6
            export POLYBAR_WLAN_INTERFACE=wlp2s0
            export POLYBAR_TEMP_PATH=/sys/class/thermal/thermal_zone0/temp
            ;;
        't14')
            export POLYBAR_ETH_INTERFACE=enp2s0f0
            export POLYBAR_WLAN_INTERFACE=wlp3s0
            export POLYBAR_TEMP_PATH=$(ls /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon*/temp1_input|head -1)
            # or /sys/class/hwmon/hwmon4/temp1_input
            ;;
        'gpd')
            #export POLYBAR_ETH_INTERFACE=enp6s0
            #export POLYBAR_WLAN_INTERFACE=wlp3s0
            export POLYBAR_TEMP_PATH=/sys/class/hwmon/hwmon3/temp1_input
            ;;
    esac
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
    "env") set_env && env | grep POLYBAR_;;
esac

