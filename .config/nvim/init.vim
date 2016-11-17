" --- Dein configuration
if &compatible
  set nocompatible
endif

set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim
call dein#begin("~/.config/nvim")
call dein#add('Shougo/dein.vim')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('tpope/vim-fugitive')
call dein#end()

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif


" --- Key mappings
map <c-h> <esc><c-w>h
map <c-j> <esc><c-w>j
map <c-k> <esc><c-w>k
map <c-l> <esc><c-w>l
map <c-o> i<cr><esc>0
map <c-p> "_cw"<esc>
map H :tabprev<cr>
map K <leader>K
map L :tabnext<cr>
map [ :cp<cr>
map ] :cn<cr>
map j gj
map k gk
nmap <silent> <f4> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nnoremap <leader>v :e  ~/.config/nvim/init.vim<CR>
nnoremap <leader>V :tabnew  ~/.config/nvim/init.vim<CR>

" --- Editor configuration
au VimResized * exe "normal! \<c-w>="
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
nnoremap * *<c-o>

set autoindent
set autoread
set autowrite
set backspace=eol,start,indent
set cindent
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
set shell=/bin/bash
set shiftwidth=4
set showmatch
set showtabline=2
set smartcase
set smartindent
set smarttab
set softtabstop=4
set tabstop=4
set textwidth=80 wrap linebreak
set title
set virtualedit+=block
set wildignore+=*/tmp/*,*cache*,*.so,*.o,*.dd,*.swp,*.zip
set wildmenu
set wildmode=list:longest,full
set wrapscan
set undodir=~/.config/nvim/tmp/undo/
set undofile

" --- Automatic commands
if has("autocmd")
    autocmd VimEnter * :NERDTreeToggle
    autocmd BufWritePost init.vim source ~/.config/nvim/init.vim
    autocmd BufRead,BufNewFile README set filetype=mkd
endif

" --- File runners for various languages
function! LangRunner()
  if(&ft=="python")
    nnoremap <leader>r :!python %<cr>
  elseif(&ft=="c")
    nnoremap <leader>r :make -j 4<cr><cr>make run<cr>
  endif
endfunction

au BufEnter * call LangRunner()


" --- Random hacks
" Return to the same line when you reopen a file
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" Text highlighter = <leader>h[1-4]
function! HiInterestingWord(n)
    " Save our location.
    normal! mz
    " Yank the current word into the z register.
    normal! "zyiw
    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n
    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)
    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'
    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)
    " Move back to our original location.
    normal! `z
endfunction

nnoremap <leader>hh :call clearmatches()<CR>:noh<CR>
nnoremap <silent> <leader>h1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>h2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>h3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>h4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>h5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>h6 :call HiInterestingWord(6)<cr>

" TODO(fsareshwala): update these colors
hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

highlight search ctermfg=white ctermbg=3423513

" MacOS vs Linux clipboard
if has("mac")
  set clipboard+=unnamed
else
  set clipboard=unnamedplus
endif
