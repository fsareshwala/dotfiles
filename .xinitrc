#!/usr/bin/env bash

export PATH=~fsareshwala/prefix/bin:$PATH
export PATH=/snap/bin:$PATH
export _JAVA_AWT_WM_NONREPARENTING=1 # so that intellij can start up correctly in dwm

source ~fsareshwala/.xprofile
eval $(ssh-agent) > /dev/null

# start default programs
numlockx &
dunst -conf ~fsareshwala/.dunstrc &
~fsareshwala/prefix/bin/status &

while [[ true ]]; do
  /usr/local/bin/dwm
done
