#!/usr/bin/env bash
# vim: set tw=0:

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
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
export READER=zathura
export RSYNC_RSH=/usr/bin/ssh
export TZ=America/Los_Angeles
export VISUAL=nvim

c_black="\[\033[0;30m\]"
c_red="\[\033[0;31m\]"
c_green="\[\033[0;32m\]"
c_brown="\[\033[0;33m\]"
c_blue="\[\033[0;34m\]"
c_purple="\[\033[0;35m\]"
c_cyan="\[\033[0;36m\]"
c_white="\[\033[0;37m\]"
export PS1="[$c_green\u$c_white@$c_purple\h$c_white $c_blue\w$c_white]\$ "

shopt -s checkwinsize

export PATH=/usr/sbin:${PATH}
export PATH=/home/fsareshwala/.local/bin/:${PATH}
export PATH=$GOPATH/bin:${PATH}
export PATH=/home/fsareshwala/prefix/bin:${PATH}
export PATH=/home/fsareshwala/personal/bin:${PATH}
export PATH=.:${PATH}

# command aliases
alias -- -='cd -'
alias -- .......='cd ../../../../../..'
alias -- ......='cd ../../../../..'
alias -- .....='cd ../../../..'
alias -- ....='cd ../../..'
alias -- ...='cd ../..'
alias -- ..='cd ..'
alias bc='bc -lq'
alias diff="diff --color=auto"
alias dlmp3='youtube-dl -x --audio-format mp3 --audio-quality 0 --embed-thumbnail'
alias dlvid='youtube-dl --recode-video mp4 --add-metadata'
alias fd='fdfind'
alias gdb='cgdb --directory=. -quiet'
alias grep="rg --color=auto"
alias json='python -m json.tool'
alias ls='ls --color'
alias ll='ls -l'
alias mkdir='mkdir -p'
alias p='cd ~/personal'
alias patch='patch -merge --no-backup-if-mismatch'
alias pkgupdate='sudo apt update && sudo apt upgrade'
alias pmake='cores=$(grep -c "^processor" /proc/cpuinfo); make -j ${cores}'
alias s='source ~/.bashrc'
alias thes='aiksaurus'
alias vb='vim ~/.bashrc'
alias vi='vim'
alias vim='nvim -O'
alias vimf='vim $(fzf)'
alias watch='watch --color'
alias weather='curl wttr.in'
alias which='type -p'
alias cat='batcat'

# git aliases
alias b='git branch'
alias ba='git branch -a'
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
alias gs='git show'

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
  rg -l "$old" . | xargs sed -i "s/$old/$new/g"
}

function gc() {
  git checkout -b fsareshwala/${1} -t origin/master
}

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

if [[ -f ~/.work ]]; then
  # work setup
  function in_google3() {
    if [[ "$PWD" == "$HOME/code"* ]]; then
      return 0
    else
      return 1
    fi
  }

  function st() {
    if in_google3; then
      hg status $@
    else
      git status $@
    fi
  }

  function d() {
    if in_google3; then
      hg diff $@
    else
      git diff $@
    fi
  }

  function tig() {
    if in_google3; then
      hg xl $@
    else
      /usr/bin/tig $@
    fi
  }

  alias rdrop='hg cls-drop -p --skip-confirmation -c'
  alias rpost='hg upload chain'
  alias rsubmit='hg submit'
  alias ha='hg add'
  alias hab='hg absorb'
  alias hai='hg amend -i'
  alias ham='hg amend'
  alias hb='hg blame -udcw'
  alias hca='hg commit --amend'
  alias hci='hg commit -i'
  alias hm='hg commit -m'
  alias hs='hg export'
  alias hrm='hg resolve --mark'
  alias he='hg histedit'
  alias hst='hg diff -r .^:. --stat'

  alias cd-g3='cd ~/code/google3'
fi

# TODO(fsareshwala): get these figured out
ulimit -c unlimited
ulimit -m 1048576
# ulimit -n 8192
# ulimit -l 16384
