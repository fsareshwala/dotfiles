# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export TERM=xterm-color
export EDITOR=vim
export PAGER=~/prefix/usr/local/vimpager/vimpager
export RSYNC_RSH=/usr/bin/ssh
export FIGNORE='.o:~:.pyc'
export COLORTERM=yes
export PATH=~/prefix/bin:.:$PATH

HOSTNAME=`hostname`
if [[ "$HOSTNAME" == "fsareshwala-l" || "$HOSTNAME" == "fsareshwala-ml.corp.qc" ]]; then
    export C_INCLUDE_PATH=/qc/protobuf/include
    export CPLUS_INCLUDE_PATH=/qc/protobuf/include
    export PATH=~/code/git-tools/bin:/qc/protobuf/bin:/var/lib/gems/1.8/gems/ruby_protobuf-0.4.11/bin:/home/fsareshwala/prefix/bin/apache-ant-1.8.4/bin:/usr/bin:$PATH
    export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    export USE_CCACHE=true
    export GEM_HOME=/usr/lib/ruby/gems/1.8
    export GIT_TOP_DIR=~/code
    export ANT_HOME=/home/fsareshwala/prefix/bin/apache-ant-1.8.4

    alias deployer='ruby ~/code/realtime/quantserve/scripts/run_dashboard_job.rb --job 1900000053'
    alias pr='post-review --guess-summary --guess-description'
    alias pxall='parallel-ssh --inline -h ~/prefix/etc/pixel/all'
    alias pxtest='parallel-ssh --inline -h ~/prefix/etc/pixel/sftest-pixel'
fi

HISTCONTROL=ignoreboth # force ignoredups and ignorespace
shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
PS1='\u@\h:\w $ '

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Command Aliases
if [[ "`uname`" == "Linux" ]]; then
    alias ls='ls --color'
    alias ll='ls -lh'
fi

alias -- -='cd -'
alias less=$PAGER
alias m='make'
alias mc='make clean'
alias mt='make test'
alias q='cd ~/code/realtime/quantserve'
alias r='tmux attach'
alias s='source ~/.bashrc'
alias wk='vim ~/personal/worklog'
alias vi='vim'
alias vim='vim -O'
alias zrc='vim ~/.zshrc'
alias zless=$PAGER
alias reswap='sudo /sbin/swapoff -a && sudo /sbin/swapon -a'

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
