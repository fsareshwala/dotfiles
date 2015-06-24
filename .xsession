#!/bin/bash
export TERMINAL=/usr/bin/rxvt-unicode
export PATH=/home/fsareshwala/prefix/bin:$PATH
export TZ=Asia/Singapore

xset r rate 150 100
xset b off
xrandr -s 5

# add path to the font path and rebuild font cache
xset +fp /usr/share/fonts/X11/misc
xset fp rehash

xrdb -merge ~/.Xresources
xmodmap ~/.Xmodmap
setxkbmap -layout us -option ctrl:nocaps

# launch default programs on start
[ -f /etc/motd.sh ] && /etc/motd.sh
hash chromium && /usr/bin/chromium --force-device-scale-factor=1 &
hash perl && /usr/bin/perl /home/fsareshwala/prefix/bin/edit-server.pl >> /tmp/edit-server.log &
hash dunst && /usr/bin/dunst -conf /home/fsareshwala/.dunstrc &
hash vmware-user && /usr/bin/vmware-user &
hash hipchat && /usr/bin/hipchat &

hash dropbox && /usr/bin/dropbox start -i &
hash dropbox && /usr/bin/dropbox start &

exec /usr/bin/i3 --force-xinerama
