# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------
export TERM=xterm-color
export EDITOR=vim
export PAGER=less
export RSYNC_RSH=/usr/bin/ssh
export FIGNORE='.o:~:.pyc'
export COLORTERM=yes
export HISTFILE=~/.zshhistory
export HISTSIZE=3000
export SAVEHIST=3000
export PATH=.:~/prefix/bin:/usr/local/lib/google_appengine:$PATH

export P4USER=fsareshwala
export P4CLIENT=fsareshwala-linux
export P4PORT=perforce1.sfo1.qc:1666
export P4MERGE=vimdiff
export P4EDITOR=vim

# -----------------------------------------------
# Set up the prompt
# -----------------------------------------------
autoload -U promptinit
promptinit

autoload -U colors
colors

export PROMPT="[%{$fg[blue]%}%n%{$fg[default]%}@%{$fg[green]%}%m%{$fg[default]%} %{$fg[yellow]%}%c%{$fg[default]%}]%# "
export RPROMPT="[%{$fg[yellow]%} %~ %{$fg[default]%}|%{$fg[blue]%} %D{%a %x %I:%M:%S %p} %{$fg[default]%}]"

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
setopt extended_history             # save date, time, and elapsed time
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
alias c=clear
alias gpr='git p4 rebase'
alias gps='git p4 submit'
alias gp4='vim ~/prefix/bin/git-p4'
alias ls='ls --color'
alias m='make'
alias mc='make clean'
alias mrc='vim ~/.muttrc'
alias p='python'
alias pr='post-review --guess-summary --guess-description'
alias r='screen -dr'
alias s='source ~/.zshrc'
alias sls='screen -ls'
alias vc='vim ~/.vimrc'
alias vi='vim'
alias vim='vim -O'
alias x=exit
alias zrc='vim ~/.zshrc'

alias pssh='parallel-ssh --inline'
alias pxall='pssh -h ~/prefix/etc/pixel/all'
alias pxus='pssh -h ~/prefix/etc/pixel/us'
alias pxeu='pssh -h ~/prefix/etc/pixel/eu'
alias pxas='pssh -h ~/prefix/etc/pixel/as'
alias pxsftest='pssh -h ~/prefix/etc/pixel/sftest'
alias pxsef='pssh -h ~/prefix/etc/pixel/sef'
alias pxlax='pssh -h ~/prefix/etc/pixel/lax'
alias pxchg='pssh -h ~/prefix/etc/pixel/chg'
alias pxnym='pssh -h ~/prefix/etc/pixel/nym'
alias pxwdc='pssh -h ~/prefix/etc/pixel/wdc'
alias pxacs='pssh -h ~/prefix/etc/pixel/acs'
alias pxhou='pssh -h ~/prefix/etc/pixel/hou'
alias pxnyl='pssh -h ~/prefix/etc/pixel/nyl'
alias pxukl='pssh -h ~/prefix/etc/pixel/ukl'
alias pxdel='pssh -h ~/prefix/etc/pixel/del'
alias pxhkg='pssh -h ~/prefix/etc/pixel/hkg'
alias pxtok='pssh -h ~/prefix/etc/pixel/tok'

alias q='cd ~/code/main/platform/quantserve'

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
# case-insensitive tab completion for filenames (useful on Mac OS X)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# General completion technique
zstyle ':completion:*' completer _complete _correct _approximate _prefix
zstyle ':completion:*' completer _complete _prefix
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

# -----------------------------------------------
# Set up completion for hostnames
# -----------------------------------------------

if [[ "$ZSH_VERSION_TYPE" == 'new' ]]; then
  : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}}
else
  # Older versions don't like the above cruft
  _etc_hosts=()
fi

hosts=(
    "$_etc_hosts[@]"

    localhost
    #Add favourite hosts here, and zsh will autocomplete them
)

zstyle ':completion:*' hosts $hosts

my_accounts=(
    root@localhost
    #Add ssh hosts here, and zsh will autocomplete them
)

zstyle ':completion:*:my-accounts' users-hosts $my_accounts

import_history() {
    fc -RI
}

export CLICOLOR=1
#export LSCOLORS=CxFxExDxBxegedabagacad
