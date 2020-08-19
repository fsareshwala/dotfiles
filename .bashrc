#!/usr/bin/env bash
# vim: set tw=0:

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# set up bash, git completion
git_bash_completion=/etc/profile.d/bash_completion.sh
test -f $git_bash_completion && source $git_bash_completion

stty werase undef

# Share bash history across terminal sessions
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

export BROWSER=google-chrome
export EDITOR=nvim
export FIGNORE='.o:~:.pyc'
export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden --glob='!.git' --color=never *"
export FZF_DEFAULT_OPTS='--height 20% --reverse'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GOPATH=${HOME}/go
export JAVA_HOME=$(dirname $(dirname $(readlink /etc/alternatives/java)))
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export MAILCAPS=${HOME}/.mailcap
export MANPAGER='nvim -c "set ft=man" -'
export PS1='[\u@\h \e[34m\w\e[0m]\$ '
export READER=zathura
export RSYNC_RSH=/usr/bin/ssh
export TZ=America/Los_Angeles
export VISUAL=nvim

shopt -s checkwinsize

export PATH=/usr/sbin:${PATH}
export PATH=/home/fsareshwala/.local/bin/:${PATH}
export PATH=$GOPATH/bin:${PATH}
export PATH=/home/fsareshwala/prefix/bin:${PATH}
export PATH=/home/fsareshwala/personal/bin:${PATH}
export PATH=.:${PATH}

# command aliases
alias -- -='cd -'
alias -- ..='cd ..'
alias -- ...='cd ../..'
alias -- ....='cd ../../..'
alias -- .....='cd ../../../..'
alias -- ......='cd ../../../../..'
alias -- .......='cd ../../../../../..'
alias bc='bc -lq'
alias diff="diff --color=auto"
alias gdb='cgdb --directory=. -quiet'
alias grep="grep --color=auto"
alias json='python -m json.tool'
alias ls='ls --color'
alias mkdir='mkdir -p'
alias p='cd ~/personal'
alias patch='patch -merge --no-backup-if-mismatch'
alias pmake='cores=$(grep -c "^processor" /proc/cpuinfo); make -j ${cores}'
alias s='source ~/.bashrc'
alias thes='aiksaurus'
alias vi='vim'
alias vim='nvim -O'
alias vimf='vim $(fzf)'
alias mdv='mdless $(rg --files -t md * | fzf)'
alias watch='watch --color'
alias which='type -p'
alias weather='curl wttr.in'

function reswap() {
  sudo /sbin/swapoff -a
  sudo /sbin/swapon -a
}

function dirdo() {
  local cwd=$(pwd)
  local directories="$(find . -maxdepth 1 -type d)"
  for dir in $directories; do
    if [[ $dir == '.' ]]; then
      continue
    fi

    cd $dir
    echo $(basename $dir):
    "$@" | sed -e 's/^/    /'
    cd $cwd
  done
}

function cal() {
  if [[ $# -eq 0 ]]; then
    /usr/bin/cal -3
  else
    /usr/bin/cal $@
  fi
}

function rreplace() {
  local old="$1"
  local new="$2"
  git grep -l "$old" . | xargs sed -i "s/$old/$new/g"
}

function gc() {
  git checkout -b fsareshwala/${1} -t origin/master
}

if [[ -f ~/.work ]]; then
  # work setup
  alias b='hg bookmark'
  alias clpost='hg upload chain'
  alias clsubmit='hg submit'
  alias d='hg diff'
  alias ha='hg add'
  alias hai='hg amend -i'
  alias ham='hg amend'
  alias hci='hg commit -i'
  alias hm='hg commit -m'
  alias rpost='hg upload chain'
  alias rsubmit='hg submit'
  alias st='hg status'
else
  # personal setup
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
fi

# TODO(fsareshwala): get these figured out
ulimit -c unlimited
ulimit -m 1048576
# ulimit -n 8192
# ulimit -l 16384
