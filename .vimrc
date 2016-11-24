" --- Dein configuration
if &compatible
    set nocompatible
endif

set runtimepath+=~/.vim/repos/github.com/Shougo/dein.vim
call dein#begin("~/.vim")
call dein#add('Shougo/dein.vim')

"  Programming languages
call dein#add('derekwyatt/vim-scala')
call dein#add('derekwyatt/vim-sbt')

"  Editor
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('itchyny/lightline.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('vim-scripts/a.vim')
call dein#add('w0ng/vim-hybrid')

"  Tool Integrations
call dein#add('tpope/vim-fugitive')
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
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd VimEnter * :NERDTree

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
nnoremap <silent> <f4> :let _s=@/<bar>:%s/\s\+$//e<bar>:let @/=_s<bar>:nohl<cr>
nnoremap <leader>v :e  ~/.vimrc<cr>
nnoremap <leader>s :vsplit<cr>

" --- Editor configuration
au VimResized * exe "normal! \<c-w>="
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
nnoremap * *<c-o>

colorscheme hybrid
set background=dark
set autoindent
set autoread
set autowrite
set backspace=eol,start,indent
set cindent
set cinoptions+=g0,l1,N-s,j1,J1
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
set splitright
set tabstop=4
set tags=./tags,tags,../tags
set textwidth=80 wrap linebreak
set title
set undodir=~/.vim/tmp/undo/
set undofile
set virtualedit+=block
set wildignore+=*/tmp/*,*cache*,*.so,*.o,*.dd,*.swp,*.zip
set wildmenu
set wildmode=list:longest,full
set wrapscan

" --- File runners for various languages
function! LangRunner()
    if(&ft == "c" || &ft == "cpp")
        nnoremap <leader>b :make -j 4<cr><cr>:copen<cr>
        nnoremap <leader>r :make test<cr>
    elseif(&ft == "scala")
        nnoremap <leader>b :sbtc<cr>
        nnoremap <leader>r :sbtt<cr>
    endif
endfunction

autocmd BufEnter * call LangRunner()

" --- Automatic commands
autocmd BufRead,BufNewFile README set filetype=markdown
autocmd BufEnter *.scala SortScalaImports

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
