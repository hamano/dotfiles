#!/bin/bash
# virsh consoleの画面サイズを調整する
# /etc/profile.d に置くと便利
# wget -q -O /etc/profile.d/resize-serial-console.sh https://raw.githubusercontent.com/hamano/dotfiles/master/bin/resize-serial-console.sh
# https://blog.n-z.jp/blog/2022-01-30-serial-console-resize.html
# https://wiki.archlinux.org/title/working_with_the_serial_console#Resizing_a_terminal

rsz () if [[ -t 0 ]]; then local escape r c prompt=$(printf '\e7\e[r\e[999;999H\e[6n\e8'); IFS='[;' read -sd R -p "$prompt" escape r c; stty cols $c rows $r; fi
rsz
