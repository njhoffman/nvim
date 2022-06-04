" Vim syntax file
" Language:               Configuration File (ini file) for MSDOS/MS Windows


" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn region dosiniSection start="^\[" end="\(\n\+\[\)\@=" contains=dosiniLabel,dosiniHeader,dosiniComment keepend fold
syn region dosiniHeader   start="^\s*\[" end="\]"

setlocal foldmethod=syntax
" Following opens all folds (remove line to start with folds closed).
setlocal foldlevel=20

syn match   iniSection skipwhite contains=iniRule "^\[.\+\]$"

syn match   iniRule "^[^=:]\{-1,}="
syn match   iniRule "^[^:=]\{-1,}:"

syn match   iniComment skipwhite "^[#;].*"

" shut case off
syn case ignore

syn match  dosiniLabel    "^.\{-}\ze\s*=" nextgroup=dosiniNumber,dosiniValue
syn match  dosiniValue    "=\zs.*"
syn match  dosiniNumber   "=\zs\s*\d\+\s*$"
syn match  dosiniNumber   "=\zs\s*\d*\.\d\+\s*$"
syn match  dosiniNumber   "=\zs\s*\d\+e[+-]\=\d\+\s*$"
syn match  dosiniComment  "^[#;].*$"



syn match  dosiniComment        "^;.*$\|^#.*$"
syn match  dosiniLabel          "^\s\+ ="

syn region dosiniHereDoc matchgroup=dosiniStringStartEnd start=+<<\z(\I\i*\)+      end=+^\z1$+ contains=@dosiniInterpDQ
syn region dosiniHereDoc matchgroup=dosiniStringStartEnd start=+<<\s*"\z(.\{-}\)"+ end=+^\z1$+ contains=@dosiniInterpDQ
syn region dosiniHereDoc matchgroup=dosiniStringStartEnd start=+<<\s*'\z(.\{-}\)'+ end=+^\z1$+ contains=@dosiniInterpSQ
syn region dosiniHereDoc matchgroup=dosiniStringStartEnd start=+<<\s*""+           end=+^$+    contains=@dosiniInterpDQ,dosiniNotEmptyLine
syn region dosiniHereDoc matchgroup=dosiniStringStartEnd start=+<<\s*''+           end=+^$+    contains=@dosiniInterpSQ,dosiniNotEmptyLine

" Highlighting Settings
" ====================

hi def link iniSection Keyword
hi def link iniRule Identifier
hi def link iniComment Comment
" Define the default highlighting.
" Only when an item doesn't have highlighting yet

hi def link dosiniNumber   Number
hi def link dosiniHeader   Special
hi def link dosiniComment  Comment
hi def link dosiniLabel    Type
hi def link dosiniValue    String


" Handle heredoc syntax in the dosini syntax.
" Taken from syntax/perl.ini (:%s/perl/dosini/g).
if exists("dosini_string_as_statement")
  hi def  link dosiniStringStartEnd   dosiniStatement
else
  hi def link dosiniStringStartEnd   dosiniString
endif

hi def link dosiniHereDoc dosiniString

let b:current_syntax = "asynctasks"
