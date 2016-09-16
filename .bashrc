# vim: set tw=0:

export EDITOR=vim
export TERM=xterm-color
export RSYNC_RSH=/usr/bin/ssh
export FIGNORE='.o:~:.pyc'
export COLORTERM=yes
export PATH=.:~/prefix/bin:$PATH
export USE_CCACHE=yes

stty werase undef
bind '\C-W:unix-filename-rubout'

export HISTCONTROL=ignoredups:erasedups
HISTFILESIZE=100000
shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
PS1='[\u@\h \W] '

bind 'set completion-ignore-case on'

source /etc/bash_completion.d/git
source /home/fsareshwala/prefix/etc/git/git-completion.bash

OS=`uname`
if [[ "$OS" == "Linux" ]]; then
    alias ls='ls --color'
elif [[ "$OS" == "Darwin" ]]; then
    alias ls='ls -G'
fi

# Command Aliases
alias -- ..='cd ..'
alias -- -='cd -'
alias dirdiff='diff -ENwbur'
alias r='tmux attach'
alias s='source ~/.bashrc'
alias i='sudo yum install -y'
alias u='sudo yum update -y'
alias vi='vim'
alias vim='vim -O'
alias reswap='sudo /sbin/swapoff -a && sudo /sbin/swapon -a'
alias png2pdf='for f in *.png ; do convert "$f" "${f%%.*}.pdf"; done'
alias underscore_fname="find .  -exec rename 's/ /_/' {} \;"
alias lowercase_fname="rename 'y/A-Z/a-z/' *"
alias bc='bc -l'
alias gdb='cgdb'

# git aliases
alias b='git branch'
alias ba='git branch -a'
alias d='git diff'
alias gd='git diff --word-diff'
alias dc='git diff --cached'
alias ga='git add'
alias gap='git add -p'
alias gc='git checkout'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gcb='git checkout -b'
alias gm='git commit -m'
alias gp='git pull'
alias st='git status'

ulimit -c unlimited
ulimit -m 1048576
ulimit -n 4096
