if exists('b:current_syntax')
  let s:current_syntax = b:current_syntax
endif

if exists('s:current_syntax')
  let b:current_syntax = s:current_syntax
endif


"" Leepfrog psl and spidercode syntax additions for html file/region

" PSL
syn clear htmlHead
syn match pslPositive '%?\w\+?%'
syn match pslNegative '%!\w\+!%'
syn match pslValue '"%\S\+%"'
syn match pslImport '%import .*$'
syn match pslMultiline '%MULTILINE%'

" SPIDERCODE
syn include @htmlJavaScript syntax/javascript.vim
syn region javascript start=+%spidercode%+ keepend end=+%spidercode%+ contains=@htmlJavaScript,htmlCssStyleComment,htmlScriptTag,@htmlPreproc

