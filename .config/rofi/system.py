#!/usr/bin/env python
# -*- coding: utf-8 -*-

from collections import OrderedDict
import os
import sys
import subprocess

def main():
    menu = OrderedDict([
        ('Lock', 'dm-tool lock'),
#        ('i3lock', 'i3lock -c "#282828"'),
        ('Logout', 'dm-tool switch-to-greeter'),
        ('Reboot', 'systemctl reboot'),
        ('Poweroff', 'systemctl poweroff'),
        ('Screen Capure', "scrot -d 1 -e 'mv $f ~/Pictures/'"),
        ('screen capure(focused)', "scrot -u -d 1 -e 'mv $f ~/Pictures/'"),
        ('screen capure(select)', "scrot -s -e 'mv $f ~/Pictures/'"),
    ])
    if len(sys.argv) > 1:
        subprocess.Popen(menu[sys.argv[1]], shell=True, stdout=subprocess.PIPE)
    else:
        for k in menu:
            print(k)

if __name__ == '__main__':
    main()
