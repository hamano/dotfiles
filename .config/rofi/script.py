#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from collections import OrderedDict
import os
import sys
import subprocess

def main():
    menu = OrderedDict([
        ('System Lock', 'dm-tool lock'),
        ('System Logout', 'dm-tool switch-to-greeter'),
        ('System Reboot', 'systemctl reboot'),
        ('System Poweroff', 'systemctl poweroff'),
        ('Scrot focused', "scrot -u -d 1 -e 'mv $f ~/Pictures/'"),
        ('Scrot select', "scrot -s -e 'mv $f ~/Pictures/'"),
        ('Scrot full', "scrot -d 1 -e 'mv $f ~/Pictures/'"),
    ])
    if len(sys.argv) > 1:
        subprocess.Popen(menu[sys.argv[1]], shell=True, stdout=subprocess.PIPE)
    else:
        for k in menu:
            print(k)

if __name__ == '__main__':
    main()
