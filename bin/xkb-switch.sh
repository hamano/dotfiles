#!/bin/bash

LAYOUT=$(setxkbmap -query | awk '/^layout:/{print $2}')

case "$LAYOUT" in
    'us')
        setxkbmap -layout jp
        ;;
    'jp')
        setxkbmap -layout us
        ;;
esac

exit 0;
