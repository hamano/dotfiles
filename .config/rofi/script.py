#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from collections import OrderedDict
import os
import sys
import subprocess

def main():
    menu = OrderedDict([
        ('System Lock', 'loginctl lock-session'),
        ('System Logout', 'loginctl terminate-session self'),
        ('System Reboot', 'systemctl reboot'),
        ('System Poweroff', 'systemctl poweroff'),
        ('Screenshot focused', "sleep 1; grim -g \"$(hyprctl activewindow -j | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"')\" ~/Pictures/$(date +%Y-%m-%d-%H%M%S).png"),
        ('Screenshot select', "sleep 0.2; grim -g \"$(slurp)\" ~/Pictures/$(date +%Y-%m-%d-%H%M%S).png"),
        ('Screenshot full', "sleep 1; grim ~/Pictures/$(date +%Y-%m-%d-%H%M%S).png"),
    ])
    if len(sys.argv) > 1:
        subprocess.Popen(menu[sys.argv[1]], shell=True, stdout=subprocess.PIPE)
    else:
        for k in menu:
            print(k)

if __name__ == '__main__':
    main()
