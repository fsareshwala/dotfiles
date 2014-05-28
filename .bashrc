# vim: set tw=0:
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export TERM=xterm-color
export EDITOR=vim
export PAGER=~/prefix/usr/local/vimpager/vimpager
export RSYNC_RSH=/usr/bin/ssh
export FIGNORE='.o:~:.pyc'
export COLORTERM=yes
export PATH=~/prefix/bin:.:$PATH
export GOPATH=/home/fsareshwala/go

stty werase undef
bind '\C-W:unix-filename-rubout'

HOSTNAME=`hostname`
if [[ "$HOSTNAME" == "fsareshwala-l" || "$HOSTNAME" == "fsareshwala-ml.corp.qc" ]]; then
    export C_INCLUDE_PATH=/qc/protobuf/include
    export CPLUS_INCLUDE_PATH=/qc/protobuf/include
    export PATH=~/code/git-tools/bin:/qc/protobuf/bin:/qc/thrift/bin:/var/lib/gems/1.8/gems/ruby_protobuf-0.4.11/bin:/home/fsareshwala/prefix/bin/apache-ant-1.8.4/bin:/usr/bin:$PATH
    export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
    export USE_CCACHE=true
    export GEM_HOME=/usr/lib/ruby/gems/1.8
    export GIT_TOP_DIR=~/code
    export ANT_HOME=/home/fsareshwala/prefix/bin/apache-ant-1.8.4
    export BUILD_TYPE=debug
    export LD_LIBRARY_PATH=/qc/google-perftools/lib

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

# Command Aliases
if [[ "`uname`" == "Linux" ]]; then
    alias ls='ls --color'
    alias ll='ls -lh'
fi

alias -- ..='cd ..'
alias -- -='cd -'
alias less=$PAGER
alias m='make'
alias mc='make clean'
alias mt='make test'
alias r='tmux attach'
alias s='source ~/.bashrc'
alias wk='vim ~/personal/worklog'
alias vi='vim'
alias vim='vim -O'
alias zless=$PAGER
alias reswap='sudo /sbin/swapoff -a && sudo /sbin/swapon -a'
alias png2pdf='for f in *.png ; do convert "$f" "${f%%.*}.pdf"; done'
alias underscore_fname="find .  -exec rename 's/ /_/' {} \;"
alias lowercase_fname="rename 'y/A-Z/a-z/' *"
alias pr='post-review --branch=$(git symbolic-ref --short -q HEAD) --tracking-branch=origin/master --target-groups=realtime-data'
alias rsubmit='rbt close --close-type=submitted'
alias rdiscard='rbt close --close-type=discarded'
alias rst='rbt status --all'
alias bsub="sed -i -e 's/\${project.version.depends}/latest.integration/g' **/ivy.xml"

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
[[ -s "/home/fsareshwala/.gvm/scripts/gvm" ]] && source "/home/fsareshwala/.gvm/scripts/gvm"
