
function! ingo#str#Trim( string )
    return substitute(a:string, '^\_s*\(.\{-}\)\_s*$', '\1', '')
endfunction

function! ingo#str#StartsWith( string, substring, ... )
    let l:ignorecase = (a:0 && a:1)
    if l:ignorecase
  return (strpart(a:string, 0, len(a:substring)) ==? a:substring)
    else
  return (strpart(a:string, 0, len(a:substring)) ==# a:substring)
    endif
endfunction

