#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import random
import subprocess
from datetime import timedelta
from datetime import date
from datetime import datetime
from datetime import time
from datetime import timedelta
from random import randrange

def main():
#   d = date.today()
    if len(sys.argv) > 1:
        d = datetime.strptime(sys.argv[1], '%Y-%m-%d')
    else:
        output = subprocess.check_output(["git log -1 --oneline --pretty=format:'%as'"], shell=True)
        d = datetime.strptime(output.decode(), '%Y-%m-%d')
        d = d + timedelta(days=1)

    delta = timedelta(seconds=randrange(24 * 60 * 60))
    today = datetime.combine(d, time(0))
    d = today + delta
    print(d)

if __name__ == '__main__':
    main()
