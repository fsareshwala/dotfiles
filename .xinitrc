#!/usr/bin/env bash

export PATH=/home/fsareshwala/prefix/bin:$PATH
export PATH=/home/fsareshwala/code/dmenu:${PATH}

eval $(ssh-agent) > /dev/null
source /home/fsareshwala/.xprofile
/home/fsareshwala/code/dwm/dwm
