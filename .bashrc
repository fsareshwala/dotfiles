# vim: set tw=0:

export COLORTERM=yes
export EDITOR=vim
export FIGNORE='.o:~:.pyc'
export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=100000
export PATH=.:~/prefix/bin:$PATH
export PS1='[\u@\h \[\033[0;36m\]\w\[\033[0m\]]\$ '
export RSYNC_RSH=/usr/bin/ssh
export TERM=xterm-256color

stty werase undef
bind '\C-W:unix-filename-rubout'

shopt -s histappend
shopt -s checkwinsize

bind 'set completion-ignore-case on'

# Command Aliases
alias -- ..='cd ..'
alias -- -='cd -'
alias vi='vim'
alias vim='vim -O'

# git aliases
alias b='git branch'
alias ba='git branch -a'
alias d='git diff'
alias dc='git diff --cached'
alias ga='git add'
alias gap='git add -p'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gc='git checkout -b fsareshwala/'
alias gf='git fx'
alias gm='git commit -m'
alias griom='git rebase -i origin/master'
alias grom='git rebase origin/master'
alias st='git status'

ulimit -c unlimited
ulimit -m 1048576
ulimit -n 4096
