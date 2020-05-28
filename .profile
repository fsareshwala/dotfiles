#!/usr/bin/env bash

xrdb /home/fsareshwala/.Xresources
setxkbmap -layout us -option ctrl:nocaps

xset r rate 150 100
xset b off
xsetroot -solid black

xset +fp /usr/share/fonts/X11/misc
xset fp rehash

eval $(ssh-agent) > /dev/null

numlockx &
dunst -conf /home/fsareshwala/.dunstrc &
