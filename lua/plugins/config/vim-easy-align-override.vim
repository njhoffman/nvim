
" NOTE: overriding regex key (CTRL-X -> CTRl-V)

let configPath = stdpath('config') . '/vimscripts'

source stdpath('config')/lua/plugins/config/vim-easy-align-override-lib.vim

function! s:interactive(range, modes, n, d, opts, rules, vis, bvis)
  let mode = s:shift(a:modes, 1)
  let n    = a:n
  let d    = a:d
  let ch   = ''
  let opts = s:compact_options(a:opts)
  let vals = deepcopy(s:option_values)
  let regx = 0
  let warn = ''
  let undo = 0

  while 1
    " Live preview
    let rdrw = 0
    if undo
      silent! undo
      let undo = 0
      let rdrw = 1
    endif
    if s:live && !empty(d)
      let output = s:process(a:range, mode, n, d, s:normalize_options(opts), regx, a:rules, a:bvis)
      let &undolevels = &undolevels " Break undo block
      call s:update_lines(output.todo)
      let undo = !empty(output.todo)
      let rdrw = 1
    endif
    if rdrw
      if a:vis
        normal! gv
      endif
      redraw
      if a:vis | execute "normal! \<esc>" | endif
    endif
    call s:echon(mode, n, -1, regx ? '/'.d.'/' : d, opts, warn)

    let check = 0
    let warn = ''

    try
      let c = getchar()
    catch /^Vim:Interrupt$/
      let c = 27
    endtry
    let ch = nr2char(c)
    if c == 3 || c == 27 " CTRL-C / ESC
      if undo
        silent! undo
      endif
      throw 'exit'
    elseif c == "\<bs>"
      if !empty(d)
        let d = ''
        let regx = 0
      elseif len(n) > 0
        let n = strpart(n, 0, len(n) - 1)
      endif
    elseif c == 13 " Enter key
      let mode = s:shift(a:modes, 1)
      if has_key(opts, 'a')
        let opts.a = mode . strpart(opts.a, 1)
      endif
    elseif ch == '-'
      if empty(n)      | let n = '-'
      elseif n == '-'  | let n = ''
      else             | let check = 1
      endif
    elseif ch == '*'
      if empty(n)      | let n = '*'
      elseif n == '*'  | let n = '**'
      elseif n == '**' | let n = ''
      else             | let check = 1
      endif
    elseif empty(d) && ((c == 48 && len(n) > 0) || c > 48 && c <= 57) " Numbers
      if n[0] == '*'   | let check = 1
      else             | let n = n . ch
      end
    elseif ch == "\<C-D>"
      call s:shift_opts(opts, 'da', vals['delimiter_align'])
    elseif ch == "\<C-I>"
      call s:shift_opts(opts, 'idt', vals['indentation'])
    elseif ch == "\<C-L>"
      let lm = s:input("Left margin: ", get(opts, 'lm', ''), a:vis)
      if empty(lm)
        let warn = 'Set to default. Input 0 to remove it'
        silent! call remove(opts, 'lm')
      else
        let opts['lm'] = s:atoi(lm)
      endif
    elseif ch == "\<C-R>"
      let rm = s:input("Right margin: ", get(opts, 'rm', ''), a:vis)
      if empty(rm)
        let warn = 'Set to default. Input 0 to remove it'
        silent! call remove(opts, 'rm')
      else
        let opts['rm'] = s:atoi(rm)
      endif
    elseif ch == "\<C-U>"
      call s:shift_opts(opts, 'iu', vals['ignore_unmatched'])
    elseif ch == "\<C-G>"
      call s:shift_opts(opts, 'ig', vals['ignore_groups'])
    elseif ch == "\<C-P>"
      if s:live
        if !empty(d)
          let ch = d
          break
        else
          let s:live = 0
        endif
      else
        let s:live = 1
      endif
    elseif c == "\<Left>"
      let opts['stl'] = 1
      let opts['lm']  = 0
    elseif c == "\<Right>"
      let opts['stl'] = 0
      let opts['lm']  = 1
    elseif c == "\<Down>"
      let opts['lm']  = 0
      let opts['rm']  = 0
    elseif c == "\<Up>"
      silent! call remove(opts, 'stl')
      silent! call remove(opts, 'lm')
      silent! call remove(opts, 'rm')
    elseif ch == "\<C-A>" || ch == "\<C-O>"
      let modes = tolower(s:input("Alignment ([lrc...][[*]*]): ", get(opts, 'a', mode), a:vis))
      if match(modes, '^[lrc]\+\*\{0,2}$') != -1
        let opts['a'] = modes
        let mode      = modes[0]
        while mode != s:shift(a:modes, 1)
        endwhile
      else
        silent! call remove(opts, 'a')
      endif
      " elseif ch == "\<C-_>" || ch == "\<C-X>"
    elseif ch == "\<C-V>" || ch == "\<C-X>"
      if s:live && regx && !empty(d)
        break
      endif

      let prompt = 'Regular expression: '
      let ch = s:input(prompt, '', a:vis)
      if !empty(ch) && s:valid_regexp(ch)
        let regx = 1
        let d = ch
        if !s:live | break | endif
      else
        let warn = 'Invalid regular expression: '.ch
      endif
    elseif ch == "\<C-F>"
      let f = s:input("Filter (g/../ or v/../): ", get(opts, 'f', ''), a:vis)
      let m = matchlist(f, '^[gv]/\(.\{-}\)/\?$')
      if empty(f)
        silent! call remove(opts, 'f')
      elseif !empty(m) && s:valid_regexp(m[1])
        let opts['f'] = f
      else
        let warn = 'Invalid filter expression'
      endif
    elseif ch =~ '[[:print:]]'
      let check = 1
    else
      let warn = 'Invalid character'
    endif

    if check
      if empty(d)
        if has_key(a:rules, ch)
          let d = ch
          if !s:live
            if a:vis
              execute "normal! gv\<esc>"
            endif
            break
          endif
        else
          let warn = 'Unknown delimiter key: '.ch
        endif
      else
        if regx
          let warn = 'Press <CTRL-X> to finish'
        else
          if d == ch
            break
          else
            let warn = 'Press '''.d.''' again to finish'
          endif
        end
      endif
    endif
  endwhile
  if s:live
    let copts = call('s:summarize', output.summarize)
    let s:live = 0
    let g:easy_align_last_command = s:echon('', n, regx, d, copts, '')
    let s:live = 1
  end
  return [mode, n, ch, opts, regx]
endfunction
