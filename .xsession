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
hash perl && perl /home/fsareshwala/prefix/bin/edit-server.pl > /home/fsareshwala/.edit-server.log &
hash dwmstatus && /usr/local/bin/dwmstatus &

exec /usr/local/bin/dwm
