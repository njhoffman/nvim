local nl = '\n   ➜ '

--stylua: ignore
local tips_list = {
  -- http://eriklievaart.com/cheat/applications/vim/vimquickfix.html
  tmux = {
    { 'Tmux fingers', '(start): <ctrl>+<a>+<ctrl>+<a>', '(jump):  <ctrl>+<a>+[F]', '(yank):  <ctrl>+[mark]' },
    { 'Tmux swap pane shortcut', '<super>+<shift>+[,]', '<super>+<shift>+[.]', '<ctrl>+<a>+[hjkl]' },
    'Tmux rotate active pane with other window panes' .. nl .. '<super>+<shift>+n',
    'Tmux rotate alternate pane with other window panes' .. nl .. '<super>+n',
    'Tmux in copy-mode Y yanks selection and inserts it into commandline',
    'Tmux to paste system clipboard' .. nl .. '`<ctrl>+a+<ctrl>+p`',
    'Tmux to paste buffer: <ctrl>+a+p' .. nl .. ' to select buffer to paste: <ctrl>+A+P ',
  },
  insert = {
    {'To do a one-off normal command while in insert mode: ', '`<ctrl+o>(motion) i.e. <ctrl+o>w`'},
    {'To jump to begining of line in insert mode:', '`<ctrl+[o][$]`'},
    {'Jump over word while staying in insert mode:', '<ctrl>+f'},
  },
  misc = {
    'To quickly output a lua function/variable' .. nl .. '`:lua =vim.diagnostic.config()`',
    'To insert sequential numbers'
      .. nl
      .. '`:put=map(range(1,5)`'
      .. nl
      .. "`:put=map(range(1,5), 'v:val/2.0')` (increment by 0.5)"
      .. nl
      .. "`:put=join(range(1,5), ' & ')     ` (increment by 0.5)",
  },
  quickfix = {
    'Populate the quickfix list with the results of a command, use `:cexpr`',
    'Use the quickfix command `cope` to navigate multiple quickfix lists',
    'Search current file and populate quickfix '       .. nl .. '`:vimgrep /re/ %:p`',
    'Execute macro @a on every quickfix item '         .. nl .. '`:cdo! norm @a`',
    'To perform search and replace on quickfix items ' .. nl .. '`:cdo! s/re/repl/`',
    'Search recursively with grep for quickfix list '  .. nl .. '`:gr zsh . -R`',
    'Search the files in the argument list with ##'    .. nl .. '`:vimgrep // ##`',
    'Other vimgrep examples'
      .. nl
      .. '`:vimgrep /git/ install.sh`'
      .. nl
      .. '`:vimgrep /apt/ **/*.sh`'
      .. nl
      .. '`:vimgrep vim.dbglog **/*.lua`'
      .. nl
      .. '`:vimgrep /"[^"]i\\+"/ ~/.*`',
  },
  format = {
    'Quick surround word near cursor with quote' .. nl .. '`s-SPC-"` / `s-s-"`',
    'Live commands' .. nl .. '`Norm <keys>`' .. nl .. '`5Reg a`' .. nl .. '`G/^$/d`' .. nl .. '`%S/pattern/replace`',
    'Subvert `(:Subvert/pat/repl)` substitutes with case pattern matches',
    'To increment visually selected numbers sequentially ' .. nl .. '`g<C-S-A>`',
    "To substitute without moving cursor:" .. nl .. ":exe 'norm m`' | %s/pattern/substitution/eg | norm g``",

  },
  movement = {
    'Using the tag stack stack to navigate in and out of areas quickly:' .. nl .. '`<C-]> to enter, <C-T> to exit`',
    'Quick block navigation' .. nl .. '`<C-S-]>  <C-S-[>`',
    'Normal jump to node' .. nl .. '`<C-M-J>  <C-M-K>  <C-M-H>  <C-M-L>`',
    'Visual move selection' .. nl .. '(v)`<S-L>  <S-H>  <S-J>  <S-K>`',
    'Normal move (swap) line up/down' .. nl .. '`<M-S-J>  <M-S-K>`',
    'Normal move (swap) node' .. nl .. '`<C-M-S-J>  <C-M-S-K>  <C-M-S-H> / <C-M-S-L>`',
    'Exchange (swap) content inside argument and parenthesis with cx ' .. nl .. '`cxia` ➜ `cxi(`',
    'Visual exchange (swap) inside function and block with X ' .. nl .. '`vifX` ➜ `vibX`',
    'Text objects'
      .. nl
      .. '`c = class, C = conditional, f = function, ? = prompt, i = object`'
      .. nl
      .. '`b = balanced, B = block,    h = git-hunk,   o = block/cond/loop, L = loop`'
      .. nl
      .. '`t = tag,      w = word,     W = WORD,       x = comment,         l = last textobj, n = next textobj`'
      .. nl
      .. '`% = matching, a = argument, A = attribute,  s = sentence,        p = paragraph,    q = quote`',
  },
  autopairs = {
    'Jump to end or out of pairs with tabout' .. nl .. '`(f*oo)  <tab>  (foo*)`' .. nl .. '`(f*oo)  <c-tab>  (foo)*` (hopout)',
    'Fast warp input char to the next end pair' .. nl .. '`(*){}  <c-.>  ({}*)` (nocursormove=false)' .. nl .. '`(*){}  <c-\'>  (*{})` (nocursormove=true)',
    'Fly (hop) to list of end-pairs' .. nl .. '`({[*] })  )  ({[] })*` (only_jump_end_pair=true)' .. nl .. '`*()  )  ()*` (only_jump_end_pair=false)',
    'Automatically wrap surround pairs' .. nl .. '`*\'a`  (  `(*\'a\')`',
  },
  global = {
    'To delete all lines that have only whitespace' .. nl .. '`:g/^s*$/d`',
    'To delete all non-matching lines' .. nl .. '`:vg/pattern/d`',
    'Display 5 lines of context for matches' .. nl .. '`g/pattern/z#.5|echo "=========="`',
    'Copy all matches to end of file' .. nl .. '`:g/pattern/t$`',
    'Move all matches to end of file' .. nl .. '`:g/pattern/m$`',
    'Yank all matches to register A' .. nl .. '`qaq:g/pattern/y A`',
    'Put all matches from register A into buffer' .. nl .. '`:g/pattern/pu A`',
    'Increment each number at start of line by one' .. nl .. '`:.,$g/^d/exe "normal! <C-A>"`',
    'Reverse lookup of first field separated by space' .. nl .. '`:g/pattern/?^w?p`',
    'Reverse lookup of spaced fields with whole record' .. nl .. '`:g/pattern/?^w?|+,/^[^ ]/-1p`',
    'Add text to end of line that begins with pattern' .. nl .. '`:g/^pattern/s/$/mytext`',
    'Delete duplicates lines' .. nl .. '`:g/^(.*)(\\r?\\n\\1)+$/d`',
    'Run macro in register q on matching lines' .. nl .. '`:g/pattern/normal @q`',
    'Substitute all "bads" into "nice" only for lines that contain "good" ' .. nl .. '`:g/good/s/bad/nice/g`',
    'Comment out all lines with "console"' .. nl .. '`:g/console/normal I//`',
  },
}

