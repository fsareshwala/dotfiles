#!/usr/bin/env bash

# so that intellij can start up correctly in dwm
export _JAVA_AWT_WM_NONREPARENTING=1

xrdb /home/fsareshwala/.Xresources
setxkbmap -layout us -option ctrl:nocaps

xset r rate 150 100
xset b off
xsetroot -solid black

xset +fp /usr/share/fonts/X11/misc
xset fp rehash

eval $(ssh-agent) > /dev/null

# start default programs
numlockx &
dunst -conf /home/fsareshwala/.dunstrc &
/home/fsareshwala/prefix/bin/status &
