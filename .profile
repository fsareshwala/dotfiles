#!/bin/bash
export TERMINAL=/usr/bin/rxvt-unicode
export PATH=/home/fsareshwala/prefix/bin:$PATH
export TZ=America/Los_Angeles

xset r rate 150 100
xset b off

xrdb -merge ~/.Xresources
xmodmap ~/.Xmodmap
setxkbmap -layout us -option ctrl:nocaps
/usr/bin/numlockx on

# launch default programs on start
hash vmtoolsd && /usr/bin/vmtoolsd -n vmusr &