return tips_list
-- 1
--- surround
--- - `siw)` - add (`s`) for inner word (`iw`) parenthesis (`)`).
--- - `siw?[[<CR>]]<CR>` - add (`s`) for inner word (`iw`) interactive surrounding (`?`): `[[` for left and `]]` for right.
--- - `2sdf` - delete (`sd`) second (`2`) surrounding function call (`f`).
--- - `sr)tdiv<CR>` - replace (`sr`) surrounding parenthesis (`)`) with tag (`t`) with identifier 'div' (`div<CR>` in command line prompt).
--- - `sff` - find right (`sf`) part of surrounding function call (`f`).
--- - `sh}` - highlight (`sh`) for a brief period of time surrounding curly brackets (`}`).
---
--- Extended mappings (temporary force "prev"/"next" search methods):
--- - `sdnf` - delete (`sd`) next (`n`) function call (`f`).
--- - `srlf(` - replace (`sd`) last (`l`) function call (`f`) with padded bracket (`(`).
--- - `2sfnt` - find (`sf`) second (2) next (`n`) tag (`t`).
--- - `shl}` - highlight (`sh`) last (`l`) second (`2`) curly bracket (`}`).
---
--
-- Portal
-- If I understand your question correctly, the key is to determine whether the character on the cursor is a matched delimiter.
--
-- Consider the normal mode commands v%"zy and v%%"zy.
--
-- If the cursor is on a matched delimiter, then the first command will yank a string of length at least 2—the delimiter, its pair, and any text in the middle—into @z. The second will yank a string of length exactly 1—again, the delimiter itself—into @z.
-- If the cursor is on an unmatched delimiter, then the first command will yank a string of length 1—the delimiter itself—into @z. Abort.
-- If the cursor is not on a delimiter and there is a delimiter in the line, then the second command will yank a string of length greater than 1 into @z. Abort.
-- If the cursor is not on a delimiter and there is no other delimiter in the line, then the first command will yank a string of length exactly 1—the character itself—into @z. Abort.
-- Thus, we have the following result:

