" PSL (Percent Substitution Language) syntax highlighting for spidercode
" Sources the same PSL patterns used in HTML

if exists('b:psl_syntax_loaded')
  finish
endif
let b:psl_syntax_loaded = 1

" Literal MULTILINE directive - must be on its own line
syntax match pslMultiline /^%MULTILINE%$/

" Directive tokens (typically at line start, can be chained)
" pslNegative: %!variable!%
syntax match pslNegative /%![^!]\+!%/

" pslPositive: %?variable?%
syntax match pslPositive /%?[^?]\+?%/

" pslImport: %import path%
syntax match pslImport /%import [^%]\+%/

" pslVariable: %variable% - general variable substitution
syntax match pslVariable /%[a-zA-Z_][a-zA-Z0-9_]*%/

" Define highlight groups with sensible defaults
highlight default pslMultiline  guifg=#b48ead ctermfg=139
highlight default pslNegative   guifg=#bf616a ctermfg=131
highlight default pslPositive   guifg=#a3be8c ctermfg=144
highlight default pslImport     guifg=#81a1c1 ctermfg=109
highlight default pslVariable   guifg=#ebcb8b ctermfg=222
