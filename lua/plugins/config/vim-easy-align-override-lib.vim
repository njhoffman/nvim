
let s:known_options = {
      \ 'margin_left':   [0, 1], 'margin_right':     [0, 1], 'stick_to_left':   [0],
      \ 'left_margin':   [0, 1], 'right_margin':     [0, 1], 'indentation':     [1],
      \ 'ignore_groups': [3   ], 'ignore_unmatched': [0   ], 'delimiter_align': [1],
      \ 'mode_sequence': [1   ], 'ignores':          [3],    'filter':          [1],
      \ 'align':         [1   ]
      \ }

let s:option_values = {
      \ 'indentation':      ['shallow', 'deep', 'none', 'keep', -1],
      \ 'delimiter_align':  ['left', 'center', 'right', -1],
      \ 'ignore_unmatched': [0, 1, -1],
      \ 'ignore_groups':    [[], ['String'], ['Comment'], ['String', 'Comment'], -1]
      \ }

let s:shorthand = {
      \ 'margin_left':   'lm', 'margin_right':     'rm', 'stick_to_left':   'stl',
      \ 'left_margin':   'lm', 'right_margin':     'rm', 'indentation':     'idt',
      \ 'ignore_groups': 'ig', 'ignore_unmatched': 'iu', 'delimiter_align': 'da',
      \ 'mode_sequence': 'a',  'ignores':          'ig', 'filter':          'f',
      \ 'align':         'a'
      \ }

let s:mode_labels = { 'l': '', 'r': '[R]', 'c': '[C]' }

function! s:atoi(str)
  return (a:str =~ '^[0-9]\+$') ? str2nr(a:str) : a:str
endfunction

function! s:ignored_syntax()
  if has('syntax') && exists('g:syntax_on')
    " Backward-compatibility
    return get(g:, 'easy_align_ignore_groups',
          \ get(g:, 'easy_align_ignores',
            \ (get(g:, 'easy_align_ignore_comment', 1) == 0) ?
              \ ['String'] : ['String', 'Comment']))
  else
    return []
  endif
endfunction

