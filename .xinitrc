#!/usr/bin/env bash

# so that intellij can start up correctly in dwm
export _JAVA_AWT_WM_NONREPARENTING=1

export PATH=/home/fsareshwala/prefix/bin:${PATH}
source /home/fsareshwala/.xprofile

eval $(ssh-agent) > /dev/null

# start default programs
numlockx &
dunst -conf /home/fsareshwala/.dunstrc &
/home/fsareshwala/prefix/bin/status &

/home/fsareshwala/code/dwm/dwm
