" --- Dein configuration
if &compatible
    set nocompatible
endif

set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim
call dein#begin("~/.config/nvim")
call dein#add('Shougo/dein.vim')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('tpope/vim-fugitive')
call dein#add('itchyny/lightline.vim')
call dein#add('w0ng/vim-hybrid')
call dein#end()

filetype plugin indent on
syntax enable

if dein#check_install()
    call dein#install()
endif

" --- Plugin configuration
"  NerdTree
let NERDTreeIgnore = ['\.d$', '\.o$', '\~$', '\.pyc$', 'tags']
let NERDTreeWinSize = 31
au bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"  Ctrl-P
let g:ctrlp_map = '<leader>t'

" --- Key mappings
nnoremap <c-h> <esc><c-w>h
nnoremap <c-j> <esc><c-w>j
nnoremap <c-k> <esc><c-w>k
nnoremap <c-l> <esc><c-w>l
nnoremap <c-o> i<cr><esc>0
nnoremap <c-p> "_cw"<esc>
nnoremap H :tabprev<cr>
nnoremap K :Man <c-r><c-w><cr>
nnoremap L :tabnext<cr>
nnoremap [ :cp<cr>
nnoremap ] :cn<cr>
nnoremap j gj
nnoremap k gk
nnoremap <silent> <f4> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nnoremap <leader>v :e  ~/.config/nvim/init.vim<CR>

" --- Editor configuration
au VimResized * exe "normal! \<c-w>="
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
nnoremap * *<c-o>

set background=dark
colorscheme hybrid
set autoindent
set autoread
set autowrite
set backspace=eol,start,indent
set cindent
set colorcolumn=+1
set comments=sl:/*,mb:\ *,elx:\ */
set copyindent
set expandtab
set exrc
set formatoptions+=1lrn
set guifont=Terminus\ 8
set hlsearch
set ignorecase
set incsearch
set list
set listchars=tab:\|-,trail:~,extends:>,precedes:<
set matchtime=3
set modeline
set mouse=
set mousehide
set nobackup
set nojoinspaces
set nostartofline
set noswapfile
set nowrap
set number
set preserveindent
set shell=/usr/bin/fish
set shiftwidth=4
set showmatch
set showtabline=2
set smartcase
set smartindent
set smarttab
set softtabstop=4
set tabstop=4
set textwidth=80 wrap linebreak
set title
set virtualedit+=block
set wildignore+=*/tmp/*,*cache*,*.so,*.o,*.dd,*.swp,*.zip
set wildmenu
set wildmode=list:longest,full
set wrapscan
set undodir=~/.config/nvim/tmp/undo/
set undofile

" --- Automatic commands
if has("autocmd")
    autocmd VimEnter * :NERDTree
    autocmd BufRead,BufNewFile README set filetype=mkd
endif

" --- File runners for various languages
function! LangRunner()
  if(&ft=="python")
    nnoremap <leader>r :!python %<cr>
  elseif(&ft=="c" || &ft=="cpp")
    nnoremap <leader>r :make -j 4<cr><cr>
    nnoremap <leader>t :make test<cr>
  endif
endfunction

au BufEnter * call LangRunner()


" --- Random hacks
" Return to the same line when you reopen a file
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" MacOS vs Linux clipboard
if has("mac")
    set clipboard+=unnamed
else
    set clipboard=unnamedplus
endif
