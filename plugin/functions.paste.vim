" bracketed paste enhancement
if exists("g:loaded_bracketed_paste")
  finish
endif
let g:loaded_bracketed_paste = 1

let &t_ti .= "\<Esc>[?2004h"
let &t_te = "\e[?2004l" . &t_te

function! XTermPasteBegin(ret)
  set pastetoggle=<f29>
  set paste
  return a:ret
endfunction

execute "set <f28>=\<Esc>[200~"
execute "set <f29>=\<Esc>[201~"
map <expr> <f28> XTermPasteBegin("i")
imap <expr> <f28> XTermPasteBegin("")
vmap <expr> <f28> XTermPasteBegin("c")
cmap <f28> <nop>
cmap <f29> <nop>

"""""""""""""""""""""
" quickfix/location lists
" todo: navigate lists without losing focus
" toggle either qf list or loc list

let g:the_primeagen_qf_l = 0
let g:the_primeagen_qf_g = 0
fun! ToggleQFList(global)
  if a:global
    if g:the_primeagen_qf_g == 1
      let g:the_primeagen_qf_g = 0
      cclose
    else
      let g:the_primeagen_qf_g = 1
      copen
    end
  else
    if g:the_primeagen_qf_l == 1
      let g:the_primeagen_qf_l = 0
      lclose
    else
      let g:the_primeagen_qf_l = 1
      lopen
    end
  endif
endfun

" We can set an autocomand that will be called each time a quickfix window will be created and update there our variables.
augroup locallist
    autocmd!
    " Populate locallist with lsp diagnostics automatically
    autocmd User LspDiagnosticsChanged :lua vim.lsp.diagnostic.set_loclist({open_loclist = false})
augroup END

" Et voila! We have 2 use cases when we can populate QuickFix lists and we have 2 cool shortcuts to quickly open and close those windows. Well… the ToggleQFList presents a problem, if you open any of the QuickFix lists using another command rather than calling our function the variables g:the_primeagen_qf_l and g:the_primeagen_qf_g will not be updated. To fix that behavior we will use again autocomands!
" We can set an autocomand that will be called each time a quickfix window will be created and update there our variables.
augroup fixlist
  autocmd!
  autocmd BufWinEnter quickfix call SetQFControlVariable()
  autocmd BufWinLeave * call UnsetQFControlVariable()
augroup END

" We do the same when leaving a window to unset the variable, but for any reason, we need to use * instead of quicxfix when using BufWinLeave.
" The functions that control now g:the_primeagen_qf_l and g:the_primeagen_qf_g are SetQFControlVariable() and UnsetQFControlVariable(). Those functions check the current vim window type and set our control variables as needed.
fun! SetQFControlVariable()
  if getwininfo(win_getid())[0]['loclist'] == 1
    let g:the_primeagen_qf_l = 1
  else
    let g:the_primeagen_qf_g = 1
  end
endfun

fun! UnsetQFControlVariable()
  if getwininfo(win_getid())[0]['loclist'] == 1
    let g:the_primeagen_qf_l = 0
  else
    let g:the_primeagen_qf_g = 0
  end
endfun

" Now the ToggleQFList do not need to control the window only call cclose,
" ccopen, lclose or lopen when we call it, so finally ToggleQFList looks like this:
fun! ToggleQFList(global)
  if a:global
    if g:the_primeagen_qf_g == 1
      cclose
    else
      copen
    end
  else
    echo 'toggle locallist'
    if g:the_primeagen_qf_l == 1
      lclose
    else
      lopen
    end
  endif
endfun
