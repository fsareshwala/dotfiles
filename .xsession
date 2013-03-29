#!/bin/bash
xset r rate 150 100
xset b off
xrandr -s 20

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
