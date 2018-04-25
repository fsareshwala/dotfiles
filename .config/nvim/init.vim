" --- Dein configuration
if &compatible
    set nocompatible
endif

set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim
call dein#begin('~/.config/nvim')
call dein#add('Shougo/dein.vim')

" Programming languages
call dein#add('alvan/vim-closetag') " html tag ending close helper
call dein#add('elzr/vim-json')
call dein#add('fatih/vim-go')
call dein#add('isRuslan/vim-es6')
call dein#add('rodjek/vim-puppet')
call dein#add('solarnz/thrift.vim.git')

" Editor
call dein#add('Shougo/deoplete.nvim')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('mbbill/undotree')
call dein#add('michaeljsmith/vim-indent-object')
call dein#add('neomake/neomake')
call dein#add('scrooloose/nerdtree')
call dein#add('tpope/vim-commentary')
call dein#add('tpope/vim-surround.git')
call dein#add('vim-scripts/a.vim')
call dein#add('wellle/targets.vim')
call dein#add('FooSoft/vim-argwrap')
call dein#add('godlygeek/tabular')

" Tool Integrations
call dein#add('tpope/vim-fugitive')

call dein#end()

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

" --- Plugin configuration
let g:lion_squeeze_spaces = 1
let g:neomake_open_list = 1
let g:tern_show_argument_hints = 'on_hold'
let g:tern_show_signature_in_pum = 1
let g:ctrlp_map = '<leader>e'
let g:ctrlp_working_path_mode = 'wa'

"  NerdTree
let NERDTreeIgnore = []
let NERDTreeIgnore += ['\.o$']
let NERDTreeIgnore += ['\.d$']
let NERDTreeIgnore += ['\.pyc$']
let NERDTreeIgnore += ['\~$']
let NERDTreeIgnore += ['\.toc$']
let NERDTreeIgnore += ['\.pdf$']
let NERDTreeIgnore += ['\.aux$']
let NERDTreeIgnore += ['\.out$']
let NERDTreeIgnore += ['\.log$']
let NERDTreeIgnore += ['\.class$']
let NERDTreeIgnore += ['tags']
let NERDTreeIgnore += ['__pycache__']
let NERDTreeIgnore += ['__init__.py']
let NERDTreeIgnore += ['CMakeFiles']
let NERDTreeIgnore += ['cmake_install.cmake']
let NERDTreeIgnore += ['CMakeCache.txt']
let NERDTreeWinSize = 31
autocmd BufEnter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
autocmd VimEnter * :NERDTree
autocmd VimEnter * wincmd p

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" omnifuncs
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=tern#Complete
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

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
nnoremap L :tabnext<cr>
nnoremap [ :cp<cr>
nnoremap ] :cn<cr>
nnoremap j gj
nnoremap k gk
nnoremap <silent> <f4> :let _s=@/<bar>:%s/\s\+$//e<bar>:let @/=_s<bar>:nohl<cr>
nnoremap <leader>v :e  ~/.config/nvim/init.vim<cr>
nnoremap <leader>s :vsplit<cr>
nnoremap <leader>g :execute "Ggrep " . expand('<cword>') . " " . getcwd()<cr>
nnoremap <leader>. :CtrlPTag<cr>
nnoremap <leader>u :UndotreeToggle<cr>
nnoremap <leader>a :ArgWrap<cr>
nnoremap <silent> <leader>= :vertical resize +5<cr>
nnoremap <silent> <leader>- :vertical resize -5<cr>

" --- Editor configuration
autocmd VimResized * exe 'normal! \<c-w>='
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
nnoremap * *<c-o>

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
set laststatus=2
set list
set listchars=tab:\|-,trail:~,extends:>,precedes:<
set matchtime=3
set modeline
set mouse=
set mousehide
set nobackup
set nojoinspaces
set noshowmode
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
set tags=tags;
set textwidth=100 wrap linebreak
set title
set undodir=~/.config/nvim/tmp/undo
set undofile
set virtualedit+=block
set wildignore+=*.so,*.o
set wildmenu
set wildmode=list:longest,full
set wrapscan

colorscheme delek

" --- File runners for various languages
function! LanguageSetup()
  let path = expand('%:p:h')

  if(&ft == 'c' || &ft == 'cpp')
    nnoremap K :execute 'Man ' . expand('<cword>')<cr>
    nnoremap <leader>b :make -j 4<cr><cr>
    nnoremap <leader>t :make test<cr>
  elseif(&ft == 'go')
    nnoremap <leader>b :GoBuild<cr>
    nnoremap <leader>t :GoTest<cr>
  elseif(&ft == 'tex')
    nnoremap <leader>b :!pdflatex %:t<cr>
  elseif(&ft == 'vim')
    nnoremap K :execute 'help ' . expand('<cword>')<cr>
  elseif(path =~ 'code/source' && (&ft == 'scala' || &ft == 'java'))
    nnoremap <leader>b :Pants compile<cr>
    nnoremap <leader>t :Pants test<cr>
  endif
endfunction

autocmd BufEnter * call LanguageSetup()

" --- File and filetype specific settings
let php_sql_query = 1
let php_htmlInStrings = 1

autocmd BufEnter *.workflow setlocal ft=json
autocmd BufEnter *.aurora setlocal ft=python
autocmd BufRead,BufNewFile README setlocal filetype=markdown
autocmd FileType gitcommit setlocal spell tw=72
autocmd FileType markdown setlocal spell
autocmd FileType scala :SortScalaImports

" Javascript Tern doesn't have a good way to push and pop onto the tag stack, so fake it :(
function! JSFakePushTag()
  normal mA
  TernDef
endfunction

function! JSFakePopTag()
  normal 'A
endfunction

autocmd FileType javascript map <buffer> <c-]> :call JSFakePushTag()<cr>
autocmd FileType javascript map <buffer> <c-t> :call JSFakePopTag()<cr>

" --- Random hacks
" Load vimrc on save
augroup vimrc
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" Return to the same line when you reopen a file
augroup line_return
  autocmd!
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line('$') |
      \     execute 'normal! g`"zvzz' |
      \ endif
augroup END

" MacOS vs Linux clipboard
if has('mac')
  set clipboard+=unnamed
else
  set clipboard=unnamedplus
endif
