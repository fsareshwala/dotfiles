#!/usr/bin/env bash

export COLORTERM=yes
export EDITOR=nvim
export FIGNORE='.o:~:.pyc'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GOPATH=${HOME}/go
export JAVA_HOME=/etc/alternatives/java_sdk
export MAILCAPS=${HOME}/.mailcap
export RSYNC_RSH=/usr/bin/ssh
export TZ=America/Los_Angeles
export VISUAL=nvim
export READER=zathura
export BROWSER=google-chrome

export PATH=/usr/sbin:${PATH}
export PATH=/home/fsareshwala/.local/bin:${PATH}
export PATH=$GOPATH/bin:${PATH}
export PATH=/home/fsareshwala/prefix/bin:${PATH}
export PATH=.:${PATH}

ssh-agent & > /dev/null

xset +fp /usr/share/fonts/X11/misc
xset fp rehash
