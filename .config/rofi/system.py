#!/usr/bin/env python
# -*- coding: utf-8 -*-

from collections import OrderedDict
import os
import sys

def main():
    menu = OrderedDict([
#        ('Lock', 'dm-tool lock'),
        ('Lock', 'dm-tool switch-to-greeter'),
        ('Logout', 'dm-tool switch-to-greeter'),
        ('Reboot', 'systemctl reboot'),
        ('Poweroff', 'systemctl poweroff'),
    ])
    if len(sys.argv) > 1:
        os.system(menu[sys.argv[1]])
    else:
        for k in menu:
            print(k)

if __name__ == '__main__':
    main()
