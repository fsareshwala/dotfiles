#!/usr/bin/env bash

export PATH=/home/fsareshwala/prefix/bin:$PATH
export PATH=/home/fsareshwala/code/dmenu:${PATH}

eval $(ssh-agent) > /dev/null

# start default programs
numlockx &
dunst -conf /home/fsareshwala/.dunstrc &
/home/fsareshwala/prefix/bin/status &

source ~/prefix/lib/utilities.sh
if at_work; then
  /opt/google/drive-file-stream/drive_fs 2>/dev/null &
fi

/home/fsareshwala/code/dwm/dwm
