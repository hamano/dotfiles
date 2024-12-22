#!/bin/bash

wget -r -m -E -k -p -np -e robots=off --wait 0.1 --quiet --show-progress $1