function! s:echon(l, n, r, d, o, warn)
  let tokens = [
        \ ['Function', s:live ? ':LiveEasyAlign' : ':EasyAlign'],
        \ ['ModeMsg', get(s:mode_labels, a:l, a:l)],
        \ ['None', ' ']]

  if a:r == -1 | call add(tokens, ['Comment', '(']) | endif
  call add(tokens, [a:n =~ '*' ? 'Repeat' : 'Number', a:n])
  call extend(tokens, a:r == 1 ?
        \ [['Delimiter', '/'], ['String', a:d], ['Delimiter', '/']] :
        \ [['Identifier', a:d == ' ' ? '\ ' : (a:d == '\' ? '\\' : a:d)]])
  if a:r == -1 | call extend(tokens, [['Normal', '_'], ['Comment', ')']]) | endif
  call add(tokens, ['Statement', empty(a:o) ? '' : ' '.string(a:o)])
  if !empty(a:warn)
    call add(tokens, ['WarningMsg', ' ('.a:warn.')'])
  endif

  call s:echon_(tokens)
  return join(map(tokens, 'v:val[1]'), '')
endfunction

function! s:process(range, mode, n, ch, opts, regexp, rules, bvis)
  let [nth, recur] = s:parse_nth((empty(a:n) && exists('g:easy_align_nth')) ? g:easy_align_nth : a:n)
  let dict = s:build_dict(a:rules, a:ch, a:regexp, a:opts)
  let [mode_sequence, recur] = s:build_mode_sequence(
    \ get(dict, 'align', recur == 2 ? s:alternating_modes(a:mode) : a:mode),
    \ recur)

  let ve = &virtualedit
  set ve=all
  let args = [
    \ {}, split(mode_sequence, '\zs'),
    \ {}, {}, a:range[0], a:range[1],
    \ a:bvis             ? min([virtcol("'<"), virtcol("'>")]) : 1,
    \ (!recur && a:bvis) ? max([virtcol("'<"), virtcol("'>")]) : 0,
    \ nth, recur, dict ]
  let &ve = ve
  while len(args) > 1
    let args = call('s:do_align', args)
  endwhile

  " todo: lines to update
  " summarize: arguments to s:summarize
  return { 'todo': args[0], 'summarize': [ a:opts, recur, mode_sequence ] }
endfunction

function! s:alternating_modes(mode)
  return a:mode ==? 'r' ? 'rl' : 'lr'
endfunction

function! s:update_lines(todo)
  for [line, content] in items(a:todo)
    call setline(line, s:rtrim(content))
  endfor
endfunction

function! s:build_mode_sequence(expr, recur)
  let [expr, recur] = [a:expr, a:recur]
  let suffix = matchstr(a:expr, '\*\+$')
  if suffix == '*'
    let expr = expr[0 : -2]
    let recur = 1
  elseif suffix == '**'
    let expr = expr[0 : -3]
    let recur = 2
  endif
  return [tolower(expr), recur]
endfunction

function! s:rtrim(str)
  return substitute(a:str, '\s\+$', '', '')
endfunction


function! s:parse_nth(n)
  let n = a:n
  let recur = 0
  if n == '*'      | let [nth, recur] = [1, 1]
  elseif n == '**' | let [nth, recur] = [1, 2]
  elseif n == '-'  | let nth = -1
  elseif empty(n)  | let nth = 1
  elseif n == '0' || ( n != '-0' && n != string(str2nr(n)) )
    call s:exit('Invalid N-th parameter: '. n)
  else
    let nth = n
  endif
  return [nth, recur]
endfunction

function! s:build_dict(delimiters, ch, regexp, opts)
  if a:regexp
    let dict = { 'pattern': a:ch }
  else
    if !has_key(a:delimiters, a:ch)
      call s:exit('Unknown delimiter key: '. a:ch)
    endif
    let dict = copy(a:delimiters[a:ch])
  endif
  call extend(dict, a:opts)

  let ml = get(dict, 'left_margin', ' ')
  let mr = get(dict, 'right_margin', ' ')
  if type(ml) == 0 | let ml = repeat(' ', ml) | endif
  if type(mr) == 0 | let mr = repeat(' ', mr) | endif
  call extend(dict, { 'ml': ml, 'mr': mr })

  let dict.pattern = get(dict, 'pattern', a:ch)
  let dict.delimiter_align =
    \ get(dict, 'delimiter_align', get(g:, 'easy_align_delimiter_align', 'r'))[0]
  let dict.indentation =
    \ get(dict, 'indentation', get(g:, 'easy_align_indentation', 'k'))[0]
  let dict.stick_to_left =
    \ get(dict, 'stick_to_left', 0)
  let dict.ignore_unmatched =
    \ get(dict, 'ignore_unmatched', get(g:, 'easy_align_ignore_unmatched', 2))
  let dict.ignore_groups =
    \ get(dict, 'ignore_groups', get(dict, 'ignores', s:ignored_syntax()))
  let dict.filter =
    \ get(dict, 'filter', '')
  return dict
endfunction


function! s:exit(msg)
  call s:echon_([['ErrorMsg', a:msg]])
  throw 'exit'
endfunction

function! s:echon_(tokens)
  " http://vim.wikia.com/wiki/How_to_print_full_screen_width_messages
  let xy = [&ruler, &showcmd]
  try
    set noruler noshowcmd

    let winlen = winwidth(winnr()) - 2
    let len = len(join(map(copy(a:tokens), 'v:val[1]'), ''))
    let ellipsis = len > winlen ? '..' : ''

    echon "\r"
    let yet = 0
    for [hl, msg] in a:tokens
      if empty(msg) | continue | endif
      execute "echohl ". hl
      let yet += len(msg)
      if yet > winlen - len(ellipsis)
        echon msg[ 0 : (winlen - len(ellipsis) - yet - 1) ] . ellipsis
        break
      else
        echon msg
      endif
    endfor
  finally
    echohl None
    let [&ruler, &showcmd] = xy
  endtry
endfunction

function! s:fuzzy_lu(key)
  if has_key(s:known_options, a:key)
    return a:key
  endif
  let key = tolower(a:key)

  " stl -> ^s.*_t.*_l.*
  let regexp1 = '^' .key[0]. '.*' .substitute(key[1 : -1], '\(.\)', '_\1.*', 'g')
  let matches = filter(keys(s:known_options), 'v:val =~ regexp1')
  if len(matches) == 1
    return matches[0]
  endif

  " stl -> ^s.*t.*l.*
  let regexp2 = '^' . substitute(substitute(key, '-', '_', 'g'), '\(.\)', '\1.*', 'g')
  let matches = filter(keys(s:known_options), 'v:val =~ regexp2')

  if empty(matches)
    call s:exit("Unknown option key: ". a:key)
  elseif len(matches) == 1
    return matches[0]
  else
    " Avoid ambiguity introduced by deprecated margin_left and margin_right
    if sort(matches) == ['margin_left', 'margin_right', 'mode_sequence']
      return 'mode_sequence'
    endif
    if sort(matches) == ['ignore_groups', 'ignores']
      return 'ignore_groups'
    endif
    call s:exit("Ambiguous option key: ". a:key ." (" .join(matches, ', '). ")")
  endif
endfunction

function! s:normalize_options(opts)
  let ret = {}
  for k in keys(a:opts)
    let v = a:opts[k]
    let k = s:fuzzy_lu(k)
    " Backward-compatibility
    if k == 'margin_left'   | let k = 'left_margin'    | endif
    if k == 'margin_right'  | let k = 'right_margin'   | endif
    if k == 'mode_sequence' | let k = 'align'          | endif
    let ret[k] = v
    unlet v
  endfor
  return s:validate_options(ret)
endfunction

function! s:shift_opts(opts, key, vals)
  let val = s:shift(a:vals, 1)
  if type(val) == 0 && val == -1
    call remove(a:opts, a:key)
  else
    let a:opts[a:key] = val
  endif
endfunction

function! s:normalize_options(opts)
  let ret = {}
  for k in keys(a:opts)
    let v = a:opts[k]
    let k = s:fuzzy_lu(k)
    " Backward-compatibility
    if k == 'margin_left'   | let k = 'left_margin'    | endif
    if k == 'margin_right'  | let k = 'right_margin'   | endif
    if k == 'mode_sequence' | let k = 'align'          | endif
    let ret[k] = v
    unlet v
  endfor
  return s:validate_options(ret)
endfunction

function! s:compact_options(opts)
  let ret = {}
  for k in keys(a:opts)
    let ret[s:shorthand[k]] = a:opts[k]
  endfor
  return ret
endfunction

function! s:validate_options(opts)
  for k in keys(a:opts)
    let v = a:opts[k]
    if index(s:known_options[k], type(v)) == -1
      call s:exit("Invalid type for option: ". k)
    endif
    unlet v
  endfor
  return a:opts
endfunction

function! s:input(str, default, vis)
  if a:vis
    normal! gv
    redraw
    execute "normal! \<esc>"
  else
    " EasyAlign command can be called without visual selection
    redraw
  endif
  let got = input(a:str, a:default)
  return got
endfunction

function! s:shift(modes, cycle)
  let item = remove(a:modes, 0)
  if a:cycle || empty(a:modes)
    call add(a:modes, item)
  endif
  return item
endfunction

function! s:valid_regexp(regexp)
  try
    call matchlist('', a:regexp)
  catch
    return 0
  endtry
  return 1
endfunction

function! s:test_regexp(regexp)
  let regexp = empty(a:regexp) ? @/ : a:regexp
  if !s:valid_regexp(regexp)
    call s:exit('Invalid regular expression: '. regexp)
  endif
  return regexp
endfunction

let s:shorthand_regex =
      \ '\s*\%('
      \   .'\(lm\?[0-9]\+\)\|\(rm\?[0-9]\+\)\|\(iu[01]\)\|\(\%(s\%(tl\)\?[01]\)\|[<>]\)\|'
      \   .'\(da\?[clr]\)\|\(\%(ms\?\|a\)[lrc*]\+\)\|\(i\%(dt\)\?[kdsn]\)\|\([gv]/.*/\)\|\(ig\[.*\]\)'
      \ .'\)\+\s*$'
