
" https://github.com/shivamashtikar/tmuxjump.vim
let g:tmuxjump_telescope = v:true

function! FixFormatting()
  %s/\r\(\n\)/\1/eg
  retab
  %s/\s\+$//e
  nohlsearch
  " GetVimIndent()
endfunction

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

function! MergeTabs()
 if tabpagenr() == 1
    return
  endif
  let bufferName = bufname("%")
  if tabpagenr("$") == tabpagenr()
    close!
  else
    close!
    tabprev
  endif
  vsplit
  execute "buffer " . bufferName
endfunction

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

" prevent "write partial file" nonsense
cabbrev <expr> w getcmdtype()==':' && getcmdline() == "'<,'>w" ? '<c-u>w' : 'w'

" Search prefix
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

function! MarkdownHeaders()
    let l:filename = expand("%")
    let l:lines = getbufline('%', 0, '$')
    let l:lines = map(l:lines, {index, value -> {"lnum": index + 1, "text": value, "filename": l:filename}})
    call filter(l:lines, {_, value -> value.text =~# '^#\+ .*$'})
    call setqflist(l:lines)
    copen
endfunction
command -bang MarkdownHeaders call MarkdownHeaders()

function! InspectMsgPack()
  exe ":new | put=v:lua.vim.inspect(msgpackparse(readfile('runtime/doc/api.mpack')))"
endfunction

function! DebugStart()
  lua require"osv".run_this({ log = true })
endfunction
command -nargs=? DebugStart call DebugStart(<args>)

" read pdfs by converting to text first
command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -


fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'

endfun
" This checks that the command type is : and the command is W
" call SetupCommandAlias("W","w")


" <test-running-functions>
" Functions used to run tests in a terminal split and automatically closing
" the split if the tests are green. If they're red, jump forward to the
" word 'Failure'

function! TerminalRun(cmd)
  execute "new"
  call termopen(a:cmd, {
        \ 'on_exit': function('TerminalOnExit'),
        \ 'buf': expand('<abuf>')
        \})
  execute "normal i"
endfunction

" bats-test.docker='docker run -it -v "${PWD}:/code" bats/bats:latest test | bats-pretty'
  function! TerminalOnExit(job_id, exit_code, event) dict
    if a:exit_code == 0
      execute "bd! " . s:test_buffer_number
      wincmd =
    else
      wincmd =
    endif
  endfunction

  function! TerminalOnTermClose(buf)
    let s:test_buffer_number = a:buf
  endfunction
  " </test-running-functions>

  function! FifoRun(cmd)
    let pwd = getcwd()
    execute "silent !runner --pwd " . pwd . " --cmd '" . a:cmd . "'"
  endfunction

  function! SmartRun(cmd)
    silent! let output = system('runner --check')

    if output == "Found at least one instance running\n"
      call FifoRun(a:cmd)
    else
      call TerminalRun(a:cmd)
    endif
  endfunction

" https://konfekt.github.io/blog/2016/10/03/get-the-leader-right
" are consistent with f/F,t/T, (g)n/N and //?, more intuitive than ;/,.
