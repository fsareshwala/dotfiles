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
set shell=$SHELL
set shiftwidth=2
set shortmess+=c
set showmatch
set showtabline=2
set signcolumn=yes
set smartcase
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
    setlocal commentstring=//\ %s
  elseif(&ft == 'c' || &ft == 'cpp' || &ft == 'java')
    setlocal smartindent
    setlocal cindent
    setlocal cinoptions+=g0,l1,N-s,E-s,(0,ks,(s,m1,j1,J1
  elseif(&ft == 'tex')
    let b:surround_45 = '\\texttt{\r}'
    " TODO: move to snippets
    ab dsol \begin{solutionordottedlines}[1in]<cr><cr>\end{solutionordottedlines}
    ab bsol \begin{solutionorbox}[2in]<cr><cr>\end{solutionorbox}
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

if executable('rg')
  set grepprg=rg\ --vimgrep
  nnoremap <leader>g :execute "grep " . expand('<cword>') . " *"<cr>
endif

" --- Plugin installation
function! s:atwork()
  return filereadable('~/.work')
endfunction

call plug#begin('~/.config/nvim/repos')
Plug 'tpope/vim-abolish'               " {} syntax (:Abolish, :Subvert), case style change
Plug 'tpope/vim-commentary'            " motions to comment lines out
Plug 'tpope/vim-repeat'                " allow plugins to override .
Plug 'tpope/vim-sleuth'                " automatically adjust shiftwidth and expandtab
Plug 'tpope/vim-surround'              " motions to surround text with other text
Plug 'vim-scripts/a.vim'               " switch to c/c++ header file

Plug 'SirVer/ultisnips'                " automatic snippet insertion
Plug 'honza/vim-snippets'              " collection of snippets
let g:UltiSnipsExpandTrigger           = '<tab>'
let g:UltiSnipsJumpForwardTrigger      = '<tab>'
let g:UltiSnipsJumpBackwardTrigger     = '<s-tab>'

Plug 'tpope/vim-speeddating'           " ctrl-a ctrl-x on dates
autocmd VimEnter * SpeedDatingFormat %A, %B %d, %Y
autocmd VimEnter * SpeedDatingFormat %B %d, %Y

Plug 'sheerun/vim-polyglot'            " filetype plugin for various programming languages
let g:vim_markdown_conceal = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

Plug 'junegunn/vim-easy-align'         " align text on character
xnoremap ga <Plug>(EasyAlign)

Plug 'vimwiki/vimwiki'                 " personal wiki on vim
let g:vimwiki_list = [{'path': '~/personal/', 'syntax': 'markdown', 'ext': '.md', 'auto_toc': 1}]
let g:vimwiki_hl_cb_checked = 2
let g:vimwiki_conceallevel = 0

Plug 'junegunn/fzf'                    " fuzzy file finder
Plug 'junegunn/fzf.vim'                " fuzzy file finder (depends on junegunn/fzf)
nnoremap <leader>e :Files<cr>

Plug 'mbbill/undotree'                 " restore files to a previous moment in time
nnoremap <leader>u :UndotreeToggle<cr>

Plug 'chaoren/vim-wordmotion'          " better word motions through long strings
let g:wordmotion_spaces = '_-.'

Plug 'FooSoft/vim-argwrap'             " toggle one argument per line
nnoremap <leader>a :ArgWrap<cr>

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

Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'} " Project drawer
autocmd VimEnter * :CHADopen
nnoremap <leader>n :CHADopen<cr>
let g:chadtree_settings = {
      \   'keymap': {
      \     'change_focus_up': ['u'],
      \     'filter': ['/'],
      \     'clear_filter': ['<esc>'],
      \     'h_split': ['i'],
      \     'v_split': ['s'],
      \   },
      \   'version_control': {
      \     'enable': 0
      \   },
      \ }

lua vim.api.nvim_set_var("chadtree_ignores", { name = {".*", ".git"} })

" install plugins incompaible wih work plugins
" if !s:atwork()
"   Plug 'neoclide/coc.nvim', {'branch': 'release'} " completion engine
"   Plug 'weirongxu/coc-explorer'        " project drawer
"
"   let g:coc_config_file='~/.config/coc/settings.json'
"   autocmd VimEnter * :CocCommand explorer --no-focus
"   autocmd BufEnter * if (winnr('$') == 1 && &filetype == 'coc-explorer') | q | endif
"
"   " Use <c-space> to trigger completion.
"   inoremap <silent><expr> <c-space> coc#refresh()
"
"   " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
"   " position. Coc only does snippet and additional edit on confirm.
"   " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
"   if exists('*complete_info')
"     inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"   else
"     inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"   endif
"
"   " Use `[g` and `]g` to navigate diagnostics
"   " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"   nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
"   nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
"
"   " GoTo code navigation.
"   nnoremap <silent> \gd <Plug>(coc-definition)
"   nnoremap <silent> \gy <Plug>(coc-type-definition)
"   nnoremap <silent> \gi <Plug>(coc-implementation)
"   nnoremap <silent> \gr <Plug>(coc-references)
"
"   " Use K to show documentation in preview window.
"   nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"   " Highlight the symbol and its references when holding the cursor.
"   autocmd CursorHold * silent call CocActionAsync('highlight')
"
"   " Symbol renaming.
"   nnoremap <leader>rn <Plug>(coc-rename)
"
"   " Apply AutoFix to problem on the current line.
"   nnoremap <leader>qf <Plug>(coc-fix-current)
"
"   " Formatting code
"   xnoremap <leader>f <Plug>(coc-format-selected)
"   nnoremap <leader>f :call CocAction('format')<cr>
"
"   " Organize imports
"   nnoremap <leader>oi :call CocAction('runCommand', 'editor.action.organizeImport')
"
"   function! s:show_documentation()
"     if (index(['vim','help'], &filetype) >= 0)
"       execute 'h '.expand('<cword>')
"     else
"       call CocAction('doHover')
"     endif
"   endfunction
"
"   augroup mygroup
"     autocmd!
"     " Setup formatexpr specified filetype(s).
"     autocmd FileType typescript,json setlocal formatexpr=CocAction('formatSelected')
"     " Update signature help on jump placeholder.
"     autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"   augroup end
" endif
call plug#end()

" load work specific vim plugins
if s:atwork()
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
nnoremap <leader>bb :w! \| !compile build <c-r>%<cr>
nnoremap <leader>bt :w! \| !compile test <c-r>%<cr>

" the following lines should always be last
colorscheme fsareshwala
filetype plugin indent on
syntax on
