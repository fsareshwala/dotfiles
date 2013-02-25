#!/bin/bash
xset r rate 150 100 # set keyboard repeat rate
xset b off #turn off audio bell
xrandr -s 9 # resize screen

# add path to the font path and rebuild font cache
xset +fp /usr/share/fonts/X11/misc
xset fp rehash

xrdb -merge $HOME/.Xresources
xmodmap ~/.Xmodmap
setxkbmap -layout us -option ctrl:nocaps

hash google-chrome && google-chrome &

while true
do
    TIME=$(date "+%A, %B %d, %Y | %I:%M %p")
    xsetroot -name "$TIME"
    sleep 1s
done &

exec /usr/local/bin/dwm
