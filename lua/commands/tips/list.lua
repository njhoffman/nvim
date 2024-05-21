-- http://eriklievaart.com/cheat/applications/vim/vimquickfix.html

local nl = '\n   ➜ '

local M = {}
-- assign ctrl-alt-bksp to restart x server
-- setxkbmap -option terminate:ctrl_alt_bksp

M.autopairs = {
  {
    'Jump to end or out of pairs with tabout',
    '`(f*oo)  <tab>  (foo*)`',
    '`(f*oo)  <c-tab>  (foo)*` (hpout)',
  },
  {
    'Fast warp input char to the next end pair',
    '`(*){}  <c-.>  ({}*)` (nocursormove=false)',
    "`(*){}  <c-'>  (*{})` (ncursormove=true)",
  },
  {
    'Fly (hop) to list of end-pairs',
    '`({[*] })  )  ({[] })*` (only_jump_end_pair=true)',
    '`*()  )  ()*`           (only_jump_end_pair=false)',
  },
  { 'Automatically wrap surround pairs', "`*'a`  (  `(*'a)`" },
}

M.insert = {
  { 'To do a one-off normal command while in insert mode: ', '`<ctrl+o>(motion) i.e. <ctrl+o>w`' },
  { 'To jump to begining of line in insert mode:', '`<ctrl+[o][$]`' },
  { 'Jump over word while staying in insert mode:', '<ctrl>+f' },
  { 'insert char by decimal value', '`<ctrl-v>{n}`' },
  { 'insert unicode char by decimal value', '`<ctrl-v>u{n}`' },
  { 'delete a word backwards', '`<ctrl-w>`' },
  { 'execute one NORMAL mode command (see below note)', '`<ctrl-o>{cmd}`' },
}

M.debug = {
  { 'To quickly output a lua function/variable', '`:lua =vim.diagnostic.config()`' },
  {
    'Verbosity levels',
    '`1: Lua assignments to options, mappings, etc`',
    '`2: When a file is ":source"d, or |shada| file is read or written`',
    '`3: UI info, terminal capabilities`',
    '`4: Shell commands`',
    '`5: Every searched tags file and include file`',
    '`8: Files for which a group of autocommands is executed`',
    '`9: Executed autocommands`',
    '`11: Finding items in a path`',
    '`12: Vimscript function calls`',
    '`13: When an exception is thrown, caught, finished, or discarded`',
    '`14: Anything pending in a ":finally" clause`',
    '`15: Ex commands from a script (truncated at 200 characters)`',
    '`16: Ex commands`',
  },
  { 'To quickly track autocmd events', '`:autocmd WinScrolled * echom "scrolled"`' },
  {
    'To time and debug syntax items',
    '`syntime on`',
    '[redraw at least once Ctrl-L]',
    '`syntime report`',
  },
  {
    'To profile a vimscript with all functions (!)',
    '`:profile start /tmp/profile-vimscript.vim`',
    '`:profile! file vimscript.vim`',
    '`:source vimscript.vim | profile stop`',
  },
  {
    'Set verbosity at startup `nvim -V3report.log` or ex-command:',
    '`:set verbosefile=report.log`',
    '`:set verbose=3`',
  },
  {
    'To profile opening a file',
    '`:profile start vim-markdown.log`',
    '`:profile file * | profile func *`',
    '`:e foo.md`',
  },
}

