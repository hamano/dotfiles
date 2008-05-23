#!/bin/sh

#export XMODIFIERS="@im=htt"
#export LANG="ja_JP.eucJP"
#export LANG="C"
#export LANG="ja_JP"
export LANG="ja_JP.UTF-8"

if [ -x /opt/atokx2/bin/atokx2_client.sh ]; then
    . /opt/atokx2/bin/atokx2_client.sh
fi

sleep 2 && wmclock -exe 'LANG=C cal -3 | xmessage -file -' &
sleep 2 && wmwifi -s &
#sleep 1 && bbdock "/usr/share/xscreensaver/glade/screensaver-locking.png:xlock -mode blank:xlock" &
#sleep 1 && bbpager &

#torsmo -a top_right -x 80 &
/usr/bin/conky &
urxvtd &

exec fluxbox
