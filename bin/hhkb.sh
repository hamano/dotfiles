#!/bin/bash
DISPLAY=":0.0"
XAUTHORITY=$HOME/.Xauthority
export DISPLAY XAUTHORITY HOME

LINE=$(xinput -list | grep "HHKB Professional")
if [[ ! -z "$LINE" ]]; then
  echo "found hhkb"
  ID=`echo $LINE | perl -pe 's/.*id=([\d]*).*/\1/'`
  setxkbmap -device $ID -layout us
  xmodmap $HOME/etc/.Xmodmap.hhkb
fi

