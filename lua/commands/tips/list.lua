local nl = '\n   ➜ '
-- http://eriklievaart.com/cheat/applications/vim/vimquickfix.html

local tmux = {
  { 'Tmux fingers', '(start): <ctrl>+<a>+<ctrl>+<a>', '(jump):  <ctrl>+<a>+[F]', '(yank):  <ctrl>+[mark]' },
  { 'Tmux swap pane shortcut', '<super>+<shift>+[,]', '<super>+<shift>+[.]', '<ctrl>+<a>+[hjkl]' },
  { 'Tmux rotate active pane with other window panes', '<super>+<shift>+n' },
  { 'Tmux rotate alternate pane with other window panes', '<super>+n' },
  { 'Tmux in copy-mode Y yanks selection and inserts it into commandline' },
  { 'Tmux to paste system clipboard', '`<crl>+a+<ctrl>+p`' },
  { 'Tmux to paste buffer: <ctrl>+a+p', ' to select buffer to paste: <ctrl>+A+P ' },
}

local insert = {
  { 'To do a one-off normal command while in insert mode: ', '`<ctrl+o>(motion) i.e. <ctrl+o>w`' },
  { 'To jump to begining of line in insert mode:', '`<ctrl+[o][$]`' },
  { 'Jump over word while staying in insert mode:', '<ctrl>+f' },
  { 'insert char by decimal value', '`<ctrl-v>{n}`' },
  { 'insert unicode char by decimal value', '`<ctrl-v>u{n}`' },
  { 'delete a word backwards', '`<ctrl-w>`' },
  { 'execute one NORMAL mode command (see below note)', '`<ctrl-o>{cmd}`' },
}

local misc = {
  { 'To quickly track autocmd events', ':autocmd WinScrolled * echom "scrolled"' },
  { 'To reset the mouse or keyboard', '`xinput --list--disable/--enable`' },
  { 'To search for a character by unicode', '`/\v%u4e2d<CR>`' },
  { 'To quickly output a lua function/variable', '`:lua =vm.diagnostic.config()`' },
  {
    'To insert sequential numbers',
    '`:put=map(range(1,5)`',
    "`:put=map(range(1,5), 'v:val/2.0')` (increment by 0.5)",
    "`:put=join(range(1,5), ' & ')     ` (increment by 0.5)",
  },
}

local quickfix = {
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

local format = {
  { 'Quick surround word near cursor with quote', '`s-SPC-"` / `ss-"`' },
  { 'Live commands', '`Norm <keys>`', '`5Reg a`', '`G/^$/d`', '`%Spattern/replace`' },
  { 'Subvert `(:Subvert/pat/repl)` substitutes with case pattern matches' },
  { 'To increment visually selected numbers sequentially ', '`gC-S-A>`' },
  { 'To substitute without moving cursor:', ":exe 'norm m`' | %s/pattern/substitution/eg | norm g`" },
}

local movement = {
  { 'To go to 80% of current file', '`:80%`' },
  { 'To go to 5th column of current line', '`5|`' },
  { 'Using the tag stack stack to navigate in and out of areas quickly:', '`<C-]> to enter, <C-T> to exit`' },
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

local autopairs = {
  { 'Jump to end or out of pairs with tabout', '`(f*oo)  <tab>  (foo*)`', '`(f*oo)  <c-tab>  (foo)*` (hpout)' },
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
local global = {
  { 'To delete all lines that have only whitespace', '`:g^s*$/d`' },
  { 'To delete all non-matching lines', '`:v/pattern/d`' },
  { 'Delete upto next occurence of foo', '`d/foo`' },
  { 'Display 5 lines of context for matches', '`g/pattern/z#.5|echo "=========="`' },
  { 'Copy all matches to end of file', '`:g/pattern/t$`' },
  { 'Move all matches to end of file', '`:gpattern/m$`' },
  { 'Yank all matches to register A', '`qaq:g/pattern/y A`' },
  { 'Put all matches from register A into buffer', '`:g/pattern/pu A`' },
  { 'Increment each number at start of line by one', '`:.,$g/^d/exe "normal! <CA>"`' },
  { 'Reverse lookup of first field separated by space', '`:gpattern/?^w?p`' },
  { 'Reverse lookup of spaced fields with whole record', '`:g/pattern/?^w?|+,/^[^ ]/-1`' },
  { 'Add text to end of line that begins with pattern', '`:g^pattern/s/$/mytext`' },
  { 'Delete duplicates lines', '`:g^(.*)(\\r?\\n\\1)+$/d`' },
  { 'Run macro in register q on matching lines', '`:g/pattern/normal @q' },
  { 'Substitute all "bads" into "nice" only for lines that contain "good" ', '`:ggood/s/bad/nice/g`' },
  { 'Comment out all lines with "console"', '`:g/console/normal I/`' },
}

return {
  autopairs = autopairs,
  format = format,
  global = global,
  insert = insert,
  misc = misc,
  movement = movement,
  quickfix = quickfix,
  tmux = tmux,
}
