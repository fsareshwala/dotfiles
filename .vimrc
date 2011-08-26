map X :tabnext<CR>
map Z :tabprev<CR>
map t :!ctags -R .<CR>

set nocompatible
set nobackup
set foldenable
set mousehide
imap jj <esc>

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
set tabstop=8
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
set clipboard+=unnamed
set wildmenu
set wildmode=list:longest,full
set guifont=Terminus\ 8
set autoread

" make vim's completion menu act more like an ide
set complete=.,w,b,u,t,i
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

set nocp
syntax on
filetype on
filetype indent on
filetype plugin on
let c_space_errors = 1
let java_space_errors = 1

map <F5> :TagbarToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F6> :NERDTreeToggle<CR>
map <Undo> :NERDTreeMirror<CR>
"let NERDChristmasTree = 1
let NERDTreeIgnore = ['\.o$', '\~$', '\.pyc$']
let NERDTreeWinSize = 31

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"OmniCppComplete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let OmniCpp_ShowPrototypeInAbbr = 1         "display prototype in abbreviation
let OmniCpp_SelectFirstItem = 2             "select first popup item (without inserting it to the text)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-K> i<CR><ESC>
noremap <F12> :Gblame<CR>
noremap <F11> :Gdiff<CR>
call pathogen#runtime_append_all_bundles()

" Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
if has("autocmd")
    augroup myvimrchooks
        au!
        autocmd bufwritepost .vimrc source ~/.vimrc
    augroup END
endif
