#!/bin/bash
xset r rate 150 100
xset b off
xrandr -s 5

# add path to the font path and rebuild font cache
xset +fp /usr/share/fonts/X11/misc
xset fp rehash

xrdb -merge $HOME/.Xresources
xmodmap ~/.Xmodmap
setxkbmap -layout us -option ctrl:nocaps

# launch default programs on start
hash chromium && /usr/bin/chromium &
hash perl && /usr/bin/perl /home/fsareshwala/prefix/bin/edit-server.pl >> /tmp/edit-server.log &
hash dwmstatus && /usr/local/bin/dwmstatus &
hash dunst && /usr/bin/dunst -conf /home/fsareshwala/.dunstrc &

hash dropbox && /usr/bin/dropbox start -i &
hash dropbox && /usr/bin/dropbox start &

exec /usr/local/bin/dwm
