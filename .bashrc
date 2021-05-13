#!/usr/bin/env bash
# vim: set tw=0:

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

if [[ -d ~/prefix ]]; then
  source ~/prefix/lib/utilities.sh
  source ~/prefix/usr/local/bash/key-bindings.bash
  source ~/prefix/usr/local/bash/git-completion.bash
  source ~/prefix/usr/local/bash/git-prompt.sh
  source ~/prefix/usr/local/shell/base16/profile_helper.sh
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
  rg --hidden -l "$old" . | xargs sed -i "s,$old,$new,g"
}

function gc() {
  git checkout -b fsareshwala/${1} -t origin/master
}

function fc() {
  pushd ~/code/forecash/cli
  go build

  config_prefix="$HOME/drive"
  if is_mac_os; then
    config_prefix="$HOME/My Drive"
  fi

  forecash --config "$config_prefix/archive/fc-chase.json"
  popd
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

  if [[ "$PWD" == "$HOME/code/rust_crates"* ]]; then
    return 0
  fi

  return 1
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
export MANROFFOPT='-c'
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

export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden --color=never *"
export FZF_DEFAULT_OPTS='--height 20% --reverse'

# c_black="\[\033[0;30m\]"
# c_red="\[\033[0;31m\]"
c_green="\[\033[0;32m\]"
c_yellow="\[\033[0;33m\]"
c_blue="\[\033[0;34m\]"
c_purple="\[\033[0;35m\]"
# c_cyan="\[\033[0;36m\]"
c_white="\[\033[0;37m\]"
PS1="[$c_green\u$c_white@$c_purple\h$c_white:$c_yellow\$(__git_ps1 "%s")$c_white $c_blue\w$c_white]\$ "

function set_path() {
  # build path entirely from scartch to prevent unnecessary duplicates and
  # support directory based path elements (e.g. Fuchsia doesn't like the
  # current directory in the path but I like that elsewhere in my system)
  export PATH="/bin"
  export PATH="/sbin:$PATH"
  export PATH="/usr/bin:$PATH"
  export PATH="/usr/sbin:$PATH"
  export PATH="/usr/local/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"
  export PATH="$GOPATH/bin:$PATH"
  export PATH="$HOME/prefix/bin:$PATH"
  export PATH="$HOME/prefix/usr/local/google-cloud-sdk/bin:$PATH"
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.cargo/bin:$PATH"

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
    export PATH="$HOME/code/pigweed/environment/cipd/packages/bazel/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/bazel:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/buildifier:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/cmake/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/cmake:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/coverage:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/arm/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/arm:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/pigweed/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/pigweed:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/python311:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/doxygen/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/doxygen:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/go/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/go:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/host_tools:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/kythe:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/luci:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/python38/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/python38:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/rbe:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/testing:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/web/bin:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd/packages/web:$PATH"
    export PATH="$HOME/code/pigweed/environment/cipd:$PATH"
  fi

  if is_mac_os; then
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="/usr/local/git/current/bin:$PATH"
    export PATH="/usr/local/git/git-google/bin:$PATH"
    export PATH="$HOME/Library/Python/3.13/bin:$PATH"
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
alias gdb='cgdb --directory=. -quiet'
alias grep="rg --color=auto"
alias json='python3 -m json.tool'
alias lg='lazygit'
alias ll='ls -l'
alias lp='lp -o sides=two-sided-long-edge'
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
alias gpr='git pull --rebase'
alias gri='git rebase -i'
alias griom='git rebase -i origin/master'
alias grom='git rebase origin/master'
alias gs='git show'
complete -A directory gm

if at_work; then
  FX_ENV="$HOME/code/fuchsia/scripts/fx-env.sh"
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
    elif is_mac_os; then
      /opt/homebrew/bin/tig $@
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

  # keep the ninja build graph in memory after the build completes
  export NINJA_PERSISTENT_MODE=1

  # enable targeting gn labels directly
  export FX_BUILD_WITH_LABELS=1

  alias gmsh='gmosh fsareshwala-cloudtop.c.googlers.com'
  alias gssh='ssh fsareshwala-cloudtop.c.googlers.com'

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
  alias wk='vim ~/personal/career/google.md'

  alias cd-i='cd ~/code/google3/corp/hiring/interview_questions/questions/g3doc/genswe'
  alias cd-f='cd ~/code/fuchsia'
  alias cd-p='cd ~/code/pigweed'
  alias cd-bt='cd ~/code/pigweed/pw_bluetooth_sapphire'
  alias cd-abt='cd ~/code/fuchsia/vendor/google/starnix/android/hal/bluetooth_hidl'
  alias cd-uwb='cd ~/code/fuchsia/vendor/google/starnix/android/hal/uwb_aidl'
  alias cd-fbt='cd ~/code/fuchsia/src/connectivity/bluetooth'
  # alias cd-uwb='cd ~/code/fuchsia/vendor/google/connectivity/uwb'

  btcmd_args='--config googletest --config asan'
  if on_cloudtop; then
    btcmd_args="$btcmd_args --config remote_cache"
  fi

  alias btpresubmit='pw presubmit --step gn_chre_googletest_nanopb_sapphire_build'
  alias m="bazelisk build $btcmd_args //pw_bluetooth_sapphire/host/..."
  alias t="bazelisk test $btcmd_args //pw_bluetooth_sapphire/host/..."

  common_test="bazel-bin/pw_bluetooth_sapphire/host/common/common_test"
  alias common_test="m && $common_test"
  alias common_debug="m && lldb -o run $common_test --"

  hci_test="bazel-bin/pw_bluetooth_sapphire/host/hci/hci_test"
  alias hci_test="m && $hci_test"
  alias hci_debug="m && lldb -o run $hci_test --"

  gap_test="bazel-bin/pw_bluetooth_sapphire/host/gap/gap_test"
  alias gap_test="m && $gap_test"
  alias gap_debug="m && lldb -o run $gap_test --"

  gatt_test="bazel-bin/pw_bluetooth_sapphire/host/gatt/gatt_test"
  alias gatt_test="m && $gatt_test"
  alias gatt_debug="m && lldb -o run $gatt_test --"

  l2cap_test="bazel-bin/pw_bluetooth_sapphire/host/l2cap/l2cap_test"
  alias l2cap_test="m && $l2cap_test"
  alias l2cap_debug="m && lldb -o run $l2cap_test --"

  sm_test="bazel-bin/pw_bluetooth_sapphire/host/sm/sm_test"
  alias sm_test="m && $sm_test"
  alias sm_debug="m && lldb -o run $sm_test --"

  btcmd_paths=""
  btcmd_paths="$btcmd_paths //pw_bluetooth/..."
  btcmd_paths="$btcmd_paths //pw_bluetooth_hci/..."
  btcmd_paths="$btcmd_paths //pw_bluetooth_proxy/..."
  btcmd_paths="$btcmd_paths //pw_bluetooth_sapphire/..."
  alias btbuild="bazelisk build $btcmd_args $btcmd_paths"
  alias bttest="bazelisk test $btcmd_args $btcmd_paths"

  alias fupdate='pushd third_party/glslang/src && git fetch --tags --force && popd && git pull --rebase && jiri update -gc -rebase-all -rebase-untracked'
  fx_set='fx set --args="experimental_thread_sampler_enabled=true" --with //src/connectivity/bluetooth'
  fx_asan='--variant host_asan --variant asan'

  if on_cloudtop; then
    fx_set="$fx_set --rbe-mode=cloudtop"
  else
    fx_set="$fx_set --rbe-mode=workstation"
  fi

  alias fx-core="$fx_set core.x64"
  alias fx-core-asan="fx-core $fx_asan"

  alias fx-astro="$fx_set smart_display_eng.astro"
  alias fx-astro-asan="fx-astro $fx_asan"

  alias fx-nelson="$fx_set smart_display_m3_eng.nelson"
  alias fx-nelson-asan="fx-nelson  $fx_asan"

  alias fx-sherlock="$fx_set smart_display_max_eng.sherlock"
  alias fx-sherlock-asan="fx-sherlock $fx_asan"

  bluetooth_hidl="--with //vendor/google/starnix/android/hal/bluetooth_hidl:tests"
  bluetooth_hidl="$bluetooth_hidl --with //vendor/google/starnix/android/hal/uwb_aidl:tests"
  alias fx-vim3="$fx_set hsp.arm64 --main-pb //vendor/google/products/pixel_watch:pixel_watch_eng.vim3-vg $bluetooth_hidl"
  alias fx-vim3-asan="fx-vim3 $fx_asan"

  alias fx-pw-femu="$fx_set hsp.x64 --main-pb //vendor/google/products/pixel_watch:pixel_watch_eng.x64 $bluetooth_hidl"
  alias fx-pw-femu-asan="$fx_set hsp.x64 $fx_asan"

  alias btnew='bugged create --format=MARKDOWN 1472729'
  alias cd-g3='cd ~/code/google3'
  alias mdformat='/google/bin/releases/corpeng-engdoc/tools/mdformat'
else
  alias d='git diff'
  alias st='git status'
fi

base16_brewer
