set fish_greeting ""

set --export EDITOR vim
set --export GOPATH ~/go
set --export USE_CCACHE true

set --export PATH . $PATH
set --export PATH ~/.tools-cache/**/bin $PATH
set --export PATH /opt/twitter_mde/bin $PATH
set --export PATH $GOPATH/bin $PATH

function install
    sudo apt install -y $argv
end

function update
    sudo apt update
end

function upgrade
    sudo apt -y upgrade
end

function tunnel
    ssh -N -L 8080:$argv n
end

if status --is-interactive
    set -g fish_user_abbreviations

    # git abbreviations
    abbr --add b git branch
    abbr --add ba git branch -a
    abbr --add d git diff
    abbr --add dc git diff --cached
    abbr --add ga git add
    abbr --add gap git add -p
    abbr --add gca git commit --amend
    abbr --add gcan git commit --amend --no-edit
    abbr --add gc git checkout -b fsareshwala/
    abbr --add gf git fx
    abbr --add gm git commit -m
    abbr --add griom git rebase -i origin/master
    abbr --add grom git rebase origin/master
    abbr --add st git status

    # twitter
    abbr --add rpost arc diff --browse
    abbr --add rsubmit arc land

    # miscellaneous
    abbr --add r tmux attach
    abbr --add s source ~/.config/fish/config.fish
    abbr --add fc forecash
end

alias bc 'bc -l'
alias gdb 'cgdb --directory=. -quiet'
alias pmake 'set cores (grep -c "^processor" /proc/cpuinfo); and make -j $cores'
alias reswap 'sudo /sbin/swapoff -a; and sudo /sbin/swapon -a'
alias vim 'vim -O'

ulimit -c unlimited
