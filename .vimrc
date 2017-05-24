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
call dein#add('fatih/vim-go')
call dein#add('elzr/vim-json')
call dein#add('alvan/vim-closetag') " html tag ending close helper
call dein#add('isRuslan/vim-es6')
call dein#add('rodjek/vim-puppet')

"  Editor
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('itchyny/lightline.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('vim-scripts/a.vim')
call dein#add('w0ng/vim-hybrid')
call dein#add('mbbill/undotree')
call dein#add('majutsushi/tagbar')

"  Tool Integrations
call dein#add('tpope/vim-fugitive')
call dein#add('edma2/vim-pants')

call dein#end()

filetype plugin indent on
syntax enable

if dein#check_install()
    call dein#install()
endif

" --- Plugin configuration
"  NerdTree
let NERDTreeIgnore = ['\.o$', '\~$', '\.pyc$', 'tags']
let NERDTreeWinSize = 31
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd VimEnter * :NERDTree
autocmd VimEnter * wincmd p

"  Ctrl-P
let g:ctrlp_map = '<leader>e'
let g:ctrlp_working_path_mode = 'c' " the directory of the current file.
" let g:ctrlp_working_path_mode = 'ra' " the nearest ancestor containing revision control directory

" Manpages
runtime! ftplugin/man.vim

" --- Key mappings
nnoremap <c-h> <esc><c-w>h
nnoremap <c-j> <esc><c-w>j
nnoremap <c-k> <esc><c-w>k
nnoremap <c-l> <esc><c-w>l
nnoremap <c-o> i<cr><esc>0
nnoremap <c-p> "_cw"<esc>
nnoremap H :tabprev<cr>
nnoremap K :Man <cword><cr>
nnoremap L :tabnext<cr>
nnoremap [ :cp<cr>
nnoremap ] :cn<cr>
nnoremap j gj
nnoremap k gk
nnoremap <silent> <f4> :let _s=@/<bar>:%s/\s\+$//e<bar>:let @/=_s<bar>:nohl<cr>
nnoremap <leader>v :e  ~/.vimrc<cr>
nnoremap <leader>s :vsplit<cr>
nnoremap <leader>g :Ggrep <cword><cr>
nnoremap <leader>. :CtrlPTag<cr>
nnoremap <leader>u :UndotreeToggle<cr>
nnoremap <silent> <leader>= :vertical resize +5<cr>
nnoremap <silent> <leader>- :vertical resize -5<cr>

" --- Editor configuration
au VimResized * exe "normal! \<c-w>="
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
nnoremap * *<c-o>

colorscheme hybrid
set autoindent
set autoread
set autowriteall
set background=dark
set backspace=eol,start,indent
set cindent
set cinoptions+=g0,l1,N-s,j1,J1
set colorcolumn=+1
set comments=sl:/*,mb:\ *,elx:\ */
set copyindent
set expandtab
set exrc
set formatoptions+=1lrn
set gdefault
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
set shell=$SHELL
set shiftwidth=2
set showmatch
set showtabline=2
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitright
set tabstop=2
set tags=./tags,tags,../tags
set textwidth=100 wrap linebreak
set title
set undodir=~/.vim/tmp/undo/
set undofile
set virtualedit+=block
set wildignore+=*.so,*.o
set wildmenu
set wildmode=list:longest,full
set wrapscan

" --- File runners for various languages
function! LangRunner()
    if(&ft == "c" || &ft == "cpp")
        nnoremap <leader>b :make -j 4<cr><cr>
        nnoremap <leader>t :make test<cr>
    elseif(&ft == "go")
        nnoremap <leader>b :GoBuild<cr>
        nnoremap <leader>t :GoTest<cr>
    elseif(&ft == "scala" || &ft == "java")
        nnoremap <leader>b :Pants compile<cr>
        nnoremap <leader>t :Pants test<cr>
    endif
endfunction

autocmd BufEnter * call LangRunner()

" --- File and filetype specific settings
autocmd BufEnter *.workflow set ft=json
autocmd BufEnter *.aurora set ft=python
autocmd BufRead,BufNewFile README setlocal filetype=markdown
autocmd FileType gitcommit setlocal spell tw=72
autocmd FileType markdown setlocal spell
autocmd FileType scala :SortScalaImports
autocmd FileType scala :TagbarToggle

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
