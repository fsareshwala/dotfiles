" --- Dein configuration
if &compatible
    set nocompatible
endif

set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim
call dein#begin('~/.config/nvim')
call dein#add('Shougo/dein.vim')

call dein#add('tpope/vim-ragtag')
call dein#add('sheerun/vim-polyglot')
call dein#add('tpope/vim-commentary')
call dein#add('tpope/vim-surround.git')
call dein#add('vim-scripts/a.vim')
call dein#add('tpope/vim-repeat')
call dein#add('nelstrom/vim-visual-star-search')
call dein#add('tpope/vim-sleuth')
call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-speeddating')

call dein#add('vimwiki/vimwiki')
let g:vimwiki_list = [{'path': '~/personal/', 'syntax': 'markdown', 'ext': '.md', 'auto_toc': 1}]
let g:vimwiki_hl_cb_checked = 2

call dein#add('junegunn/vim-easy-align')
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

call dein#add('ctrlpvim/ctrlp.vim')
let g:ctrlp_map = '<leader>e'
let g:ctrlp_working_path_mode = 'wa'
nnoremap <leader>. :CtrlPTag<cr>

call dein#add('mbbill/undotree')
nnoremap <leader>u :UndotreeToggle<cr>

call dein#add('scrooloose/nerdtree')
let NERDTreeIgnore = []
let NERDTreeIgnore += ['\.o$']
let NERDTreeIgnore += ['\.a$']
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

call dein#add('chaoren/vim-wordmotion')
let g:wordmotion_spaces = '_-.'

call dein#add('FooSoft/vim-argwrap')
nnoremap <leader>a :ArgWrap<cr>

" ciw - change inside word
" yi) - yank inside parenthesis
" vat - visually select around tag
" di" - delete inside double quotes
call dein#add('wellle/targets.vim')

" vii - visually select inside code block using current indentation
" vaI - visually select around code block using current indentation AND include trailing line (for example the end delimiter in Ruby)
call dein#add('michaeljsmith/vim-indent-object')

" [q / ]q - navigate up and down through the quickfix list, for instance through vim-grepper results
" [l / ]l - navigate up and down through the location list, for instance through neomake results
" [a / ]a - navigate backward and forward through the file list
" [<Space> / ]<Space> - add a blank line above or below the current line
" [p / ]p - linewise paste above or below the current line
call dein#add('tpope/vim-unimpaired')

call dein#end()

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

let g:tex_flavor = 'latex'

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
nnoremap j gj
nnoremap k gk
nnoremap <silent> <f4> :let _s=@/<bar>:%s/\s\+$//e<bar>:let @/=_s<bar>:nohl<cr>
nnoremap <leader>v :e  ~/.config/nvim/init.vim<cr>
nnoremap <leader>s :vsplit<cr>
nnoremap <leader>g :execute "Ggrep " . expand('<cword>') . " " . getcwd()<cr>
nnoremap <leader>u YpVr-
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
set copyindent
set expandtab
set exrc
set formatoptions=cjlnqrt
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

colorscheme fsareshwala

" --- File runners for various languages
function! LanguageSetup()
  let path = expand('%:p:h')

  if(&ft == 'c' || &ft == 'cpp')
    nnoremap K :execute 'Man ' . expand('<cword>')<cr>
    nnoremap <leader>b :make -j 3<cr>
    nnoremap <leader>t :make test<cr>
    nnoremap <leader>r exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<cr>
    setlocal commentstring=//\ %s
    setlocal expandtab
  elseif(&ft == 'go')
    nnoremap <leader>b :GoBuild<cr>
    nnoremap <leader>t :GoTest<cr>
  elseif(&ft == 'tex')
    nnoremap <leader>b :!bazel build ...<cr>
    let b:surround_45 = '\\texttt{\r}'
    ab dsol \begin{solutionordottedlines}[1in]<cr><cr>\end{solutionordottedlines}
    ab bsol \begin{solutionorbox}[2in]<cr><cr>\end{solutionorbox}
  elseif(&ft == 'java' || &ft == 'scala')
    setlocal textwidth=120 wrap linebreak
  elseif(&ft == 'vim')
    nnoremap K :execute 'help ' . expand('<cword>')<cr>
  endif
endfunction

autocmd BufEnter * call LanguageSetup()

" --- File and filetype specific settings
let php_sql_query = 1
let php_htmlInStrings = 1

autocmd BufEnter *.workflow setlocal ft=json
autocmd BufEnter *.aurora setlocal ft=python
autocmd BufRead,BufNewFile README setlocal filetype=markdown
autocmd FileType gitcommit setlocal spell tw=72 wrap linebreak
autocmd FileType markdown setlocal spell
autocmd BufEnter markdown :syntax sync fromstart

" --- Random hacks
inoremap <expr> <leader>d strftime('%A, %B %d, %Y') . '<esc>YpVr-$a<cr>'

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
  set clipboard+=unnamedplus
endif
