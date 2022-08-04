#!/usr/bin/env bash

export PATH=~fsareshwala/prefix/bin:$PATH

source ~fsareshwala/.xprofile
eval $(ssh-agent) > /dev/null

# start default programs
numlockx &
dunst -conf ~fsareshwala/.dunstrc &
~fsareshwala/prefix/bin/status &

/usr/local/bin/dwm
