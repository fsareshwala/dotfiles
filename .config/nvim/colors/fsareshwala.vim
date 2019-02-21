" Vim color file
" Based on the delek colorscheme, avoiding use of gui because I only use terminals

" vim: sw=2

hi clear
let g:colors_name = "fsareshwala"

hi DiffAdd      cterm=none                            ctermbg=lightblue
hi DiffChange   cterm=none                            ctermbg=lightmagenta
hi DiffDelete   cterm=none    ctermfg=blue            ctermbg=lightcyan
hi DiffText     cterm=bold                            ctermbg=Red
hi Directory    cterm=none    ctermfg=darkblue
hi ErrorMsg     cterm=none    ctermfg=white           ctermbg=darkred
hi FoldColumn   cterm=none    ctermfg=darkblue        ctermbg=grey
hi Folded       cterm=none    ctermfg=darkblue        ctermbg=grey
hi IncSearch    cterm=reverse
hi LineNr       cterm=none    ctermfg=brown
hi ModeMsg      cterm=bold
hi MoreMsg      cterm=none    ctermfg=darkgreen
hi NonText      cterm=none    ctermfg=blue
hi Pmenu        cterm=none
hi PmenuSel     cterm=none    ctermfg=white           ctermbg=darkblue
hi Question     cterm=none    ctermfg=darkgreen
hi Search                     ctermfg=black           ctermbg=yellow

hi SpecialKey                 ctermfg=darkblue
hi StatusLine                 ctermfg=blue            ctermbg=black
hi StatusLineNC               ctermfg=black           ctermbg=blue
hi Title                      ctermfg=darkmagenta
hi VertSplit    cterm=reverse
hi Visual       cterm=reverse                         ctermbg=none
hi WarningMsg                 ctermfg=darkred
hi WildMenu                   ctermfg=black           ctermbg=yellow

" syntax highlighting
hi Comment                    ctermfg=darkred
hi Constant                   ctermfg=magenta
hi Identifier                 ctermfg=green
hi PreProc                    ctermfg=darkred
hi Special                    ctermfg=lightred
hi Statement                  ctermfg=blue
hi Type                       ctermfg=blue
