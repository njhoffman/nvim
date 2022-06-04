" Startuptime syntax file
" Language: startuptime
"
" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif
syntax case ignore

" 001.796  001.364: expanding arguments
syntax region startupHeaders start="^[^0-9]\+" end="$" contains=startupH1,startupH2,startupH3,startupH4
syntax match startupH1 "\(times in msec\)" nextgroup=startupH2 skipwhite contained
syntax match startupH2 "\(clock\)" nextgroup=startupH3 skipwhite contained
syntax match startupH3 "\(self+sourced\|elapsed:\)" nextgroup=startupH4 skipwhite contained
syntax match startupH4 "\(self:\|sourced script\|other lines\)\+" nextgroup=startupTimes skipwhite contained

syntax region startupTimes start="^\(\d\+[^:]\+\)" end=":" contains=startupTime
syntax match startupTime     "\([0-9,\.]\+\)"         skipwhite contained
syntax match startupClock    "^[^\s]\+"               skipwhite contained contains=startupTime nextgroup=startupElapsed
syntax match startupElapsed  "\s[^\s]\+"              skipwhite contained contains=startupTime nextgroup=startupSource
syntax match startupSource   "\s[^\s]\+"              skipwhite contained contains=startupTime

syntax region startupComment start=":" end="$" skipwhite
" syntax match startupBanner  "--- NVIM STARTED ---" contained
" syntax match startupSourcefile "sourcing\s.\*" skipwhite contained

" syntax region startupCmd start="\S" end="$" skipwhite contained keepend contains=startupPercent
" syntax match startupPercent "[^\\]%.*"lc=1 contained

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

hi! def link startupH1          Identifier
hi! def link startupH2          Number
hi! def link startupH3          Directory
hi! def link startupH4          Statement
hi! def link startupTime        startupH1
hi! def link startupClock       startupH2
hi! def link startupElapsed     PreProc
hi! def link startupBanner      Type
hi! def link startupComment     Normal
hi! def link startupSource      Comment
hi! def link startupBanner      VertSplit
hi! def link startupSourcefile  Comment

let b:current_syntax = "startup"
" vim: ts=8
