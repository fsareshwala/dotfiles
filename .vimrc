map L :tabnext<cr>
map H :tabprev<cr>
map [ :cp<cr>
map ] :cn<cr>

set nocompatible
filetype off
execute pathogen#infect()
let g:vim_markdown_folding_disabled=1

filetype plugin indent on
colorscheme fsareshwala
set nobackup
set noswapfile
set mousehide
set ttyfast
set history=1000
set lazyredraw
set shell=/bin/bash
set matchtime=3
set autowrite
set autoread
set title
set virtualedit+=block

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Don't move on *
nnoremap * *<c-o>

set bg=dark
set autoindent
set copyindent
set preserveindent
set cindent
set smartindent
set showtabline=2
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab
set nowrap
set nostartofline
set textwidth=80 wrap linebreak
set expandtab
set comments=sl:/*,mb:\ *,elx:\ */
set formatoptions+=rn
set list
set listchars=tab:\|-,trail:~,extends:>,precedes:<
set hlsearch
set incsearch
set wrapscan
set ignorecase
set smartcase
set mouse=
set number
set ruler
set showmatch
set tags=tags
set showmode
set showcmd
set backspace=eol,start,indent
set clipboard=autoselect
set wildmenu
set wildmode=list:longest,full
set guifont=Terminus\ 8
set wildignore+=*/tmp/*,*cache*,*.so,*.o,*.dd,*.swp,*.zip
set colorcolumn=+1
set modeline
set nojoinspaces
set exrc

set nocp
syntax on
let c_space_errors = 1
let java_space_errors = 1

map <Undo> :NERDTreeMirror<cr>
let NERDTreeIgnore = ['\.d$', '\.o$', '\~$', '\.pyc$', 'tags']
let NERDTreeWinSize = 31

map <c-j> <esc><c-w>j
map <c-k> <esc><c-w>k
map <c-h> <esc><c-w>h
map <c-l> <esc><c-w>l
map <c-o> i<cr><esc>0
map <c-p> "_cw"<esc>

let g:ctrlp_map = '<leader>t'

nmap <left> :3wincmd <<cr>
nmap <right> :3wincmd ><cr>
nmap <up> :3wincmd +<cr>
nmap <down> :3wincmd -<cr>

map j gj
map k gk
map m :make -j 4<cr><cr>

function! GenerateTags()
    :silent !ctags -R --exclude=*build* .
    :silent cs reset
    :redraw!
endfunction

noremap Q <nop>
nmap <f2> :copen<cr>
nmap <f3> :NERDTreeToggle<cr>
nmap <silent> <f4> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
set pastetoggle=<F5>
nmap <F6> :TableModeToggle<cr>
nmap <f9> :call GenerateTags()<cr>
nmap <f10> :Ggrep <cword><cr>
nmap <f11> :Gdiff<cr>
nmap <f12> :Gblame w<cr>

runtime! ftplugin/man.vim
map K <leader>K

" Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
if has("autocmd")
    autocmd BufWritePost .vimrc source ~/.vimrc
    autocmd BufRead,BufNewFile *.md let g:table_mode_corner="|"
    autocmd BufRead,BufNewFile *.rst let g:table_mode_corner_corner="+"
    autocmd BufRead,BufNewFile *.rst let g:table_mode_header_fillchar="="
    autocmd BufRead,BufNewFile README set filetype=mkd
endif

" Some Linux distributions set filetype in /etc/vimrc.
" Clear filetype flags before changing runtimepath to force Vim to reload them.
if exists("g:did_load_filetypes")
    filetype off
    filetype plugin indent off
endif

set runtimepath+=$GOROOT/misc/vim " replace $GOROOT with the output of: go env GOROOT
filetype plugin indent on
syntax on

" Automatically format go files with go fmt on save
function! GoFmt()
    try
        exe "undojoin"
        exe "Fmt"
    catch
    endtry
endfunction
au FileType go au bufwritepre <buffer> call GoFmt()

" Cursorline configuration
set cursorline
hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
