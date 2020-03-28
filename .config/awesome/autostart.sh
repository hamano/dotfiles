#!/bin/bash

if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then
    exit;
fi;

DEX="$(dirname $0)/dex"
SEARCHPATHS=$HOME/.config/autostart
echo autostart $SEARCHPATHS
xrdb -merge <<< "awesome.started:true";

{
    ${DEX} -v /etc/xdg/autostart/light-locker.desktop
    ${DEX} -v /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop
    ${DEX} -v --environment Awesome --autostart -s "$SEARCHPATHS"
} | tee ~/.autostart.log

