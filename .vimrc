map X :tabnext<CR>
map Z :tabprev<CR>
map t :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase .<CR>

set nocompatible
set foldenable
set mousehide
imap jj <esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indendting and tabbing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
set textwidth=100 wrap linebreak
set expandtab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" formatting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set comments=sl:/*,mb:\ *,elx:\ */
set formatoptions+=r
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch
set incsearch
set wrapscan
set ignorecase
set smartcase

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" interactions and interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme delek
set mouse=a
set number
set ruler
set showmatch
set tags=tags
"set spell
set showmode
set showcmd
"set scrolloff=5
"set foldmethod=indent
set backspace=eol,start,indent
set clipboard+=unnamed
"set foldcolumn=3
set wildmenu
set wildmode=list:longest,full

" make vim's completion menu act more like an ide
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

set nocp
syntax on
filetype on
filetype indent on
filetype plugin on
let c_space_errors = 1
let java_space_errors = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" taglist
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F5> :TlistToggle<CR>
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick = 1
let Tlist_Process_File_Always = 1
"let Tlist_Show_One_File = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Use_Right_Window = 1
let Tlist_Display_Tag_Scope = 1
"let Tlist_Auto_Open = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F6> :NERDTreeToggle<CR>
map <Undo> :NERDTreeMirror<CR>
"let NERDChristmasTree = 1
let NERDTreeIgnore = ['\.o$', '\~$']
let NERDTreeWinSize = 31

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"OmniCppComplete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let OmniCpp_NamespaceSearch = 2             "search namespaces in the current buffer and in included files
let OmniCpp_ShowPrototypeInAbbr = 1         "display prototype in abbreviation
let OmniCpp_MayCompleteScope = 1
let OmniCpp_SelectFirstItem = 2             "select first popup item (without inserting it to the text)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap K i<CR><ESC>
call pathogen#runtime_append_all_bundles()

" Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
if has("autocmd")
    augroup myvimrchooks
        au!
        autocmd bufwritepost .vimrc source ~/.vimrc
    augroup END
endif
