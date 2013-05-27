#!/bin/sh

#export LANG="C"
export LANG="ja_JP.UTF-8"

#setxkbmap -option terminate:ctrl_alt_bksp
xmodmap ~/.Xmodmap

exec /usr/bin/startfluxbox
