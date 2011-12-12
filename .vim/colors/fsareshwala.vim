hi clear
set background=dark

if exists("syntax_on")
        syntax reset
endif

let g:colors_name = "fsareshwala"

"color settings for these terminal types:
"Black          term=NONE cterm=NONE ctermfg=0 ctermbg=0
"DarkRed        term=NONE cterm=NONE ctermfg=1 ctermbg=0
"DarkGreen      term=NONE cterm=NONE ctermfg=2 ctermbg=0
"Brown          term=NONE cterm=NONE ctermfg=3 ctermbg=0
"DarkBlue       term=NONE cterm=NONE ctermfg=4 ctermbg=0
"DarkMagenta    term=NONE cterm=NONE ctermfg=5 ctermbg=0
"DarkCyan       term=NONE cterm=NONE ctermfg=6 ctermbg=0
"Gray           term=NONE cterm=NONE ctermfg=7 ctermbg=0
"DarkGray       term=NONE cterm=bold ctermfg=0 ctermbg=0
"Red            term=NONE cterm=bold ctermfg=1 ctermbg=0
"Green          term=NONE cterm=bold ctermfg=2 ctermbg=0
"Yellow         term=NONE cterm=bold ctermfg=3 ctermbg=0
"Blue           term=NONE cterm=bold ctermfg=4 ctermbg=0
"Magenta        term=NONE cterm=bold ctermfg=5 ctermbg=0
"Cyan           term=NONE cterm=bold ctermfg=6 ctermbg=0
"White          term=NONE cterm=bold ctermfg=7 ctermbg=0

hi Comment      ctermfg=Blue
hi Constant     ctermfg=Red
hi Cursor       ctermfg=Red
hi Directory    ctermfg=Cyan
hi Error        ctermfg=White           ctermbg=Red
hi ErrorMsg     ctermbg=White           ctermfg=DarkRed
hi Identifier   ctermfg=Cyan
hi Ignore       ctermfg=Black
hi IncSearch    cterm=reverse
hi LineNr       ctermfg=DarkYellow
hi ModeMsg      cterm=bold
hi MoreMsg      ctermfg=Green
hi NonText      ctermfg=DarkGreen
hi Normal       ctermbg=Black           ctermfg=Gray
hi PreProc      ctermfg=Brown
hi Question     ctermfg=Cyan
hi Search       ctermbg=Magenta         ctermfg=White
hi Special      ctermfg=Red
hi SpecialKey   ctermfg=Green
hi Statement    ctermfg=Yellow
hi StatusLine   cterm=reverse
hi StatusLineNC cterm=reverse
hi Title        ctermfg=Magenta
hi Todo         ctermfg=DarkYellow
hi Type         ctermfg=Green
hi Visual       cterm=reverse
hi WarningMsg   ctermfg=Red
