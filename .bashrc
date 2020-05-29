#!/usr/bin/env bash

# vim: set tw=0:

git_bash_completion=/etc/profile.d/bash_completion.sh
test -f $git_bash_completion && source $git_bash_completion

stty werase undef

# Share bash history across terminal sessions
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

export BROWSER=google-chrome
export COLORTERM=yes
export EDITOR=nvim
export FIGNORE='.o:~:.pyc'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GOPATH=${HOME}/go
export JAVA_HOME=/etc/alternatives/java_sdk
export MAILCAPS=${HOME}/.mailcap
export PS1='[\u@\h \[\033[0;36m\]\w\[\033[0m\]]\$ '
export READER=zathura
export RSYNC_RSH=/usr/bin/ssh
export TZ=America/Los_Angeles
export VISUAL=nvim

export PATH=/usr/sbin:${PATH}
export PATH=/home/fsareshwala/.local/bin:${PATH}
export PATH=$GOPATH/bin:${PATH}
export PATH=/home/fsareshwala/prefix/bin:${PATH}
export PATH=.:${PATH}

shopt -s checkwinsize

# command aliases
alias -- -='cd -'
alias -- ..='cd ..'
alias bc='bc -lq'
alias diff="diff --color=auto"
alias fc='forecash'
alias gdb='cgdb --directory=. -quiet'
alias grep="grep --color=auto"
alias json='python -m json.tool'
alias ls='ls --color'
alias mkdir='mkdir -p'
alias p='cd ~/personal'
alias pmake='cores=$(grep -c "^processor" /proc/cpuinfo); make -j ${cores}'
alias vi='vim'
alias vim='nvim -O'
alias watch='watch --color'
alias patch='patch -merge --no-backup-if-mismatch'

function reswap() {
  sudo /sbin/swapoff -a
  sudo /sbin/swapon -a
}

function dirdo() {
  cwd=$(pwd)
  directories="$(find . -maxdepth 1 -type d)"
  for dir in $directories; do
    if [[ $dir == '.' ]]; then
      continue
    fi

    cd $dir
    "$@"
    cd $cwd
  done
}

function rreplace() {
  old="$1"
  new="$2"
  git grep -l "$old" . | xargs sed -i "s/$old/$new/g"
}

# miscellaneous aliases
alias r='tmux attach'
alias s='source ~/.bashrc'

# git aliases
alias b='git branch'
alias ba='git branch -a'
alias d='git diff'
alias dc='git diff --cached'
alias ga='git add'
alias gap='git add -p'
alias gb='git checkout @{-1}'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gf='git fx'
alias gignore='git update-index --assume-unchanged'
alias gm='git commit -m'
alias griom='git rebase -i origin/master'
alias grom='git rebase origin/master'
alias st='git status'
complete -A directory gm

function gc() {
  git checkout -b fsareshwala/${1} -t origin/master
}

function lg() {
  git log --abbrev-commit --oneline --pretty=format:'%C(red)%h%C(reset) %C(blue)<%<(25)%an>%Creset %s' -n 10 $@
}

ulimit -c unlimited
ulimit -m 1048576
# ulimit -n 8192
# ulimit -l 16384

# twitter aliases
alias rpost='arc multi-diff'
alias rsubmit='arc land'
alias rlist='arc list'
alias rassign='arc amend --revision'
