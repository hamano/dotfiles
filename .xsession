#!/bin/sh

#export LANG="C"
export LANG="ja_JP.UTF-8"

# for xdg-settings
#export DE=xfce

# for acroread
export ACRO_DISABLE_FONT_CONFIG=1

setxkbmap jp
#setxkbmap -option terminate:ctrl_alt_bksp
xmodmap ~/.Xmodmap

exec awesome
#exec /usr/bin/startfluxbox
