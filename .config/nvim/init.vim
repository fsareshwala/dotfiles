set nocompatible

set autoindent
set autoread
set autowriteall
set background=dark
set backspace=eol,start,indent
set clipboard+=unnamedplus
set colorcolumn=+1
set copyindent
set expandtab
set exrc
set formatoptions=cjlnqrt
set gdefault
set hlsearch
set ignorecase
set inccommand=split
set incsearch
set iskeyword+=-
set laststatus=2
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
set nowritebackup
set nrformats+=alpha,octal
set number
set preserveindent
set pumheight=10
set shell=$SHELL
set shiftwidth=2
set shortmess+=c
set showmatch
set showtabline=2
set signcolumn=yes
set smartcase
set smarttab
set softtabstop=2
set spellfile+=~/.config/nvim/spell/en.utf-8.add
set spellfile+=~/personal/vim/en.utf-8.add
set splitright
set splitright
set tabstop=2
set tags=tags;
set timeoutlen=500
set title
set undodir=~/.config/nvim/tmp/undo
set undofile
set updatetime=300
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
  if(&ft == 'c' || &ft == 'cpp' || &ft == 'java')
    setlocal smartindent
    setlocal cindent
    setlocal cinoptions+=g0,l1,N-s,E-s,(0,ks,(s,m1,j1,J1

    if(&ft == 'c' || &ft == 'cpp')
      setlocal commentstring=//\ %s
    endif
  elseif(&ft == 'tex')
    let b:surround_45 = '\\texttt{\r}'
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

" resize buffers on vim resize
autocmd VimResized * execute 'normal! \<c-w>='

" underline current line when only in normal mode
nnoremap U YpVr-

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

if executable('rg')
  set grepprg=rg\ --vimgrep
  nnoremap <leader>g :execute "grep " . expand('<cword>') . " *"<cr>
endif

" --- Plugin installation
call plug#begin('~/.config/nvim/repos')
Plug 'skywind3000/asyncrun.vim'        " Run commands asynchronously with :AsyncRun
Plug 'chriskempson/base16-vim'         " Colorscheme
Plug 'tpope/vim-abolish'               " {} syntax (:Abolish, :Subvert), case style change
Plug 'tpope/vim-commentary'            " motions to comment lines out
Plug 'tpope/vim-repeat'                " allow plugins to override .
Plug 'tpope/vim-sleuth'                " automatically adjust shiftwidth and expandtab
Plug 'tpope/vim-surround'              " motions to surround text with other text
Plug 'vim-airline/vim-airline'         " status line
Plug 'vim-airline/vim-airline-themes'  " themes for the status line

Plug 'tpope/vim-projectionist'         " easy switching to alternate files
let g:projectionist_heuristics = {
      \ '*': {
      \ '*.c': {'alternate': '{}.h'},
      \ '*.cc': {'alternate': ['{}.h', '{}.hpp']},
      \ '*.cpp': {'alternate': ['{}.h', '{}.hpp']},
      \ '*.h': {'alternate': ['{}.c', '{}.cc', '{}.cpp']},
      \ '*.hpp': {'alternate': ['{}.c', '{}.cc', '{}.cpp']},
      \ 'java/src/*.java': {'alternate': 'java/test/{}_T.java'},
      \ 'java/test/*_T.java': {'alternate': 'java/src/{}.java'},
      \ '*.sqlm': {'alternate': '{}.sqlt'},
      \ '*.sqlt': {'alternate': '{}.sqlm'},
      \ }}

Plug 'tpope/vim-speeddating'           " ctrl-a ctrl-x on dates
autocmd VimEnter * SpeedDatingFormat %A, %B %d, %Y
autocmd VimEnter * SpeedDatingFormat %B %d, %Y

Plug 'sheerun/vim-polyglot'            " filetype plugin for various programming languages
let g:vim_markdown_conceal = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

Plug 'junegunn/vim-easy-align'         " align text on character
xnoremap ga <Plug>(EasyAlign)
autocmd FileType markdown nnoremap <Bar> vip :EasyAlign*<Bar><cr>

Plug 'vimwiki/vimwiki'                 " personal wiki on vim
let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{'path': '~/personal/', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_hl_cb_checked = 2
let g:vimwiki_conceallevel = 0

Plug 'junegunn/fzf'                    " fuzzy file finder
Plug 'junegunn/fzf.vim'                " fuzzy file finder (depends on junegunn/fzf)
nnoremap <leader>e :Files<cr>

Plug 'mbbill/undotree'                 " restore files to a previous moment in time
nnoremap <leader>u :UndotreeToggle<cr>

Plug 'chaoren/vim-wordmotion'          " better word motions through long strings
let g:wordmotion_spaces = '_-.'

" ciw - change inside word
" yi) - yank inside parenthesis
" vat - visually select around tag
" di" - delete inside double quotes
Plug 'wellle/targets.vim'              " additional text objects to operate on

" [q / ]q - navigate up and down through the quickfix list, for instance through vim-grepper results
" [l / ]l - navigate up and down through the location list, for instance through neomake results
" [a / ]a - navigate backward and forward through the file list
" [<Space> / ]<Space> - add a blank line above or below the current line
" [p / ]p - linewise paste above or below the current line
Plug 'tpope/vim-unimpaired'            " complementary pairs of mappings
Plug 'ryanoasis/vim-devicons'          " filetype glyphs for various plugins

Plug 'google/vim-maktaba'              " dependency for google/vim-codefmt
Plug 'google/vim-codefmt'              " format source code
autocmd FileType bzl AutoFormatBuffer buildifier
autocmd FileType c,cpp AutoFormatBuffer clang-format
autocmd FileType go AutoFormatBuffer gofmt
autocmd FileType java AutoFormatBuffer google-java-format
autocmd FileType markdown AutoFormatBuffer mdformat
autocmd FileType proto AutoFormatBuffer protofmt
autocmd FileType python AutoFormatBuffer pyformat
autocmd FileType rust AutoFormatBuffer rustfmt
autocmd FileType sql,sqlm,sqlt,sqlp AutoFormatBuffer format_sql
autocmd FileType textpb AutoFormatBuffer text-proto-format
nnoremap <leader>f :FormatCode<cr>

Plug 'neoclide/coc.nvim', {'branch': 'release'} " completion engine
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nnoremap <silent> \gd <Plug>(coc-definition)
nnoremap <silent> \gt <Plug>(coc-type-definition)
nnoremap <silent> \gi <Plug>(coc-implementation)
nnoremap <silent> \gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<cr>

" Symbol renaming.
nnoremap <leader>rn <Plug>(coc-rename)

" Apply AutoFix to problem on the current line.
nnoremap <leader>qf <Plug>(coc-fix-current)

" Organize imports
nnoremap <leader>oi :call CocAction('runCommand', 'editor.action.organizeImport')<cr>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  elseif (index(['c', 'cpp'], &filetype) >= 0)
    execute 'Man ' . expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setlocal formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

let g:coc_global_extensions = [
\ 'coc-explorer',
\ 'coc-json',
\ 'coc-snippets',
\ 'coc-word',
\ ]

" coc-explorer configuration
nnoremap <leader>oe :CocCommand explorer --no-focus<cr>
autocmd VimEnter * :CocCommand explorer --no-focus
autocmd BufEnter * if (winnr('$') == 1 && &filetype == 'coc-explorer') | q | endif

" coc-snippets configuration
" Plug 'honza/vim-snippets'              " collection of snippets
" imap <c-l> <Plug>(coc-snippets-expand)
" vmap <c-j> <Plug>(coc-snippets-select)
" let g:coc_snippet_next = '<c-j>'
" let g:coc_snippet_prev = '<c-k>'
" imap <c-j> <Plug>(coc-snippets-expand-jump)
call plug#end()

" load work specific vim plugins
function! s:atwork()
  return filereadable(glob('~/.work'))
endfunction

if s:atwork()
  set textwidth=80 wrap linebreak
  source /usr/share/vim/google/google.vim

  " \pf: get a window of changed files
  Glug piper plugin[mappings]

  " \r: get a list of related files
  Glug relatedfiles plugin[mappings]

  " \aa: automatically add using declaration in c++ for current identifier
  Glug add_usings plugin[mappings]

  " google specific snippets -- doesn't work with coc-snippets -- need to debug
  " https://g3doc.corp.google.com/company/editors/vim/plugins/ultisnips-google.md
  " Glug ultisnips-google

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
  " vigor (interactive java debugging from within vim)
else
  set textwidth=100 wrap linebreak

  nnoremap <leader>bb :execute 'w! \| AsyncRun compile build ' . fnamemodify(expand('%'), ':.')<cr>
  nnoremap <leader>bt :execute 'w! \| AsyncRun compile test  ' . fnamemodify(expand('%'), ':.')<cr>

  " Formatting code
  xnoremap <leader>cf <Plug>(coc-format-selected)
  nnoremap <leader>cf :call CocAction('format')<cr>
endif

" the following lines should always be last
filetype plugin indent on
syntax on

colorscheme base16-default-dark
