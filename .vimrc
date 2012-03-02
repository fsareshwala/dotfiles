map L :tabnext<CR>
map H :tabprev<CR>
map t :!ctags -R .<CR>

set nocompatible
set nobackup
set foldenable
set mousehide
imap jj <esc>
set ttyfast
set history=1000
" set undofile
" set undoreload=10000
set lazyredraw
set shell=/bin/zsh
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indendting and tabbing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
set textwidth=80 wrap linebreak
set expandtab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" formatting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set comments=sl:/*,mb:\ *,elx:\ */
set formatoptions+=r
set list
set listchars=tab:\|­,trail:~,extends:>,precedes:<

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch
set incsearch
set wrapscan
set ignorecase
set smartcase

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" interactions and interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a
set number
set ruler
set showmatch
set tags=tags
"set spell
set showmode
set showcmd
"set scrolloff=5
"set foldmethod=indent
"set foldcolumn=3
set backspace=eol,start,indent
set clipboard=unnamedplus
set wildmenu
set wildmode=list:longest,full
set guifont=Terminus\ 8

set nocp
syntax on
filetype on
filetype indent on
filetype plugin on
let c_space_errors = 1
let java_space_errors = 1

map <Undo> :NERDTreeMirror<CR>
let NERDTreeIgnore = ['\.o$', '\~$', '\.pyc$', '\.x$', '\.d$']
let NERDTreeWinSize = 31

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-o> i<CR><ESC>0
map <c-p> "_cw"<esc>

nmap <left> :3wincmd <<cr>
nmap <right> :3wincmd ><cr>
nmap <up> :3wincmd +<cr>
nmap <down> :3wincmd -<cr>

map j gj
map k gk

call pathogen#runtime_append_all_bundles()

" enable :G for git grep
func GitGrep(...)
    let save = &grepprg
    set grepprg=git\ grep\ -n\ $*
    let s = 'grep'
    for i in a:000
        let s = s . ' ' . i
    endfor
    exe s
    let &grepprg = save
endfun
command -nargs=? G call GitGrep(<f-args>)

" enable <C-x>G for git grep on word under cursor
func GitGrepWord()
    normal! "zyiw
    call GitGrep('-w -e ', getreg('z'))
endf

nmap <F3> :NERDTreeToggle<CR>
nmap <F4> :TagbarToggle<CR>
nmap <F9> :call GitGrepWord()<CR>
nmap <F10> :ConqueTermVSplit zsh<CR>
nmap <F11> :Gdiff<CR>
nmap <F12> :Gblame<CR>


" Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
if has("autocmd")
    augroup myvimrchooks
        au!
        autocmd bufwritepost .vimrc source ~/.vimrc
    augroup END
endif
