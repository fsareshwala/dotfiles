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
set linebreak
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
set nowritebackup
set nrformats+=alpha,octal
set number
set preserveindent
set pumheight=10
set shell=$SHELL
set shiftround
set shiftwidth=2
set shortmess+=c
set showmatch
set showtabline=2
set signcolumn=yes
set smartcase
set smarttab
set softtabstop=2
set spellfile+=~/.vim/spell/en.utf-8.add
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
set wrap
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
nnoremap $ g$
nnoremap 0 g0
nnoremap Q gq
nnoremap j gj
nnoremap k gk
nnoremap <silent> <leader>- :vertical resize -5<cr>
nnoremap <silent> <leader>= :vertical resize +5<cr>
nnoremap <silent> <leader>s :vsplit<cr>
nnoremap <silent> <leader>t :tabnew<cr>
nnoremap <silent> <leader>v :e  ~/.config/nvim/init.vim<cr>
nnoremap <silent> <leader>wj :e ~/personal/journal.md<cr>
nnoremap <silent> <leader>wk :e ~/personal/career/google.md<cr>
nnoremap <silent> <leader>wn :e ~/personal/career/notes.md<cr>

match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
runtime! ftplugin/man.vim
let g:tex_flavor = 'latex'
let php_sql_query = 1
let php_htmlInStrings = 1
let g:markdown_fenced_languages = ['python', 'vim', 'cpp', 'java']

