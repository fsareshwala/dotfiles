#!/usr/bin/env bash

export PATH=/home/fsareshwala/prefix/bin:$PATH
export PATH=/home/fsareshwala/code/dmenu:${PATH}

eval $(ssh-agent) > /dev/null
source ~/prefix/lib/utilities.sh

xrdb /home/fsareshwala/.Xresources
setxkbmap -layout us -option ctrl:nocaps

xset r rate 150 100
xset b off

# start default programs
numlockx &
dunst -conf /home/fsareshwala/.dunstrc &
/home/fsareshwala/prefix/bin/status &

if at_work; then
  /opt/google/drive-file-stream/drive_fs 2>/dev/null &
fi

/home/fsareshwala/prefix/bin/setbg
/home/fsareshwala/code/dwm/dwm
