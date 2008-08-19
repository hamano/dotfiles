#!/bin/sh

#export LANG="C"
#export LANG="ja_JP.eucJP"
export LANG="ja_JP.UTF-8"

xmodmap ~/.Xmodmap

# atok age
#if [ -x /opt/atokx2/bin/atokx2_client.sh ]; then
#    . /opt/atokx2/bin/atokx2_client.sh
#fi

export XMODIFIERS=@im=uim
export GTK_IM_MODULE=uim
uim-xim &
#uim-toolbar-gtk &
#uim-toolbar-gtk-systray &

sleep 2 && wmclock -exe 'LANG=C cal -3 | xmessage -file -' &
sleep 2 && wmuim &
sleep 2 && wmacpi &
sleep 2 && wmwifi -s &

notification-daemon &

#sleep 1 && bbdock "/usr/share/xscreensaver/glade/screensaver-locking.png:xlock -mode blank:xlock" &
#sleep 1 && bbpager &

/usr/bin/conky &
urxvtd &

exec fluxbox
