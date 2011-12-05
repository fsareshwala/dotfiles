#!/bin/sh

if [ "`uname`" == "Darwin" ] ; then
    PATH=$PATH:/usr/local/bin
    xsetroot -solid '#4a525a'
    exec >>~/.xsession-errors 2>&1
    xmodmap ~/.Xmodmap-darwin
    ~/prefix/bin/dwm-launch
fi
