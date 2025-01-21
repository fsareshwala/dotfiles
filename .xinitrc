#!/usr/bin/env bash

export PATH=/home/fsareshwala/prefix/bin:$PATH
export PATH=/home/fsareshwala/code/dmenu:${PATH}
export GTK_THEME=Adwaita:dark

eval $(ssh-agent) > /dev/null

# start default programs
hash numlockx && numlockx &
hash dunst && dunst &
/home/fsareshwala/prefix/bin/status &

source ~/prefix/lib/utilities.sh
if at_work; then
  /opt/google/drive-file-stream/drive_fs 2>/dev/null &
fi

/home/fsareshwala/code/dwm/dwm