function! LanguageSetup()
  if(&ft == 'c' || &ft == 'cpp' || &ft == 'java')
    setlocal smartindent
    setlocal cindent
    setlocal cinoptions+=g0,l1,N-s,E-s,(0,ks,(s,m1,j1,J1

    if(&ft == 'c' || &ft == 'cpp')
      setlocal commentstring=//\ %s
    endif
  endif
endfunction
autocmd BufEnter * call LanguageSetup()

autocmd BufRead,BufNewFile README setlocal filetype=markdown
autocmd FileType gitcommit,hgcommit setlocal spell textwidth=72
autocmd FileType markdown,vimwiki setlocal spell comments+=b:>

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

" Automatically load xresources on save
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" automatically delete all trailing whitespace and newlines at end of file on save
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e

" Use K to show documentation in preview window.
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  elseif (index(['c', 'cpp'], &filetype) >= 0)
    execute 'Man ' . expand('<cword>')
  endif
endfunction

" Copy file path
function! s:get_file_path()
  let l:homedir = expand('~')
  let l:absolute_path = expand("%")
  let l:path = substitute(l:absolute_path, l:homedir . '/', '', '')

  let l:regex_code = '^code/'
  if l:path =~ l:regex_code
    let l:path = substitute(l:path, l:regex_code, '', '')
  endif

  let @+ = l:path
endfunction

nnoremap <silent> <leader>cl :call <SID>get_file_path()<cr>
nnoremap <silent> K :call <SID>show_documentation()<cr>

if executable('rg')
  set grepprg=rg\ --vimgrep
  nnoremap <leader>g :execute "grep " . expand('<cword>') . " *"<cr>
endif

function! s:atwork() abort
  let l:hostname = substitute(system('hostname'), '\n', '', '')

  if l:hostname =~ 'fsareshwala-glaptop'
    return 1
  elseif l:hostname =~ 'fsareshwala-cloudtop'
    return 1
  endif

  return 0
endfunction

" --- Plugin installation
call plug#begin('~/.config/nvim/repos')
Plug 'chriskempson/base16-vim'         " Colorscheme
Plug 'google/vim-codefmt'              " format source code
Plug 'google/vim-glaive'               " dependency for google/vim-codefmt
Plug 'google/vim-maktaba'              " dependency for google/vim-codefmt
Plug 'jiangmiao/auto-pairs'            " automatically insert/delete parenthesis, brackets, quotes
Plug 'tpope/vim-abolish'               " {} syntax (:Abolish, :Subvert), case style change (crc)
Plug 'tpope/vim-commentary'            " motions to comment lines out
Plug 'tpope/vim-fugitive'              " git bidings
Plug 'tpope/vim-repeat'                " allow plugins to override .
Plug 'tpope/vim-sleuth'                " automatically adjust shiftwidth and expandtab
Plug 'tpope/vim-surround'              " motions to surround text with other text
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

if s:atwork()
  Plug 'fuchsia/fidl', {
        \ 'dir': '~/code/fuchsia/garnet/public/lib/fidl/tools/vim',
        \ 'frozen': 1
        \ }

  Plug 'google/emboss', {
        \ 'dir': '~/code/emboss/integration/vim/ft-emboss',
        \ 'frozen': 1
        \ }
endif

Plug 'kyazdani42/nvim-web-devicons'    " for file icons
Plug 'kyazdani42/nvim-tree.lua'        " filesystem explorer
nnoremap <leader>n :NvimTreeToggle<CR>
nnoremap <leader>l :NvimTreeFindFile<CR>

" Plug 'tpope/vim-projectionist'         " easy switching to alternate files
" let g:projectionist_heuristics = {
"       \ '*': {
"       \ '*.c': {'alternate': '{}.h'},
"       \ '*.cc': {'alternate': ['{}.h', '{}.hpp']},
"       \ '*.cpp': {'alternate': ['{}.h', '{}.hpp']},
"       \ '*.h': {'alternate': ['{}.c', '{}.cc', '{}.cpp']},
"       \ '*.hpp': {'alternate': ['{}.c', '{}.cc', '{}.cpp']},
"       \ 'java/src/*.java': {'alternate': 'java/test/{}_T.java'},
"       \ 'java/test/*_T.java': {'alternate': 'java/src/{}.java'},
"       \ '*.sqlm': {'alternate': '{}.sqlt'},
"       \ '*.sqlt': {'alternate': '{}.sqlm'},
"       \ }}

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

Plug 'junegunn/fzf'                    " fuzzy file finder (not vimscript)
Plug 'junegunn/fzf.vim'                " fuzzy file finder (depends on junegunn/fzf)
nnoremap <leader>e :Files<cr>

Plug 'chaoren/vim-wordmotion'          " better word motions through long strings
let g:wordmotion_spaces = '_-.'

" ciw - change inside word
" yi) - yank inside parenthesis
" vat - visually select around tag
" di" - delete inside double quotes
Plug 'wellle/targets.vim'              " additional text objects to operate on

" work plugins
Plug 'https://gn.googlesource.com/gn', { 'rtp': 'misc/vim' }
call plug#end()
call glaive#Install()

" nvim-tree configuration has to happen after we load all plugins
let g:nvim_tree_ignore = []
let g:nvim_tree_ignore += ['.git']
let g:nvim_tree_gitignore = 0
let g:nvim_tree_quit_on_open = 0
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_git_hl = 1
let g:nvim_tree_root_folder_modifier = ':~' " See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 0
let g:nvim_tree_group_empty = 1
let g:nvim_tree_show_icons = { 'git': 0, 'folders': 1, 'files': 1 }

" nvim-tree documentation: As options are currently being migrated,
" configuration of global options in nvim-tree-options should be done before the
" setup call.
lua << EOF
require'nvim-tree'.setup {
  auto_close      = true,
  disable_netrw   = true,
  hijack_cursor   = true,
  open_on_setup   = true,
  open_on_tab     = true,
  diagnostics = {
    enable = true,
  },
  view = {
    auto_resize = true,
    hide_dotfiles = true,
    side = 'left',
    width = 30,
  }
}
EOF

" lsp server configuration
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes

  if exists('+tagfunc')
    setlocal tagfunc=lsp#tagfunc
  endif

  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gt <plug>(lsp-definition)
  nmap <buffer> <leader>ca <plug>(lsp-code-action)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> <leader>a :LspDocumentSwitchSourceHeader<cr><cr>
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  inoremap <buffer> <expr><c-f> lsp#scroll(+4)
  inoremap <buffer> <expr><c-d> lsp#scroll(-4)

  let g:lsp_format_sync_timeout = 1000
  " autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  au!
  " call s:lsp_setup only for languages that have the server registered
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" (shared with work) automatically format code
autocmd FileType bzl AutoFormatBuffer buildifier
autocmd FileType c,cpp AutoFormatBuffer clang-format
autocmd FileType go AutoFormatBuffer gofmt
autocmd FileType sh AutoFormatBuffer shfmt

if s:atwork()
  source /usr/share/vim/google/google.vim
  source ~/code/fuchsia/scripts/vim/fuchsia.vim

  let g:gn_path = systemlist('source ~/code/fuchsia/tools/devshell/lib/vars.sh && echo $PREBUILT_GN')[0]
  execute ':Glaive codefmt gn_executable="' . g:gn_path . '"'

  autocmd FileType borg,gcl AutoFormatBuffer gclfmt
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType markdown AutoFormatBuffer mdformat
  autocmd FileType proto AutoFormatBuffer protofmt
  autocmd FileType python AutoFormatBuffer pyformat
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType textpb AutoFormatBuffer text-proto-format
  autocmd FileType sql,googlesql AutoFormatBuffer format_sql
  autocmd BufEnter *.sqlt NoAutoFormatBuffer
  autocmd FileType gn AutoFormatBuffer gn
  nnoremap <leader>f :FormatCode<cr>

  Glug codefmt-google plugin[mappings]
  Glug corpweb plugin[mappings]

  " \be: Load errors from blaze
  " \bl: View build log
  " \bd: Run blaze on targets
  " \bb: Run 'blaze build'
  " \bt: Run 'blaze test'
  Glug blaze plugin[mappings]
  let g:blazevim_quickfix_autoopen = 1

  " \d: update build files with dependencies
  "Glug blazedeps auto_filetypes=`['go']`
  Glug blazedeps plugin[mappings]

  " google specific snippets
  " https://g3doc.corp.google.com/company/editors/vim/plugins/ultisnips-google.md
  " Glug ultisnips-google
  " Glug add_usings plugin[mappings]
  " vim-lsp and cider-lsp
else
  set textwidth=100

  nnoremap <leader>bb :execute 'w! \| compile build ' . fnamemodify(expand('%'), ':.')<cr>
  nnoremap <leader>bt :execute 'w! \| compile test  ' . fnamemodify(expand('%'), ':.')<cr>
endif

" the following lines should always be last
filetype plugin indent on
syntax on

colorscheme base16-default-dark
