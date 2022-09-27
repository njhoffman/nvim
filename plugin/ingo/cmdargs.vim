function! ingo#cmdargs#GetUnescapedExpr( argument )
    try
  if a:argument =~# '\\'
      " The argument contains escape characters, evaluate them.
      execute 'let l:expr = "' . substitute(a:argument, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!"', '\\"', 'g') . '"'
  else
      let l:expr = a:argument
  endif
    catch /^Vim\%((\a\+)\)\=:/
  let l:expr = a:argument
    endtry
    return l:expr
endfunction

