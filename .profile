#!/bin/bash

export PATH=/home/fsareshwala/prefix/bin:$PATH
export TZ=America/Los_Angeles

eval $(ssh-agent) > /dev/null

xset +fp /usr/share/fonts/X11/misc
xset fp rehash

xset r rate 150 100
xset b off

setxkbmap -layout us -option ctrl:nocaps

# launch default programs on start
hash numlockx && /usr/bin/numlockx on
hash dunst && dunst -conf /home/fsareshwala/.dunstrc &
