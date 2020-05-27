#!/usr/bin/env bash

eval $(ssh-agent) > /dev/null

xset +fp /usr/share/fonts/X11/misc
xset fp rehash

# exec /home/fsareshwala/prefix/bin/dwm
ssh-agent /usr/bin/i3
