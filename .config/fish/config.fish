set EDITOR nvim
set --export USE_CCACHE true

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

    # miscellaneous
    abbr --add vim nvim
end

alias bc 'bc -l'
alias gdb 'cgdb --directory=. -quiet'
alias make 'make -j 4'
alias r 'tmux attach'
alias reswap 'sudo /sbin/swapoff -a; and sudo /sbin/swapon -a'
alias s 'source ~/.config/fish/config.fish'
alias vim 'nvim -O'

alias rpost 'git review post --use-commit-message'
alias rsubmit 'git review submit --skip-show-build --use-commit-message'
