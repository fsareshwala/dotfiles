#!/bin/bash

export PATH=/home/fsareshwala/prefix/bin:$PATH
export TZ=America/Los_Angeles

eval $(ssh-agent) > /dev/null

xset +fp /usr/share/fonts/X11/misc
xset fp rehash

xset r rate 150 100
xset b off

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

setxkbmap -layout us -option ctrl:nocaps

# launch default programs on start
hash numlockx && /usr/bin/numlockx on
hash dunst && /usr/bin/dunst -conf /home/fsareshwala/.dunstrc &

hash vmtoolsd && /usr/bin/vmtoolsd -n vmusr &
# hash vmware-user && /usr/bin/vmware-user &

exec /usr/bin/i3
