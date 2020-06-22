" --- Dein configuration
if &compatible
    set nocompatible
endif

set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim
call dein#begin('~/.config/nvim')
call dein#add('Shougo/dein.vim')

call dein#add('tpope/vim-ragtag')
call dein#add('tpope/vim-commentary')
call dein#add('tpope/vim-surround.git')
call dein#add('vim-scripts/a.vim')
call dein#add('tpope/vim-repeat')
call dein#add('nelstrom/vim-visual-star-search')
call dein#add('tpope/vim-sleuth')
call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-speeddating')
call dein#add('tpope/vim-abolish')
call dein#add('mboughaba/i3config.vim')

call dein#add('sheerun/vim-polyglot')
let g:vim_markdown_conceal = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

call dein#add('junegunn/vim-easy-align')
xmap ga <Plug>(EasyAlign)

call dein#add('vimwiki/vimwiki')
let g:vimwiki_list = [{'path': '~/personal/', 'syntax': 'markdown', 'ext': '.md', 'auto_toc': 1}]
let g:vimwiki_hl_cb_checked = 2
let g:vimwiki_conceallevel = 0

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
let NERDTreeIgnore += ['\.pdf$']
let NERDTreeIgnore += ['\.class$']
let NERDTreeIgnore += ['tags']
let NERDTreeIgnore += ['__pycache__']
let NERDTreeIgnore += ['__init__.py']
let NERDTreeIgnore += ['CMakeFiles']
let NERDTreeIgnore += ['cmake_install.cmake']
let NERDTreeIgnore += ['CMakeCache.txt']
let NERDTreeIgnore += ['bazel-*']
let NERDTreeWinSize = 31
autocmd BufEnter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
autocmd VimEnter * :NERDTree
autocmd VimEnter * wincmd p
nnoremap <leader>n :NERDTreeMirror<cr>

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

colorscheme fsareshwala

" --- Key mappings
nnoremap <c-h> <esc><c-w>h
nnoremap <c-j> <esc><c-w>j
nnoremap <c-k> <esc><c-w>k
nnoremap <c-l> <esc><c-w>l
nnoremap <c-o> i<cr><esc>0
nnoremap <c-p> "_cw"<esc>
xnoremap <c-\> gc
nnoremap H :tabprev<cr>
nnoremap L :tabnext<cr>
nnoremap j gj
nnoremap k gk
nnoremap <leader>b :w! \| !compile build <c-r>%<cr>
nnoremap <leader>t :w! \| !compile test <c-r>%<cr>
nnoremap <leader>g :execute "Ggrep " . expand('<cword>') . " " . getcwd()<cr>
nnoremap <leader>u YpVr-
nnoremap <silent> <leader>- :vertical resize -5<cr>
nnoremap <silent> <leader>= :vertical resize +5<cr>
nnoremap <silent> <leader>s :vsplit<cr>
nnoremap <silent> <leader>v :e  ~/.config/nvim/init.vim<cr>

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
set clipboard+=unnamedplus
set colorcolumn=+1
set copyindent
set expandtab
set exrc
set formatoptions=cjlnqrt
set gdefault
set guifont=Terminus\ 8
set hlsearch
set ignorecase
set inccommand=split
set incsearch
set laststatus=2
set nrformats+=alpha,octal
set list
set listchars=tab:\|-,trail:~,extends:>,precedes:<
set matchtime=3
set modeline
set modelines=5
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

" --- File runners for various languages
function! LanguageSetup()
  if(&ft == 'c' || &ft == 'cpp')
    nnoremap K :execute 'Man ' . expand('<cword>')<cr>
    setlocal commentstring=//\ %s
  elseif(&ft == 'tex')
    let b:surround_45 = '\\texttt{\r}'
    ab dsol \begin{solutionordottedlines}[1in]<cr><cr>\end{solutionordottedlines}
    ab bsol \begin{solutionorbox}[2in]<cr><cr>\end{solutionorbox}
  elseif(&ft == 'vim')
    nnoremap K :execute 'help ' . expand('<cword>')<cr>
  endif
endfunction

autocmd BufEnter * call LanguageSetup()

" --- File and filetype specific settings
let php_sql_query = 1
let php_htmlInStrings = 1

autocmd BufRead,BufNewFile README setlocal filetype=markdown
autocmd FileType gitcommit setlocal spell tw=72 wrap linebreak
autocmd FileType markdown setlocal spell
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" --- Twitter settings
autocmd BufEnter *.workflow setlocal ft=json
autocmd BufEnter *.aurora setlocal ft=python

" --- Random hacks
" automatically commit and push changes within the personal directory when I leave a file within it
autocmd QuitPre ~/personal/* :Git commit -a -m 'personal: automatic update' | Git push

" print date and underline
inoremap <expr> <leader>d strftime('%A, %B %d, %Y') . '<esc>YpVr-$a<cr>'

" load vimrc on save
augroup vimrc
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" return to the same line when you reopen a file
augroup line_return
  autocmd!
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line('$') |
      \     execute 'normal! g`"zvzz' |
      \ endif
augroup END

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" automatically delete all trailing whitespace and newlines at end of file on save
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e