-- The cursor is on a matched delimiter if and only if the normal mode command v%"zy yanks a string of length at least 2 into @z and the normal mode command v%%"zy yanks a string of length exactly 1 into @z.
--
-- Hints for VimL: :norm ... and strlen(@z) will help here.
-- cc C            " change (replace) entire line, to end of line
-- c0              " change (replace) to the start of the line
-- c$              " change (replace) to the end of the line
-- d0              " delete (cut) to the beginning of the line
-- d/pattern       " delete (cut) to first occurrence of 'pattern'
-- "_dd            " delete line into the 'blackhole' register (no clipboard)
-- nnoremap Y y$
-- xnoremap Y <Esc>y$gv
-- <ctrl-v>{n}     " insert char by decimal value
-- <ctrl-v>u{n}    " insert unicode char by decimal value
-- <ctrl-w>        " delete a word backwards
-- <ctrl-o>{cmd}   " execute one NORMAL mode command (see below note)
-- "   A neat trick to cycle through the delete registers is to use `"1p` and then run `u.`, the undo+repeat advances the 'pasted register' so it will perform `"2p`, `"3p` and so forth# .
-- nnoremap <leader>b "_
-- nnoremap <leader>d "_d
-- nnoremap <leader>D "_D
-- nnoremap <leader>dd "_dd
-- xnoremap <leader>b "_
-- xnoremap <leader>D "_D
-- xnoremap <leader>D "_D
-- xnoremap <leader>x "_x
-- o               " move to other end of marked area
-- O               " move to other corner of block
-- :g/regex/{ex}               " run :{ex} for every line matching regex
-- :g!/regex/{ex}              " run :{ex} for every line NOT matching regex
-- :v/regex/{ex}               " same as above, shortcut to `:g!`
-- :g/regex/y {reg}            " copy all matching lines to register {reg}
--                             " capitalize {reg} to append to {reg}
-- :g/regex/m $                " move all matching lines to end of file
-- :g/regex/-1j                " for every matching line, go up one line and join
-- :%s/\s\+$//e                " remove all trailing whitespaces throughout buffer
-- :g/^/m0                     " reverse order of all lines in current buffer

-- ### Search examples
-- ```
-- /^fred.*joe.*bill           line beginning with fred, followed by joe then bill
-- /^[A-J]                     line beginning A-J
-- /^[A-J][a-z]\+\s            line beginning A-J then one or more lowercase characters then space or tab
-- /fred\_.\{-}joe             fred then anything then joe (over multiple lines)
-- /fred\_s\{-}joe             fred then any whitespace (including newlines) then joe
-- /fred\|joe                  fred OR joe
-- ```vim
-- set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --hidden
-- set grepformat=%f:%l:%c:%m
-- ```
--
-- And then run the same search:
--
-- ```vim
-- " search the current file
-- :grep 'foo' %
-- " search the entire project
-- :grep 'foo'
-- :cfdo %s/foo/bar/g
-- " save all changes
-- :wall
-- - Macros are essentially just a saved series of keystrokes, if you’re recording a macro and make a mistake, don’t start over, instead, undo it and keep going normally, using macro `q` as an example (recorded with `qq`), once you’re finished with the macro, press `"qp` to paste it to an empty line, remove the mistaken keystrokes and the undo and copy it back into the `q` register with `"qy$`.
-- surroudn with multiple characters
-- (from visual mode)
-- c ``` <C-r>" ``` <Esc>
-- :%s/myUniqueQuery/prefix&suffix
-- ca'(<C-R>-) -- surroudn something in quotes in parenthesis
-- visually selected surround
--   :norm yss'
-- :.,+2norm yss<li><CR>
-- <c-v>2j$S<li>
-- cc -- alternative to dd
-- s? -- interactive

-- fly (insert) (type existing outer parenthesis to jump) ({[] })
-- tabout (map,cmap)
