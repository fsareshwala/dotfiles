set EDITOR nvim

function install
    sudo yum install -y $argv
end

function upgrade
    sudo yum update -y
end

function tunnel
    ssh -N -L 8080:$argv n
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
