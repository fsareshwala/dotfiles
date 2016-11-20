set fish_greeting ""
set EDITOR nvim

set --export USE_CCACHE true
set --export PATH . ~/.tools-cache/**/bin $PATH

function install
    sudo yum install -y $argv
end

function upgrade
    sudo yum update -y
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
    abbr --add gcb git checkout -b
    abbr --add gf git fx
    abbr --add gm git commit -m
    abbr --add griom git rebase -i origin/master
    abbr --add grom git rebase origin/master
    abbr --add st git status

    # twitter
    abbr --add rpost git review post --use-commit-message
    abbr --add rsubmit git review submit --skip-show-build --use-commit-message

    # miscellaneous
    abbr --add vim nvim
    abbr --add r tmux attach
    abbr --add s source ~/.config/fish/config.fish
end

alias bc 'bc -l'
alias gdb 'cgdb --directory=. -quiet'
alias make 'make -j 4'
alias reswap 'sudo /sbin/swapoff -a; and sudo /sbin/swapon -a'
alias vim 'nvim -O'
