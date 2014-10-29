map L :tabnext<cr>
map H :tabprev<cr>
map t :call GenerateTags()<cr>
map [ :cp<cr>
map ] :cn<cr>
inoremap jj <esc>

set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'jboyens/vim-protobuf'
Bundle 'plasticboy/vim-markdown'
Bundle 'jnwhiteh/vim-golang'

let g:vim_markdown_folding_disabled=1

filetype plugin indent on
colorscheme fsareshwala
set nobackup
set noswapfile
set mousehide
set ttyfast
set history=1000
set lazyredraw
set shell=/bin/bash
set matchtime=3
set autowrite
set autoread
set title
set virtualedit+=block

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Don't move on *
nnoremap * *<c-o>

set bg=dark
set autoindent
set copyindent
set preserveindent
set cindent
set smartindent
set showtabline=2
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab
set nowrap
set nostartofline
set textwidth=80 wrap linebreak
set expandtab
set comments=sl:/*,mb:\ *,elx:\ */
set formatoptions+=rn
set list
set listchars=tab:\|­,trail:~,extends:>,precedes:<
set hlsearch
set incsearch
set wrapscan
set ignorecase
set smartcase
set mouse=
set number
set ruler
set showmatch
set tags=tags
set showmode
set showcmd
set backspace=eol,start,indent
set clipboard=autoselect
set wildmenu
set wildmode=list:longest,full
set guifont=Terminus\ 8
set wildignore+=*/tmp/*,*cache*,*.so,*.o,*.swp,*.zip
set colorcolumn=+1
set modeline

set nocp
syntax on
let c_space_errors = 1
let java_space_errors = 1

map <Undo> :NERDTreeMirror<cr>
let NERDTreeIgnore = ['\.o$', '\~$', '\.pyc$']
let NERDTreeWinSize = 31

map <c-j> <esc><C-w>j
map <c-k> <esc><C-w>k
map <c-h> <esc><C-w>h
map <c-l> <esc><C-w>l
map <c-o> i<cr><esc>0
map <c-p> "_cw"<esc>

nmap <left> :3wincmd <<cr>
nmap <right> :3wincmd ><cr>
nmap <up> :3wincmd +<cr>
nmap <down> :3wincmd -<cr>

map j gj
map k gk
map m :make -j 2<cr><cr>

function! GenerateTags()
    :silent !ctags -R --exclude=*build* .
    :silent !find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files
    :silent !cscope -b -i cscope.files -f cscope.out
    :silent cs reset
    :redraw!
endfunction

nmap <f2> :copen<cr>
nmap <f3> :NERDTreeToggle<cr>
nmap <silent> <f4> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nmap <f10> :Ack <cword><cr>
nmap <f11> :Gdiff<cr>
nmap <f12> :Gblame w<cr>

runtime! ftplugin/man.vim
map K <leader>K

" Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
if has("autocmd")
    augroup myvimrchooks
        au!
        autocmd bufwritepost .vimrc source ~/.vimrc
    augroup END
endif
