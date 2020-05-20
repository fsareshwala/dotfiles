#!/bin/bash

export PATH=/home/fsareshwala/prefix/bin:$PATH
export TZ=America/Los_Angeles

eval $(ssh-agent) > /dev/null

xset +fp /usr/share/fonts/X11/misc
xset fp rehash
