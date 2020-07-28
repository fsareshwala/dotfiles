set nocompatible

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
set listchars=tab:\|-,trail:-,extends:>,precedes:<
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
nnoremap <silent> <leader>- :vertical resize -5<cr>
nnoremap <silent> <leader>= :vertical resize +5<cr>
nnoremap <silent> <leader>s :vsplit<cr>
nnoremap <silent> <leader>v :e  ~/.config/nvim/init.vim<cr>
nnoremap <silent> <leader>wj :e ~/personal/journal.md<cr>
nnoremap <silent> <leader>wk :e ~/personal/career/google.md<cr>
nnoremap <silent> <leader>wn :e ~/personal/career/notes.md<cr>

match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
runtime! ftplugin/man.vim
let g:tex_flavor = 'latex'
let php_sql_query = 1
let php_htmlInStrings = 1

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

autocmd BufRead,BufNewFile README setlocal filetype=markdown
autocmd FileType gitcommit setlocal spell tw=72 wrap linebreak
autocmd FileType markdown,vimwiki setlocal spell comments+=b:>
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" --- improvements
" stay at current word when using star search
nnoremap * *<c-o>

" reload buffers on vim resize
autocmd VimResized * exe 'normal! \<c-w>='

" underline current line
nnoremap <leader>iu YpVr-

" print date and underline
inoremap <expr> <leader>id strftime('%A, %B %d, %Y') . '<esc>YpVr-$a<cr>'

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

" --- Plugin installation
set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim
call dein#begin('~/.config/nvim')
call dein#add('Shougo/dein.vim')

call dein#add('tpope/vim-commentary')            " motions to comment lines out
call dein#add('tpope/vim-surround.git')          " motions to surround text with other text
call dein#add('vim-scripts/a.vim')               " switch to c/c++ header file
call dein#add('tpope/vim-repeat')                " allow plugins to override .
call dein#add('nelstrom/vim-visual-star-search') " start a * or # search from a visual block
call dein#add('tpope/vim-sleuth')                " automatically adjust shiftwidth and expandtab
call dein#add('tpope/vim-abolish')               " {} syntax (:Abolish, :Subvert), case style change
call dein#add('SirVer/ultisnips')                " automatic snippet insertion
call dein#add('honza/vim-snippets')              " collection of snippets
let g:UltiSnipsExpandTrigger           = '<tab>'
let g:UltiSnipsJumpForwardTrigger      = '<tab>'
let g:UltiSnipsJumpBackwardTrigger     = '<s-tab>'

call dein#add('tpope/vim-speeddating')           " ctrl-a ctrl-x on dates
SpeedDatingFormat %A, %B %d, %Y
SpeedDatingFormat %B %d, %Y

call dein#add('sheerun/vim-polyglot')            " filetype plugin for various programming languages
let g:vim_markdown_conceal = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

call dein#add('junegunn/vim-easy-align')         " align text on character
xmap ga <Plug>(EasyAlign)

call dein#add('vimwiki/vimwiki')                 " personal wiki on vim
let g:vimwiki_list = [{'path': '~/personal/', 'syntax': 'markdown', 'ext': '.md', 'auto_toc': 1}]
let g:vimwiki_hl_cb_checked = 2
let g:vimwiki_conceallevel = 0

call dein#add('ctrlpvim/ctrlp.vim')              " open files with fuzzy filename search
let g:ctrlp_map = '<leader>e'
let g:ctrlp_working_path_mode = 'wa'
let g:ctrlp_line_prefix = '- '
nnoremap <leader>. :CtrlPTag<cr>

call dein#add('mbbill/undotree')                 " restore files to a previous moment in time
nnoremap <leader>u :UndotreeToggle<cr>

call dein#add('scrooloose/nerdtree')             " project drawer
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
nnoremap <leader>l :NERDTreeFind<cr>

call dein#add('chaoren/vim-wordmotion')          " better word motions through long strings
let g:wordmotion_spaces = '_-.'

call dein#add('FooSoft/vim-argwrap')             " toggle one argument per line
nnoremap <leader>a :ArgWrap<cr>

" ciw - change inside word
" yi) - yank inside parenthesis
" vat - visually select around tag
" di" - delete inside double quotes
call dein#add('wellle/targets.vim')              " additional text objects to operate on

" [q / ]q - navigate up and down through the quickfix list, for instance through vim-grepper results
" [l / ]l - navigate up and down through the location list, for instance through neomake results
" [a / ]a - navigate backward and forward through the file list
" [<Space> / ]<Space> - add a blank line above or below the current line
" [p / ]p - linewise paste above or below the current line
call dein#add('tpope/vim-unimpaired')            " complementary pairs of mappings
call dein#end()

if dein#check_install()
  call dein#install()
endif

" Use ag for ctrl-p plugin
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = '/usr/bin/ag %s -i --nocolor --nogroup --hidden
        \ --ignore .git
        \ --ignore .svn
        \ --ignore .hg
        \ --ignore .DS_Store
        \ --ignore "**/*.pyc"
        \ --ignore review
        \ -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" load work specific vim plugins
if isdirectory('/usr/share/vim/google')
  source /usr/share/vim/google/google.vim

  " automatically format build files with buildifier
  Glug codefmt
  Glug codefmt-google
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp AutoFormatBuffer clang-format
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType markdown AutoFormatBuffer mdformat
  autocmd FileType proto AutoFormatBuffer protofmt
  autocmd FileType python AutoFormatBuffer pyformat
  autocmd FileType sql AutoFormatBuffer format_sql
  autocmd FileType textpb AutoFormatBuffer text-proto-format
  nnoremap <leader>f :FormatCode<cr>

  " \pf: get a window of changed files
  Glug piper plugin[mappings]

  " \r: get a list of related files
  Glug relatedfiles plugin[mappings]

  " \aa: automatically add using declaration in c++ for current identifier
  Glug add_usings plugin[mappings]

  " automatic code completion inside google source code
  Glug youcompleteme-google
  let g:ycm_key_list_select_completion = ['<c-j>', '<c-n>', '<down>']
  let g:ycm_key_list_previous_completion = ['<c-k>', '<c-p>', '<up>']

  " google specific snippets
  " https://g3doc.corp.google.com/company/editors/vim/plugins/ultisnips-google.md
  Glug ultisnips-google

  " access corporate websites directly from vim
  " \cw: code search word
  " \cf: code search file
  Glug corpweb plugin[mappings]
  noremap <leader>cs :CorpWebCs<Space>

  " \be: Load errors from blaze
  " \bl: View build log
  " \bd: Run blaze on targets
  " \bb: Run 'blaze build'
  " \bt: Run 'blaze test'
  Glug blaze plugin[mappings]
  let g:blazevim_quickfix_autoopen = 1

  " \d: update build files with dependencies
  Glug blazedeps plugin[mappings]

  " \ji: create java import for class under cursor
  " \js: sort java imports
  Glug google-csimporter
  nnoremap <leader>ji :CsImporter<cr>
  nnoremap <leader>js :CsImporterSort<cr>

  " maybe install in the future
  " scampi (syntax analysis for java)
  " kythe language server (codesearch based code jumps)
  " vigor (interactive java debugging from within vim)
endif

" personal settings
nnoremap <leader>b :w! \| !compile build <c-r>%<cr>
nnoremap <leader>t :w! \| !compile test <c-r>%<cr>
nnoremap <leader>g :execute "Ggrep " . expand('<cword>') . " " . getcwd()<cr>

" the following lines should always be last
colorscheme fsareshwala
filetype plugin indent on
syntax on
