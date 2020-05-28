#!/usr/bin/env bash

xset +fp /usr/share/fonts/X11/misc
xset fp rehash

eval $(ssh-agent) > /dev/null
