#!/bin/bash
xset r rate 150 100
xset b off
xrandr -s 28

# add path to the font path and rebuild font cache
xset +fp /usr/share/fonts/X11/misc
xset fp rehash

xrdb -merge $HOME/.Xresources
xmodmap ~/.Xmodmap
setxkbmap -layout us -option ctrl:nocaps

# launch default programs on start
/usr/bin/google-chrome &
/usr/bin/perl /home/fsareshwala/prefix/bin/edit-server.pl >> /tmp/edit-server.log &
/usr/local/bin/dwmstatus &

/usr/bin/dropbox start -i
/usr/bin/dropbox start

exec /usr/local/bin/dwm
