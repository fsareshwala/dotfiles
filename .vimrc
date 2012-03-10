map L :tabnext<cr>
map H :tabprev<cr>
map t :call GenerateTags()<cr>

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

map <Undo> :NERDTreeMirror<cr>
let NERDTreeIgnore = ['\.o$', '\~$', '\.pyc$', '\.x$', '\.d$']
let NERDTreeWinSize = 31

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <c-h> <C-w>h
map <c-j> <C-w>j
map <c-k> <C-w>k
map <c-l> <C-w>l
map <c-o> i<cr><esc>0
map <c-p> "_cw"<esc>

nmap <left> :3wincmd <<cr>
nmap <right> :3wincmd ><cr>
nmap <up> :3wincmd +<cr>
nmap <down> :3wincmd -<cr>

map j gj
map k gk

call pathogen#runtime_append_all_bundles()

function! GitGrep(...)
    let save = &grepprg
    set grepprg=git\ grep\ -n\ $*
    let s = 'grep'

    for i in a:000
        let s = s . ' ' . i
    endfor

    exe s
    let &grepprg = save
endfunction

function! GitGrepWord()
    normal! "zyiw
    call GitGrep('-w -e ', getreg('z'))
endfunction

function! GenerateTags()
    :silent !ctags -R .
    :silent !find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files
    :silent !cscope -b -i cscope.files -f cscope.out
    :silent cs reset
    :redraw!
endfunction

nmap <f3> :NERDTreeToggle<cr>
nmap <f4> :TagbarToggle<cr>
nmap <f9> :silent call GitGrepWord()<cr>:redraw!<cr>
nmap <f10> :ConqueTermVSplit zsh<cr>
nmap <f11> :Gdiff<cr>
nmap <f12> :Gblame<cr>


" Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
if has("autocmd")
    augroup myvimrchooks
        au!
        autocmd bufwritepost .vimrc source ~/.vimrc
    augroup END
endif
