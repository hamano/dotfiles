#!/usr/bin/env python
# -*- coding: utf-8 -*-

from collections import OrderedDict
import os
import sys
import subprocess

def main():
    menu = OrderedDict([
        ('Lock', 'dm-tool lock'), # dm-tool lock does not work with lightdm-gtk-greeter
#        ('Lock', 'dm-tool switch-to-greeter'), # if you use lightdm-gtk-greeter
#        ('i3lock', 'i3lock -c "#282828"'),
        ('Logout', 'dm-tool switch-to-greeter'),
        ('Reboot', 'systemctl reboot'),
        ('Poweroff', 'systemctl poweroff'),
    ])
    if len(sys.argv) > 1:
        subprocess.call(menu[sys.argv[1]], shell=True)
    else:
        for k in menu:
            print(k)

if __name__ == '__main__':
    main()
