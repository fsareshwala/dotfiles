" Vim syntax file
" Language:     Sawzall
" Maintainer:   Tim Wintle
" Last Change:  2010 Nov 8

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syn match szlComment        "#.*$" contains=szlTodo
syn keyword szlTodo         TODO FIXME XXX contained
syn keyword szlPreCondit    include
syn keyword szlRepeat       do while
syn keyword szlConditional  if else switch when
syn keyword szlLabel        case
syn keyword szlStatement    emit
syn keyword szlComposite    of file weight some each all
syn keyword szlIdentifier   type function

"Types
syn keyword szlType         bool bytes int float time fingerprint string uint table

syn match szlNumber         "\<\d+\=\>"
syn match szlNumber         "\<\d+\.\d+\=\>"
syn region szlString        start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell
syn region szlString        start=+L\=`+ skip=+\\\\\|\\`+ end=+`+ contains=@Spell

""
"Intrinsic Functions
""
syn keyword szlIntrinsic    assert def convert format len new fingerprintof 
syn keyword szlIntrinsic    convert

" intrinsic f.p. math functions
syn keyword szlIntrinsic    ln log10 exp sqrt pow sin cos tan asin acos
syn keyword szlIntrinsic    atan atan2 cosh sinh tanh acosh asinh atanh
syn keyword szlIntrinsic    fabs ceil floor round trunk isnan isinf
syn keyword szlIntrinsic    isfinite isnormal

"more intrisics
syn keyword szlIntrinsic    max min rand abs sort sortx
syn keyword szlIntrinsic    haskey adday keys lookup
syn keyword szlIntrinsic    regex saw sawn sawzall
syn keyword szlIntrinsic    inproto inprotocount clearproto

" intrinsic date / time functions
syn keyword szlIntrinsic    addday addmonth addweek addyear dayofmonth
syn keyword szlIntrinsic    dayofweek dayofyear hourof minuteof secondof
syn keyword szlIntrinsic    yearof trunctoday trunctohour trunktominute
syn keyword szlIntrinsic    trunktomonth trunktosecond trunktoyear
syn keyword szlIntrinsic    now formattime

" instrinsic string functions
syn keyword szlIntrinsic    lowercase uppercase strfind strrfind bytesfind
syn keyword szlIntrinsic    bytesrfind strreplace match matchposns matchstrs

syn keyword szlIntrinsic    splitcsvline splitcsv format

""
"Constants / IO variables
""
syn keyword szlConstant     stdout stderr output
syn keyword szlConstant     true false PI Int inf NaN nan 
syn keyword szlConstant     SECOND SEC MINUTE MIN HOUR


if version <= 508
    command -nargs=+ HiLink hi link <args>
else
    command -nargs=+ HiLink hi def link <args>
endif

HiLink szlComment           Comment
HiLink szlPreCondit         PreCondit
HiLink szlTodo              Todo
HiLink szlConditional       Conditional
HiLink szlRepeat            Repeat
HiLink szlIntrinsic         Function
HiLink szlLabel             Label
HiLink szlType              Type
HiLink szlStatement         Statement
HiLink szlNumber            Number
HiLink szlString            String
HiLink szlConstant          Constant

HiLink szlComposite         Structure
HiLink szlIdentifier        Identifier

delcommand HiLink

let b:current_syntax = "szl"

runtime! syntax/
