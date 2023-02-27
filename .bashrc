#!/usr/bin/env bash
# vim: set tw=0:

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

prefix=
if [[ -d ~/prefix ]]; then
  source ~/prefix/lib/utilities.sh
  source ~/prefix/usr/local/bash/key-bindings.bash
  source ~/prefix/usr/local/bash/git-completion.bash
  source ~/prefix/usr/local/bash/git-prompt.sh
fi

function timestamp() {
  python3 -c "from datetime import datetime; print(datetime.fromtimestamp($*).strftime('%B %d %Y'))"
}

function reswap() {
  sudo /sbin/swapoff -a
  sudo /sbin/swapon -a
}

function dirdo() {
  local cwd=$PWD
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

stty -ixon # disable software control flow (ctrl-s and ctrl-q, urxvt support)
stty werase undef
shopt -s checkwinsize

# Share bash history across terminal sessions
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

export BROWSER=google-chrome
export EDITOR=nvim
export FIGNORE='.o:~:.pyc'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GOPATH=${HOME}/go
export JAVA_HOME=$(dirname $(dirname $(readlink /etc/alternatives/java)))
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export MAILCAPS=${HOME}/.mailcap
export MANPAGER='sh -c "col -bx | batcat -l man -p"'
export READER=zathura
export RSYNC_RSH=/usr/bin/ssh
export TZ=America/Los_Angeles
export VISUAL=nvim

if is_mac_os; then
  export TERM=xterm-256color
else
  export TERM=rxvt-unicode-256color
fi

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

function in_fuchsia() {
  if [[ "$PWD" == "$HOME/code/fuchsia"* ]]; then
    return 0
  fi

  return 1
}

function in_pigweed() {
  if [[ "$PWD" == "$HOME/code/pigweed"* ]]; then
    return 0
  fi

  return 1
}

export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden --color=never *"
export FZF_DEFAULT_OPTS='--height 20% --reverse'

c_black="\[\033[0;30m\]"
c_red="\[\033[0;31m\]"
c_green="\[\033[0;32m\]"
c_yellow="\[\033[0;33m\]"
c_blue="\[\033[0;34m\]"
c_purple="\[\033[0;35m\]"
c_cyan="\[\033[0;36m\]"
c_white="\[\033[0;37m\]"
PS1="[$c_green\u$c_white@$c_purple\h$c_white:$c_yellow\$(__git_ps1 "%s")$c_white $c_blue\w$c_white]\$ "

function set_path() {
  # build path entirely from scartch to prevent unnecessary duplicates and
  # support directory based path elements (e.g. Fuchsia doesn't like the
  # current directory in the path but I like that elsewhere in my system)
  export PATH=""

  if in_fuchsia; then
    export PATH="$HOME/code/fuchsia/.jiri_root/bin:$PATH"
    export PATH="$HOME/code/fuchsia/scripts:$PATH"
  else
    # Fuchsia doesn't like the current directory in the path
    export PATH=".:$PATH"
  fi

  if in_pigweed; then
    export PATH="$HOME/code/pigweed/out/host/host_tools:$PATH"
    export PATH="$HOME/code/pigweed/environment/pigweed-venv/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/bazel:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/cmake/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/cmake:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/go/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/go:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/host_tools:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/kythe:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/luci:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/rbe:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/testing:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/web/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/web:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/buildifier:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/arm/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/arm:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/pigweed/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/pigweed:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/python/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/python:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/black:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd:$PATH"
  fi

  export PATH="/bin:$PATH"
  export PATH="/sbin:$PATH"
  export PATH="/usr/bin:$PATH"
  export PATH="/usr/sbin:$PATH"
  export PATH="/usr/local/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"
  export PATH="$GOPATH/bin:$PATH"
  export PATH="$HOME/prefix/bin:$PATH"
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.cargo/bin:$PATH"

  if is_mac_os; then
    export PATH="/opt/homebrew/bin:$PATH"
  fi
}

if [[ -z $PROMPT_COMMAND ]]; then
  export PROMPT_COMMAND="set_path"
else
  export PROMPT_COMMAND="$PROMPT_COMMAND; set_path"
fi

# command aliases
alias -- -='cd -'
alias -- .........='cd ../../../../../../../..'
alias -- ........='cd ../../../../../../..'
alias -- .......='cd ../../../../../..'
alias -- ......='cd ../../../../..'
alias -- .....='cd ../../../..'
alias -- ....='cd ../../..'
alias -- ...='cd ../..'
alias -- ..='cd ..'
alias bc='bc -lq'
alias diff="diff --color=auto"
alias dlmp3='yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail'
alias dlvid='yt-dlp --recode-video mp4 --add-metadata'
alias fc='cd ~/code/forecash && go build && forecash --config ~/personal/fc-chase.json && cd -'
alias gdb='cgdb --directory=. -quiet'
alias grep="rg --color=auto"
alias json='python -m json.tool'
alias ll='ls -l'
alias ls='ls --color'
alias mkdir='mkdir -p'
alias patch='patch -merge --no-backup-if-mismatch'
alias pmake='make -j $(nproc)'
alias rgdb='rust-gdb --tui'
alias s='source ~/.bashrc'
alias sxiv='sxiv -atop'
alias tar='tar --use-compress-program=pigz'
alias thes='aiksaurus'
alias vim='nvim -O'
alias vimf='nvim $(fzf)'
alias watch='watch --color'
alias weather='curl wttr.in'
alias which='type -p'

if is_mac_os; then
  alias cat='bat'
else
  alias cat='batcat'
  alias fd='fdfind'
fi

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
alias gri='git rebase -i'
alias griom='git rebase -i origin/master'
alias grom='git rebase origin/master'
alias gs='git show'
complete -A directory gm

if at_work; then
  FX_ENV=~/code/fuchsia/scripts/fx-env.sh
  test -e $FX_ENV && source $FX_ENV

  function in_google3() {
    if [[ "$PWD" == "$HOME/code/google3"* ]]; then
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

  function rpost() {
    if in_google3; then
      hg upload chain
    elif in_fuchsia; then
      jiri upload
    elif in_pigweed; then
      git push origin HEAD:refs/for/main
    fi
  }

  # use remote build execution to speed up builds
  export USE_RBE=true

  alias ha='hg add'
  alias hab='hg absorb'
  alias hai='hg amend -i'
  alias ham='hg amend'
  alias hb='hg blame -udcw'
  alias hca='hg commit --amend'
  alias hci='hg commit -i'
  alias he='hg histedit'
  alias hm='hg commit -m'
  alias hrm='hg resolve --mark'
  alias hs='hg export'
  alias hst='hg diff -r .^:. --stat'
  alias rdrop='hg cls-drop -p --skip-confirmation -c'
  alias rsubmit='hg submit'
  alias pw='pw --no-banner'

  alias cd-bt='cd ~/code/fuchsia/src/connectivity/bluetooth'
  alias cd-f='cd ~/code/fuchsia'
  alias cd-p='cd ~/code/pigweed'
  alias cd-uwb='cd ~/code/fuchsia/vendor/google/connectivity/uwb'
else
  alias d='git diff'
  alias st='git status'
fi

# TODO(fsareshwala): get these figured out
ulimit -c unlimited
ulimit -m 1048576
# ulimit -n 8192
# ulimit -l 16384
