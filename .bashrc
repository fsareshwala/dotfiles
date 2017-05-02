# vim: set tw=0:

export COLORTERM=yes
export EDITOR=/usr/bin/vim
export FIGNORE='.o:~:.pyc'
export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=100000
export PATH=.:~/prefix/bin:$PATH
export PS1='[\u@\h \[\033[0;36m\]\w\[\033[0m\]]\$ '
export RSYNC_RSH=/usr/bin/ssh
export TERM=xterm-256color
export USE_CCACHE=true

# path setup
export PATH=.:$PATH
export PATH=/usr/sbin:$PATH
export PATH=~/.tools-cache/**/bin:$PATH
export PATH=/opt/twitter_mde/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=~/.npm-global/bin:$PATH

stty werase undef
bind '\C-W:unix-filename-rubout'
bind 'set completion-ignore-case on'

shopt -s histappend
shopt -s checkwinsize

tunnel() {
  ssh -N -L 8080:$1 n
}

# command Aliases
alias -- ..='cd ..'
alias -- -='cd -'
alias vi='vim'
alias vim='vim -O'
alias fc='forecash'
alias bc='bc -lq'
alias gdb='cgdb --directory=. -quiet'

# twitter aliases
alias ppost='arc diff --browse'
alias psubmit='arc land'
alias rpost='git review post --use-commit-message'
alias rsubmit=' git review submit --skip-show-build --use-commit-message'

# git aliases
alias b='git branch'
alias ba='git branch -a'
alias d='git diff'
alias dc='git diff --cached'
alias ga='git add'
alias gap='git add -p'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gc='git checkout -b fsareshwala/'
alias gf='git fx'
alias gm='git commit -m'
alias griom='git rebase -i origin/master'
alias grom='git rebase origin/master'
alias st='git status'

# miscellaneous aliases
alias r='tmux attach'
alias s='source ~/.bashrc'
alias pmake='cores=$(grep -c "^processor" /proc/cpuinfo); make -j $cores'
alias reswap='sudo /sbin/swapoff -a; sudo /sbin/swapon -a'
alias watch='watch --color'

ulimit -c unlimited
ulimit -m 1048576
ulimit -n 4096
