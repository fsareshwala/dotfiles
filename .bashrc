# vim: set tw=0:

export COLORTERM=yes
export EDITOR=nvim
export FIGNORE='.o:~:.pyc'
export HISTCONTROL=ignoredups:erasedups
export HISTFILESIZE=100000
export PS1='[\u@\h \[\033[0;36m\]\w\[\033[0m\]]\$ '
export RSYNC_RSH=/usr/bin/ssh
export USE_CCACHE=true
export GOPATH=${HOME}/go

# path setup
export PATH=.:${PATH}
export PATH=.:~/prefix/bin:${PATH}
export PATH=$GOPATH/bin:${PATH}
export PATH=~/.npm-global/bin:${PATH}
export PATH=~/Library/Python/2.7/bin:${PATH}
export PATH=./node_modules/.bin:${PATH}
export PATH=/usr/sbin:${PATH}

# twitter path setup
export PATH=~/code/git/.STAGE/git.Linux.x86_64/bin:${PATH}
export PATH=/opt/twitter_mde/bin:${PATH}

DOT_TOOLS=~/.tools
if [[ -f ${DOT_TOOLS} ]]; then
  for dir in $(cat ${DOT_TOOLS}); do
    export PATH=~/.tools-cache/${dir}/bin:${PATH}
  done
fi

stty werase undef
bind '\C-W:unix-filename-rubout'
bind 'set completion-ignore-case on'

shopt -s histappend
shopt -s checkwinsize

tunnel() {
  ssh -N -L 8080:${1} n
}

# command Aliases
alias -- -='cd -'
alias -- ..='cd ..'
alias bc='bc -lq'
alias fc='forecash'
alias gdb='cgdb --directory=. -quiet'
alias vi="TERM='' nvim"
alias vim="TERM='' nvim -O"

if [[ $(uname) == "Darwin" ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color'
fi

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
alias gf='git fx'
alias gm='git commit -m'
alias griom='git rebase -i origin/master'
alias grom='git rebase origin/master'

gc() {
  git checkout -b fsareshwala/${1}
}

st() {
  if [[ $(pwd) == */code/source* ]]; then
    git status -uno
  else
    git status
  fi
}

# miscellaneous aliases
alias pmake='cores=$(grep -c "^processor" /proc/cpuinfo); make -j ${cores}'
alias r='tmux attach'
alias reswap='sudo /sbin/swapoff -a; sudo /sbin/swapon -a'
alias s='source ~/.bashrc'
alias watch='watch --color'

ulimit -c unlimited
ulimit -m 1048576
ulimit -n 4096
