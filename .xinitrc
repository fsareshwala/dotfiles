#!/usr/bin/env bash

export PATH=/home/fsareshwala/prefix/bin:$PATH
export PATH=/home/fsareshwala/code/dmenu:${PATH}

source /home/fsareshwala/.xprofile
eval $(ssh-agent) > /dev/null

# start default programs
numlockx &
dunst -conf /home/fsareshwala/.dunstrc &
/home/fsareshwala/prefix/bin/status &

/home/fsareshwala/code/dwm/dwm
