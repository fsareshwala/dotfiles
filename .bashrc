# vim: set tw=0:

export EDITOR=vim
export TERM=xterm-256color
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
export PS1='[\u@\h \[\033[0;36m\]\W\[\033[0m\]]\$ '

bind 'set completion-ignore-case on'
source $HOME/prefix/etc/git/git-completion.bash

OS=`uname`
if [[ "$OS" == "Linux" ]]; then
    alias ls='ls --color'
elif [[ "$OS" == "Darwin" ]]; then
    alias ls='ls -G'
fi

tunnel() {
    ssh -N -L 8080:$1 n
}

# Command Aliases
alias -- ..='cd ..'
alias -- -='cd -'
alias bc='bc -l'
alias dirdiff='diff -ENwbur'
alias gdb='cgdb --directory=. -quiet'
alias i='sudo yum install -y'
alias lowercase_fname="rename 'y/A-Z/a-z/' *"
alias make='make -j 4'
alias png2pdf='for f in *.png ; do convert "$f" "${f%%.*}.pdf"; done'
alias r='tmux attach'
alias reswap='sudo /sbin/swapoff -a && sudo /sbin/swapon -a'
alias rpost='git review post --use-commit-message'
alias rsubmit='git review submit --skip-show-build --use-commit-message'
alias s='source ~/.bashrc'
alias u='sudo yum update -y'
alias underscore_fname="find .  -exec rename 's/ /_/' {} \;"
alias vi='vim'
alias vim='vim -O'

# git aliases
alias b='git branch'
alias ba='git branch -a'
alias d='git diff'
alias dc='git diff --cached'
alias ga='git add'
alias gap='git add -p'
alias gc='git checkout'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gcb='git checkout -b'
alias gcb='git checkout -b'
alias gd='git diff --word-diff'
alias gf='git fx'
alias gl='git log -n 10'
alias gm='git commit -m'
alias gp='git pull'
alias st='git status'

ulimit -c unlimited
ulimit -m 1048576
ulimit -n 4096
