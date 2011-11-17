# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------
export TERM=xterm-color
export EDITOR=vim
export PAGER=~/prefix/usr/local/vimpager/vimpager
export RSYNC_RSH=/usr/bin/ssh
export FIGNORE='.o:~:.pyc'
export COLORTERM=yes
export HISTFILE=~/.zshhistory
export HISTSIZE=3000
export SAVEHIST=3000
export PATH=$PATH:~/prefix/bin:~/code/git-tools/bin:.
export GIT_TOP_DIR=~/code
export USE_CCACHE=true
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
export GEM_HOME=/usr/lib/ruby/gems/1.8

# -----------------------------------------------
# Set up the prompt
# -----------------------------------------------
autoload -U promptinit
promptinit

autoload -U colors
colors

export PROMPT="[%{$fg[blue]%}%n%{$fg[default]%}@%{$fg[yellow]%}%m%{$fg[default]%} %{$fg[green]%}%c%{$fg[default]%}]%# "
export RPROMPT="[%{$fg[green]%} %~ %{$fg[default]%}]"

# -----------------------------------------------
# Set zsh options
# -----------------------------------------------
setopt no_beep
setopt correct
setopt auto_list
setopt auto_cd
#setopt auto_pushd
setopt multios
setopt complete_in_word
setopt complete_aliases
setopt extended_glob
setopt hash_all
setopt no_nomatch

# history
setopt inc_append_history
#setopt share_history
#setopt extended_history             # save date, time, and elapsed time
setopt hist_ignore_dups             # don't add sequential duplicated commands to the history
setopt hist_reduce_blanks           # tidy up the line when entering into the line
setopt nonotify                     # don't notify immediately when a background process completes
setopt zle

bindkey  history-incremental-search-backward
bindkey  history-incremental-search-backward

# -----------------------------------------------
# Shell Aliases
# -----------------------------------------------
## Command Aliases
alias calpost='calpost -u fsareshwala -c realtime'
alias deployer='ruby ~/code/realtime/quantserve/scripts/run_dashboard_job.rb --job 1900000053'
alias less=$PAGER
alias ls='ls --color'
alias l='ls'
alias make='make --no-print-directory'
alias m='make'
alias mc='make clean'
alias mrc='vim ~/.muttrc'
alias o='popd'
alias p='pushd'
alias pr='post-review --guess-summary --guess-description'
alias r='tmux attach'
alias s='source ~/.zshrc'
alias wk='vim ~/personal/worklog'
alias vc='vim ~/.vimrc'
alias vi='vim'
alias vim='vim -O'
alias x=exit
alias zrc='vim ~/.zshrc'
alias zless=$PAGER

# git aliases
alias b='git branch -a'
alias d='git diff'
alias dc='git diff --cached'
alias dt='git difftool'
alias ga='git add'
alias gap='git add -p'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gm='git commit -m'
alias gp='git pull'
alias mt='git mergetool'
alias st='git status'

# parallel ssh aliases
alias pssh='parallel-ssh --inline'
alias pxall='pssh -h ~/prefix/etc/pixel/all'
alias pxams='pssh -h ~/prefix/etc/pixel/ams004'
alias pxlon='pssh -h ~/prefix/etc/pixel/lon003'
alias pxpar='pssh -h ~/prefix/etc/pixel/par002'
alias pxsef='pssh -h ~/prefix/etc/pixel/sef003'
alias pxlax='pssh -h ~/prefix/etc/pixel/lax007'
alias pxchg='pssh -h ~/prefix/etc/pixel/chg004'
alias pxnym='pssh -h ~/prefix/etc/pixel/nym008'
alias pxwdc='pssh -h ~/prefix/etc/pixel/wdc009'
alias pxacs='pssh -h ~/prefix/etc/pixel/acs001'
alias pxhou='pssh -h ~/prefix/etc/pixel/hou001'
alias pxhkg='pssh -h ~/prefix/etc/pixel/hkg001'
alias pxtok='pssh -h ~/prefix/etc/pixel/tok003'

# directory aliases
alias c='cd ~/code'
alias q='cd ~/code/realtime/quantserve'
alias g='cd ~/projects/owrglass/owrglass'
alias n='cd ~/projects/codex/website/neocodex'

# -----------------------------------------------
# Load zsh modules
# -----------------------------------------------
# compinit initializes various advanced completions for zsh
autoload -U compinit && compinit 
# zmv is a batch file rename tool; e.g. zmv '(*).text' '$1.txt'
autoload zmv

# -----------------------------------------------
# Set up zsh autocompletions
# -----------------------------------------------
# case-insensitive tab completion for filenames
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# General completion technique
zstyle ':completion:*' completer _complete _correct _approximate _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
 
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

import_history() {
    fc -RI
}

export CLICOLOR=1
#export LSCOLORS=CxFxExDxBxegedabagacad
