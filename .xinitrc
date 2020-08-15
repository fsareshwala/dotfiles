#!/usr/bin/env bash

export PATH=/home/fsareshwala/prefix/bin:$PATH
export PATH=/snap/bin:$PATH
export _JAVA_AWT_WM_NONREPARENTING=1 # so that intellij can start up correctly in dwm

source /home/fsareshwala/.xprofile
eval $(ssh-agent) > /dev/null

# start default programs
numlockx &
dunst -conf /home/fsareshwala/.dunstrc &
/home/fsareshwala/prefix/bin/status &

while [[ true ]]; do
  /home/fsareshwala/code/dwm/dwm
done
