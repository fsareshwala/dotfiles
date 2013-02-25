#!/bin/bash
xset r rate 150 100 # set keyboard repeat rate
xset b off #turn off audio bell
xrandr -s 28 # resize screen

# add path to the font path and rebuild font cache
xset +fp /usr/share/fonts/X11/misc
xset fp rehash

eval `/usr/bin/ssh-agent`

if test -f /usr/lib/ssh/x11-ssh-askpass # Debian
then
    SSH_ASKPASS=/usr/lib/ssh/x11-ssh-askpass ssh-add < /dev/null
fi

xrdb -merge $HOME/.Xresources
xmodmap ~/.Xmodmap
setxkbmap -layout us -option ctrl:nocaps

hash google-chrome && google-chrome &

while true
do
    LOCALTIME=$(date +%Z\=%Y-%m-%dT%H:%M)
    xsetroot -name "$LOCALTIME"
    sleep 1s
done &

exec /usr/local/bin/dwm