M.misc = {
  { 'Comments: dgc dgb cgc cgb ygc ygb gcip gcO gcA gco' },
  { 'To traverse undo list:', '`[ g-  g+ ]`' },
  {
    'The "gm" motion moves horizontally by a division winwidth',
    '`local gmColumn = math.floor(fn.winwidth("%")/ 2)`',
    '`vim.opt.colorcolumn = gmColumn`',
  },
  { 'To reset the mouse or keyboard', '`xinput --list--disable/--enable`' },
  { 'To search for a character by unicode', '`/\v%u4e2d<CR>`' },
  {
    'To insert sequential numbers',
    '`:put=map(range(1,5)`',
    "`:put=map(range(1,5), 'v:val/2.0')` (increment by 0.5)",
    "`:put=join(range(1,5), ' & ')     ` (increment by 0.5)",
  },
  {
    'To replace current buffer with shell cmd output',
    '`:r !ls | wc`',
    '`:%!uniq -c | sort -nr`',
    '`:r !sort # | uniq -c | sort -nr`',
  },
  {
    'To run a vim command after a shell command use execute',
    "`:execute 'r !ls' | '[`",
    "`:execute '%!sort | uniq -c'`",
    "`:execute 'r !sort # | uniq -c'`",
  },
  -- :map  _ls  :!ls -l %:S<CR>:echo "the end"<CR>
  -- :w !name	send the current buffer as standard input to command "name"
  -- new | 0r !ls ^@ $,$d
  {
    'To use | for separator after shell command insert <NL> with <C-V>010',
    '`:r !date<NL>-join`',
    '`:r !sort # <NL> !uniq -c`?',
  },
  {
    'Output shell output to new buffer',
    '`:enew | set ft=log | r !sort #`',
  },
}
--- ranges        :5,10
-- {number}     	an absolute line number
-- .            	the current line			  *:.*
-- $            	the last line in the file		  *:$*
-- %            	equal to 1,$ (the entire file)		  *:%*
-- 't           	position of mark t (lowercase)		  *:'*
-- 'T           	position of mark T (uppercase); when the mark is in another file it cannot be used in a range
-- /{pattern}[/]	the next line where {pattern} matches	  *:/*
-- ?{pattern}[?]	the previous line where {pattern} matches *:?*
-- \/           	the next line where the previously used search matches
-- \?           	the previous line where the previously used search pattern matches
-- \&           	the next line where the previously used substitute pattern matches
--- filtering
-- *!*        !{motion}{filter}	Filter {motion} text lines through the external program {filter}.
-- *!!*       !!{filter}		Filter [count] lines through the external program {filter}.
-- *v_!*      {Visual}!{filter}	Filter the highlighted lines through the external program {filter} (for {Visual} see |Visual-mode|).
--*:range!*  :{range}![!]{filter} [!][arg] Filter {range} lines through the external program {filter}.
--            Vim replaces the optional bangs with the latest given command and appends the optional [arg].
--              When the 'R' flag is included in 'cpoptions' marks in the filtered lines are deleted, unless the
--              |:keepmarks| command is used.  Example: > :keepmarks '<,'>!sort <
--              When the number of lines after filtering is less than before, marks in the missing lines are deleted anyway.
-- *=*       ={motion}		Filter {motion} lines through the external program given with the 'equalprg' option.
--             When the 'equalprg' option is empty (this is the default), use the internal formatting function |C-indenting| and |'lisp'|.
--             But when 'indentexpr' is not empty, it will be used instead |indent-expression|.
-- *==*      ==			Filter [count] lines like with ={motion}.
-- *v_=*    {Visual}=		Filter the highlighted lines like with ={motion}.

M.quickfix = {
  { 'Populate the quickfix list with the results of a command, use `:cxpr`' },
  { 'Use the quickfix command `cope` to navigate multiple quickfix lists' },
  { 'Search current file and populate quickfix ', '`:vimgrep /re/ %:p`' },
  { 'Execute macro @a on every quickfix item ', '`:cdo! norm @a`' },
  { 'To perform search and replace on quickfix items ', '`:cdo! s/e/repl/`' },
  { 'Search recursively with grep for quickfix list ', '`:gr zsh . -R`' },
  { 'Search the files in the argument list with ## ', '`:vimgrep // ##`' },
  {
    'Other vimgrep examples',
    '`:vimgrep /git/ install.sh`',
    '`:vimgrep /apt/ **/*.sh`',
    '`:vimgrep vim.dbglog **/*.lua`',
    '`:vimgrep /"[^"]i\\+"/ ~/.*`',
  },
}

M.format = {
  { 'Quick surround word near cursor with quote', '`s-SPC-"` / `ss-"`' },
  { 'Live commands', '`Norm <keys>`', '`5Reg a`', '`G/^$/d`', '`%S/pattern/replace`' },
  { 'Subvert `(:Subvert/pat/repl)` substitutes with case pattern matches' },
  { 'To increment visually selected numbers sequentially ', '`gC-S-A>`' },
}

M.movement = {
  { 'To go to 80% of current file', '`:80%`' },
  { 'To go to 5th column of current line', '`5|`' },
  {
    'Using the tag stack stack to navigate in and out of areas quickly:',
    '`<C-]> to enter, <C-T> to exit`',
  },
  { 'Quick block navigation', '`<C-S-]>  <C-S-[>`' },
  { 'Normal jump to node', '`<C-M-J>  <C-M-K>  <C-M-H>  <C-M-L>`' },
  { 'Visual move selection', '(v)`<S-L>  <S-H>  <S-J>  <S-K>`' },
  { 'Normal move (swap) line up/down', '`<M-S-J>  <M-S-K>`' },
  { 'Normal move (swap) node', '`<C-M-S-J>  <C-M-S-K>  <C-M-S-H>/<C-M-S-L>`' },
  { 'Exchange (swap) content inside argument and parenthesis with cx ', '`cxia` ➜ `ci(`' },
  { 'Visual exchange (swap) inside function and block with X ', '`vifX` ➜ `vbX`' },
  {
    'Text objects',
    '`c = class    C = conditional f = function   ? = prompt          i = object`',
    '`b = balanced  B = block      h = git-hunk   o = block/cond/loop L = loop`',
    '`t = tag       w = word       W = WORD       x = comment         l = last textobj  n = next textobj`',
    '`% = matching  a = argument   A = attribute  s = sentence        p = paragraph     q = quote`',
  },
}

M.substitute = {
  {
    'To substitute without moving cursor:',
    "\\`:exe 'norm m\\` | %s/pattern/substitution/eg | norm g`",
  },
  { 'To substitute from current line to last line', '`:,,$s/foo`' },
  { 'Using the n flag runs the command in a sandbox with side ffects but no buffer change' },
  {
    'To append all regex matches to a register:',
    "`:let @a='' | %s/regex/\\=setreg('A', submatch(0) . '\n')/n`",
    "`:let @a='' | %s/regex/\\=setreg('A', submatch(0), 'V')/n`",
  },
  {
    'To append all regex matches to variable:',
    '`:let t=[]  | %s/regex/\\=add(t, submatch(0))[-1]/g`',
  },
  { 'To append all quoted strings to a register:', '`let @a="" | g/"\zs.*\ze"/y A`' },
  {
    'To delete parts of line that are not in quotes:',
    '`:%!grep --only-matching --extended-regexp \'".*"\'`',
  },
  {
    'The subvert command `:Subvert/pat/repl` substitutes with case pattern matches',
    '`:S/box{,es,ed,ing}/`',
    '`:S /box/aw *.txt *.html`',
    '`:%S/{,un}nec{ce,ces,e}sar{y,ily}/{}nec{es}sar{}/g`',
  },
}

M.global = {
  { 'To delete all lines that have only whitespace', '`:g^s*$/d`' },
  { 'To delete all non-matching lines', '`:v/pattern/d`', '`:g!/pattern/d`' },
  { 'Delete up to next occurence of foo', '`d/foo`' },
  { 'Display 5 lines of context for matches', '`g/pattern/z#.5|echo "=========="`' },
  { 'Copy all matches to end of file', '`:g/pattern/t$`' },
  { 'Move all matches to end of file', '`:gpattern/m$`' },
  { 'Yank all matches to register A', '`qaq:g/pattern/y A`' },
  { 'Put all matches from register A into buffer', '`:g/pattern/pu A`' },
  { 'Increment each number at start of line by one', '`:.,$g/^d/exe "normal! <CA>"`' },
  { 'Reverse lookup of first field separated by space', '`:gpattern/?^w?p`' },
  { 'Reverse lookup of spaced fields with whole record', '`:g/pattern/?^w?|+,/^[^ ]/-1`' },
  { 'Add text to end of line that begins with pattern', '`:g^pattern/s/$/mytext`' },
  { 'Delete duplicates lines', '`:g^(.*)(\\r?\\n\\1)+$/d`', '`:!uniq`' },
  { 'Run macro in register q on matching lines', '`:g/pattern/normal @q' },
  {
    'Substitute all "bads" into "nice" only for lines that contain "good" ',
    '`:ggood/s/bad/nice/g`',
  },
  { 'Comment out all lines with "console"', '`:g/console/normal I/`' },
}

M.tmux = {
  {
    'Tmux fingers',
    '(start): <ctrl>+<a>+<ctrl>+<a>',
    '(jump):  <ctrl>+<a>+[F]',
    '(yank):  <ctrl>+[mark]',
  },
  { 'Tmux swap pane shortcut', '<super>+<shift>+[,]', '<super>+<shift>+[.]', '<ctrl>+<a>+[hjkl]' },
  { 'Tmux rotate active pane with other window panes', '<super>+<shift>+n' },
  { 'Tmux rotate alternate pane with other window panes', '<super>+n' },
  { 'Tmux in copy-mode Y yanks selection and inserts it into commandline' },
  { 'Tmux to paste system clipboard', '`<crl>+a+<ctrl>+p`' },
  { 'Tmux to paste buffer: <ctrl>+a+p', ' to select buffer to paste: <ctrl>+A+P ' },
}

return M
