# vim: set tw=0:
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export TERM=xterm-256color
export EDITOR=vim
export PAGER=/usr/bin/less
export RSYNC_RSH=/usr/bin/ssh
export FIGNORE='.o:~:.pyc'
export COLORTERM=yes
export GOPATH=$HOME/go
export GOAPPENGINE=/usr/local/go_appengine
export GOROOT=$GOAPPENGINE/goroot
export PATH=.:~/prefix/bin:$GOPATH/bin:/usr/local/go/bin:$GOAPPENGINE:$PATH
export ANT_HOME=/usr/share/ant

. /etc/bash_completion

stty werase undef
bind '\C-W:unix-filename-rubout'

HOSTNAME=`hostname`
if [[ "$HOSTNAME" == "fsareshwala-l" || "$HOSTNAME" == "fsareshwala-ml.corp.qc" ]]; then
    export C_INCLUDE_PATH=/qc/protobuf/include
    export CPLUS_INCLUDE_PATH=/qc/protobuf/include
    export PATH=/qc/protobuf-2.6.1/bin:/qc/google-perftools/bin:/usr/lib/postgresql/9.4/bin:~/code/devtools/rbt-custom-tools:$PATH
    export USE_CCACHE=true
    export GEM_HOME=/usr/lib/ruby/gems/1.8
    export GIT_TOP_DIR=~/code
    export BUILD_TYPE=debug
    export LD_LIBRARY_PATH=/qc/google-perftools/lib
    export JAVA_KESTREL_BIN=/usr/lib/jvm/java-7-oracle/bin/java

    alias deployer='ruby ~/code/realtime/quantserve/scripts/run_dashboard_job.rb --job 1900000053'
fi

export HISTCONTROL=ignoredups:erasedups
HISTFILESIZE=100000
shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
PS1='[\u@\h \W] '

bind 'set completion-ignore-case on'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

OS=`uname`
if [[ "$OS" == "Linux" ]]; then
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
    alias ls='ls --color'
elif [[ "$OS" == "Darwin" ]]; then
    export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
    alias ls='ls -G'
fi

# Command Aliases
alias -- ..='cd ..'
alias -- -='cd -'
alias cdq='cd ~/code/realtime/quantserve'
alias cdb='cd ~/code/realtime/bidding'
alias less="$PAGER -R"
alias m='make'
alias mc='make clean'
alias mt='make test'
alias r='tmux attach'
alias s='source ~/.bashrc'
alias vi='vim'
alias vim='vim -O'
alias reswap='sudo /sbin/swapoff -a && sudo /sbin/swapon -a'
alias png2pdf='for f in *.png ; do convert "$f" "${f%%.*}.pdf"; done'
alias underscore_fname="find .  -exec rename 's/ /_/' {} \;"
alias lowercase_fname="rename 'y/A-Z/a-z/' *"
alias pr='rbt post --branch=$(git symbolic-ref --short -q HEAD) --tracking-branch=origin/master -g auto'
alias rsubmit='rbt close --close-type=submitted'
alias rdiscard='rbt close --close-type=discarded'
alias rst='rbt status --all'
alias fpr='~/code/realtime/quantserve/scripts/first-post-review'
alias rpr='qc-post-review --force --update -g'
alias bc='bc -l'

# git aliases
alias b='git branch'
alias ba='git branch -a'
alias d='git diff'
alias gd='git diff --word-diff'
alias dc='git diff --cached'
alias ga='git add'
alias gap='git add -p'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gm='git commit -m'
alias gp='git pull'
alias st='git status'

ulimit -c unlimited
ulimit -m 1048576
ulimit -n 4096
