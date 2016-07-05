#!/bin/bash
export TERMINAL=/usr/bin/rxvt-unicode
export PATH=/home/fsareshwala/prefix/bin:$PATH
export TZ=America/Los_Angeles

xset r rate 150 100
xset b off
xrandr -s 5

# add path to the font path and rebuild font cache
xset +fp /usr/share/fonts/X11/misc
xset fp rehash

xrdb -merge ~/.Xresources
xmodmap ~/.Xmodmap
setxkbmap -layout us -option ctrl:nocaps
/usr/bin/numlockx on

# launch default programs on start
# hash google-chrome && /usr/bin/google-chrome --force-device-scale-factor=1 --ignore-gpu-blacklist &
hash dunst && /usr/bin/dunst -conf /home/fsareshwala/.dunstrc &
hash vmtoolsd && /usr/bin/vmtoolsd -n vmusr &
