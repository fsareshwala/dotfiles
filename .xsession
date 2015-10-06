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
/usr/bin/numlockx on

# launch default programs on start
hash chromium && /usr/bin/chromium --force-device-scale-factor=1 --ignore-gpu-blacklist &
hash dunst && /usr/bin/dunst -conf /home/fsareshwala/.dunstrc &
hash vmware-user && /usr/bin/vmware-user &
hash hipchat && /usr/bin/hipchat &

hash dropbox && /usr/bin/dropbox start -i &
hash dropbox && /usr/bin/dropbox start &

exec /usr/bin/i3 --force-xinerama
