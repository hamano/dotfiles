#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import random
from datetime import timedelta
from datetime import date
from datetime import datetime
from datetime import time
from datetime import timedelta
from random import randrange

def main():
    if len(sys.argv) > 1:
        d = datetime.strptime(sys.argv[1], '%Y-%m-%d')
    else:
        d = date.today()

    delta = timedelta(seconds=randrange(24 * 60 * 60))
    today = datetime.combine(d, time(0))
    d = today + delta
    print(d)

if __name__ == '__main__':
    main()
