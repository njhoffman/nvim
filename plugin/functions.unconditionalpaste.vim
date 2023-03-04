if exists('g:loaded_UnconditionalPaste') || (v:version < 700)
    finish
endif
let g:loaded_UnconditionalPaste = 1

let s:save_cpo = &cpo
set cpo&vim


let g:UnconditionalPaste_Mappings =
\   [
\       ['Char', 'c', '<C-c>'], ['Inlined', 'ci', '<C-i>'], ['JustJoined', 'cg'], ['CharCondensed', 'C', '<C-c><C-c>'],
\   ]

function! s:CreateMappings()
  for l:mapping in copy(g:UnconditionalPaste_Mappings)
    let [l:pasteName, l:how] = l:mapping[0:1]
    for [l:direction, l:pasteCmd] in [['After', 'p'], ['Before', 'P']]
      let l:mappingName = 'UnconditionalPaste' . l:pasteName . l:direction
      let l:plugMappingName = '<Plug>' . l:mappingName

      " Do not create default mappings for the special paste repeats.
      let l:pasteMappingDefaultKeys = (l:how[0] == '.' ? '' : l:how . l:pasteCmd)

      if l:pasteName =~# 'Indent\|^Commented$'
        if l:pasteName ==# 'Indented'
            let l:pasteMappingDefaultKeys = ']' . l:pasteCmd
        elseif l:pasteName ==# 'MoreIndent'
            let l:pasteMappingDefaultKeys = ']]' . l:pasteCmd
        elseif l:pasteName ==# 'LessIndent'
            let l:pasteMappingDefaultKeys = '[[' . l:pasteCmd
        endif
        " This is a variant of forced linewise paste (glp) that uses ]p
        " instead of p for pasting.
        let l:pasteCmd = ']' . l:pasteCmd
      elseif l:pasteName ==# 'Expression'
        " ge / gE are built-in motions; we don't want to introduce a
        " delay there by creating mappings starting with the same " key sequence.
          let l:pasteMappingDefaultKeys = '=' . l:pasteCmd
        elseif l:pasteName ==# 'RecallExpression'
          let l:pasteMappingDefaultKeys = '==' . l:pasteCmd
        endif

        if index(['Delimited', 'Queried', 'Unjoin', 'Grep', 'InvertedGrep', 'Expression', 'Combinatorial'], l:pasteName) != -1
          " On repeat of one of the mappings that query, we want to skip
          " the query and recall the last queried separator instead.
          let l:mappingName = 'UnconditionalPasteRecall' . l:pasteName . l:direction
        elseif index(['Plus', 'GPlus'], l:pasteName) != -1
          " On repeat of the UnconditionalPastePlus/GPlus mappings, we want to
          " continue increasing with the last used (saved) offset, and at the same
          " number position (after the first paste, the cursor will have jumped to the beginning of the pasted text).
          let l:mappingName = 'UnconditionalPaste' . l:pasteName . 'Repeat' . l:direction
        endif
        execute printf('nnoremap <silent> %s :<C-u>' .
          \   'execute ''silent! call repeat#setreg("\<lt>Plug>%s", v:register)''<Bar>' .
          \   'if v:register ==# "="<Bar>' .
          \   '    call UnconditionalPaste#HandleExprReg(getreg("="))<Bar>' .
          \   'endif<Bar>' .
          \   'if ! UnconditionalPaste#Paste(v:register, "n", %s, %s)<Bar>' .
          \   '   echoerr ingo#err#Get()<Bar>' .
          \   'endif<Bar>' .
          \   'silent! call repeat#set("\<lt>Plug>%s", UnconditionalPaste#GetCount())<CR>',
          \
          \   l:plugMappingName,
          \   l:mappingName,
          \   string(l:how),
          \   string(l:pasteCmd),
          \   l:mappingName
          \)
        if ! exists('g:UnconditionalPaste_no_mappings') && ! hasmapto(l:plugMappingName, 'n') && ! empty(l:pasteMappingDefaultKeys)
          execute printf('nmap g%s %s',
            \   l:pasteMappingDefaultKeys,
            \   l:plugMappingName
            \)
        endif
    endfor
  endfor

  for [l:pasteName, l:how, l:pasteKey] in filter(copy(g:UnconditionalPaste_Mappings), '! empty(get(v:val, 2, ""))')
    let l:plugMappingName = '<Plug>UnconditionalPaste' . l:pasteName . 'I'
    " XXX: Can only use i_CTRL-R here (though I want literal insertion, not
    " as typed); i_CTRL-R_CTRL-R with the expression register cannot insert
    " newlines (^@ are inserted), and i_CTRL-R_CTRL-O inserts above the
    " current line when the register ends with a newline.
    for l:mode in ['i', 'c']
      execute printf('%snoremap <silent> %s <C-r>=UnconditionalPaste#Insert(nr2char(getchar()), %s, %s, %d)<CR>',
        \   l:mode,
        \   l:plugMappingName,
        \   string(l:mode),
        \   string(l:how),
        \   (l:mode ==# 'i')
        \)
      if ! exists('g:UnconditionalPaste_no_mappings') && ! hasmapto(l:plugMappingName, l:mode)
        execute printf('%smap <C-r>%s %s',
          \   l:mode,
          \   l:pasteKey,
          \   l:plugMappingName
          \)
      endif
    endfor
  endfor
endfunction

call s:CreateMappings()
delfunction s:CreateMappings

nmap <leader>pP <Plug>(UnconditionalPasteCharBefore)
nmap <leader>pp <Plug>(UnconditionalPasteCharAfter)

let &cpo = s:save_cpo
unlet s:save_cpo
