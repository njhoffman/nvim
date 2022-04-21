
"clear out previous autocmds to stop them being duplicated when resourcing this file
" autocmd!

if has("termguicolors")     " set true colors
  set t_8f=\[[38;2;%lu;%lu;%lum
  set t_8b=\[[48;2;%lu;%lu;%lum
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" https://github.com/shivamashtikar/tmuxjump.vim
let g:tmuxjump_telescope = v:true

let s:file = expand("$HOME") . '/.cache/nvim/v-dump.vim'
let s:level = 20

function! Toggle_verbose()
  let l:VerboseLS = ' **** V'.'E'.'RB'.'OSE LO'.'GG'.'ING S'.'TA'.'RTED ****'
  let l:VerboseLE = ' **** V'.'E'.'RB'.'OSE LO'.'GG'.'ING E'.'ND'.'ED ****'
  let l:timestamp = strftime("%c")
  if !&verbose
    let l:msg = "\n\n" . l:timestamp . l:VerboseLS . "\n\n"
    echom "starting verbose level " . s:level  . " logs at " . l:timestamp
    let &verbosefile=s:file
    let &verbose=s:level
    echo l:msg
  else
    let l:msg = "\n" . l:timestamp . l:VerboseLE . "\n"
    echo l:msg
    set verbose=0
    set verbosefile=
    echom 'ending verbose logging at ' . l:timestamp
  endif
endfunction

command ToggleVerbose call Toggle_verbose()<cr>

function! OutputExSplitWindow(...)
  " this function output the result of the Ex command into a split scratch buffer
  let cmd = join(a:000, ' ')
  let temp_reg = @"
  redir @"
  silent! execute cmd
  redir END
  let output = copy(@")
  let @" = temp_reg
  if empty(output)
    echoerr "no output"
  else
    new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    put! =output
  endif
endfunction
command! -nargs=+ -complete=command OutputEx call OutputExSplitWindow(<f-args>)

" function! UltiSnippets_list() abort
"   if empty(UltiSnips#SnippetsInCurrentScope(1))
"     return ''
"   endif
"   let word_to_complete = matchstr(strpart(getline('.'), 0, col('.') - 1), '\S\+$')
"   let contain_word = 'stridx(v:val, word_to_complete)>=0'
"   let candidates = map(filter(keys(g:current_ulti_dict_info), contain_word),
"         \  "{
"         \      'word': v:val,
"         \      'menu': g:current_ulti_dict_info[v:val]['description'],
"         \      'dup' : 1,
"         \   }")
"   let from_where = col('.') - len(word_to_complete)
"   if !empty(candidates)
"     call complete(from_where, candidates)
"   endif
"   return ''
" endfunction
" command UltiSnippetsList call UltiSnippets_list()<cr>

" use the 'alt' program to quickly load alternate file
" Run a given vim command on the results of alt from a given path.
function! AltCommand(path, vim_command)
  let l:alternate = system("alt " . a:path)
  if empty(l:alternate)
    echo "No alternate file for " . a:path . " exists!"
  else
    exec a:vim_command . " " . l:alternate
  endif
endfunction

function! Remove_comments(code)
  return substitute(a:code, "^#[^\r]*\r\\|\r#[^\r]*", "", "g")
endfunction

function Refresh_lsp()
	lua vim.lsp.stop_client(vim.lsp.get_active_clients())
	sleep 500m
	edit
endfunction
command RefreshLSP call Refresh_lsp()

function Refresh_keys()
  let l:keyfile = stdpath('config') .. '/lua/mappings/init.lua'
  exe "silent! luafile " . l:keyfile
endfunction
command RefreshKeys call Refresh_keys()

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

" appending command output to scratch buffer :R ls -l
command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>

" paste date into buffer
nnoremap <leader>pd m'A<C-R>="\t".strftime('%Y-%m-%d %H:%M')<CR><Esc>``

let s:server_name = escape(substitute(substitute(v:servername, '\$', '', ''), '/tmp', '', ''), '\')
let s:session_restart_path = expand("$HOME") . "/.vim/sessions/restart"

function Restart()
  " save session file to <servername>_runonce to indicate a one time reload
  let l:session_path = s:session_restart_path . s:server_name . '_runonce.vim'
  exe "PackerCompile"
  exe "mksession! " . l:session_path
  " exit
  quitall
endfunction
command Restart call Restart()
command Res call Restart()

function RestartOn()
  " save session file to <servername>_always to indicate an idefinite reload cycle
  let l:session_path = s:session_restart_path . s:server_name . '_always.vim'
  exe "mksession! " . l:session_path
endfunction
command RestartOn call RestartOn()

function RestartOff()
  " remove  <servername>_always file to prevent restarting
  let l:session_path = s:session_restart_path . s:server_name . '_always.vim'
  exe "!rm " . l:session_path
endfunction
command RestartOff call RestartOff()


let s:shada_script = stdpath('config') .. '/bin/wshada.sh'

function! ShadaWrite()
  " TODO: convert to lua, whitelist filetypes
  if(getftype(@%) == "file" && &bufhidden == '')
    let l:buftype = &buftype || "<empty>"
    let l:summary = 'ShadaWrite: ' . buffer_name()  . ' : ' . &ft
    let l:summary2 = 'type: ' . l:buftype . ', listed: ' . &buflisted
    " lua vim.notify( vim.api.nvim_eval('l:summary'), 'debug', { title = 'shada' })
    " lua vim.notify({ vim.api.nvim_eval('l:summary'), vim.api.nvim_eval('l:summary2') }, 'debug', { title = 'shada' })
    exec 'silent! wshada'
    exec 'silent! !' . s:shada_script . ' ' . buffer_name()
  endif
endfunction
command ShadaWrite call ShadaWrite()

function! ShadaRead()
  " lua vim.notify('Received USR1 signal for ShadaRead', 'debug', { title = 'shada' })
  exec "silent! rshada!"
endfunction
command ShadaRead call ShadaRead()

" prevent "write partial file" nonsense
cabbrev <expr> w getcmdtype()==':' && getcmdline() == "'<,'>w" ? '<c-u>w' : 'w'


" Search prefix

function GetSnippets()
  " let l:offset = mode()[0] ==# 'i' ? 2 : 1
  " let l:before_text = getline('.')[0 : col('.') - l:offset]
  let l:before_text = ""
  let l:before_text_len = strchars(l:before_text)

  let l:sources = vsnip#get_complete_items(bufnr('%'))
  echom l:sources
endfunction
command GetSnippets call GetSnippets()

function GetLocalSnippets()
  " let l:offset = mode()[0] ==# 'i' ? 2 : 1
  " let l:before_text = getline('.')[0 : col('.') - l:offset]
  let l:before_text = ""
  let l:before_text_len = strchars(l:before_text)

  let l:sources = vsnip#source#find(bufnr('%'))
  for l:source in l:sources
    for l:snippet in l:source
      for l:prefix in l:snippet.prefix
        let l:prefix_len = strchars(l:prefix)
        echom l:snippet
        if strcharpart(l:before_text, l:before_text_len - l:prefix_len, l:prefix_len) !=# l:prefix
          continue
        endif
        if l:prefix =~# '^\h' && l:before_text !~# '\<\V' . escape(l:prefix, '\/?') . '\m$'
          continue
        endif
        " return s:create_context(l:snippet, l:before_text_len, l:prefix_len)
      endfor
    endfor
  endfor
endfunction
command GetLocalSnippets call GetLocalSnippets()


function! s:create_context(snippet, before_text_len, prefix_len) abort
  let l:line = line('.') - 1
  return {
  \   'range': {
  \     'start': {
  \       'line': l:line,
  \       'character': a:before_text_len - a:prefix_len
  \     },
  \     'end': {
  \       'line': l:line,
  \       'character': a:before_text_len
  \     }
  \   },
  \   'snippet': a:snippet
  \ }
endfunction

function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction
command -bang -nargs=? QFix call QFixToggle(<bang>0)


function! InspectMsgPack()
  exe ":new | put=v:lua.vim.inspect(msgpackparse(readfile('runtime/doc/api.mpack')))"
endfunction

function! Notify(method, kind, chunks, overwrite) abort
  echomsg a:method
  if a:kind !=# ''
    echomsg a:kind
  endif

  if empty(a:chunks)
    return
  endif
  echomsg a:chunks
  let text = join(map(copy(a:chunks), { _, val -> type(val[1]) == v:t_list ? val[1][0][1] : val[1] }), "\n")
  call luaeval('require("notify")(_A[1], "warn")', [text])
  redraw
endfunction
command -nargs=? Notify call Notify(<args>)
" set msgfunc=Notify

" remap back and forth motions: back-and-forth motions ;/:


function! DebugStart()
  lua require"osv".run_this({ log = true })
endfunction
command -nargs=? DebugStart call DebugStart(<args>)

" read pdfs by converting to text first
command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -


" https://konfekt.github.io/blog/2016/10/03/get-the-leader-right
" are consistent with f/F,t/T, (g)n/N and //?, more intuitive than ;/,.
