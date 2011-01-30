map X :tabnext<CR>
map Z :tabprev<CR>
map t :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase .<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indendting and tabbing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent
set cindent
set smartindent
set showtabline=2
set shiftwidth=4
set tabstop=4
set smarttab
set nowrap
set textwidth=100 wrap linebreak
set expandtab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" formatting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set comments=sl:/*,mb:\ *,elx:\ */
set formatoptions+=r
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<

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
colorscheme delek
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
set backspace=eol,start,indent
set clipboard+=unnamed
"set foldcolumn=3
set wildmenu
set wildmode=list:longest,full

set nocp
syntax on
filetype on
filetype indent on
filetype plugin on
let c_space_errors = 1
let java_space_errors = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap H <C-w>h
nnoremap J <C-w>j
nnoremap K <C-w>k
nnoremap L <C-w>l
nnoremap <C-j> :join<CR>
nnoremap <C-k> i<CR><ESC>
