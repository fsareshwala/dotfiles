#!/bin/bash
export TERMINAL=/usr/bin/rxvt-unicode
export PATH=/home/fsareshwala/prefix/bin:$PATH

xset r rate 150 100
xset b off
xrandr -s 28

# add path to the font path and rebuild font cache
xset +fp /usr/share/fonts/X11/misc
xset fp rehash

xrdb -merge ~/.Xresources
xmodmap ~/.Xmodmap
setxkbmap -layout us -option ctrl:nocaps

# launch default programs on start
hash chromium && GTK2_RC_FILES=/dev/null /usr/bin/chromium &
hash perl && /usr/bin/perl /home/fsareshwala/prefix/bin/edit-server.pl >> /tmp/edit-server.log &
hash dunst && /usr/bin/dunst -conf /home/fsareshwala/.dunstrc &
hash vmware-user && /usr/bin/vmware-user &

hash dropbox && /usr/bin/dropbox start -i &
hash dropbox && /usr/bin/dropbox start &

exec /usr/bin/i3 --force-xinerama
