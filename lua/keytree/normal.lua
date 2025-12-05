return {
  number = "2.",
  name = "Normal mode",
  tag = "normal-index",
  mappings = {
    {
      tag = "",
      key = "CTRL-@",
      description = "not used",
    },
    {
      tag = "CTRL-A",
      key = "CTRL-A",
      description = "2  add N to number at/after cursor",
    },
    {
      tag = "CTRL-B",
      key = "CTRL-B",
      description = "1  scroll N screens Backwards",
    },
    {
      tag = "CTRL-C",
      key = "CTRL-C",
      description = "interrupt current (search) command",
    },
    {
      tag = "CTRL-D",
      key = "CTRL-D",
      description = "scroll Down N lines (default: half a screen)",
    },
    {
      tag = "CTRL-E",
      key = "CTRL-E",
      description = "scroll N lines upwards (N lines Extra)",
    },
    {
      tag = "CTRL-F",
      key = "CTRL-F",
      description = "1  scroll N screens Forward",
    },
    {
      tag = "CTRL-G",
      key = "CTRL-G",
      description = "display current file name and position",
    },
    {
      tag = "<BS>",
      key = "<BS>",
      description = '1  same as "h"',
    },
    {
      tag = "CTRL-H",
      key = "CTRL-H",
      description = '1  same as "h"',
    },
    {
      tag = "<Tab>",
      key = "<Tab>",
      description = "1  go to N newer entry in jump list",
    },
    {
      tag = "CTRL-I",
      key = "CTRL-I",
      description = "1  same as <Tab>",
    },
    {
      tag = "<NL>",
      key = "<NL>",
      description = '1  same as "j"',
    },
    {
      tag = "<S-NL>",
      key = "<S-NL>",
      description = "1  same as CTRL-F",
    },
    {
      tag = "CTRL-J",
      key = "CTRL-J",
      description = '1  same as "j" CTRL-K\9\9   not used',
    },
    {
      tag = "CTRL-L",
      key = "CTRL-L",
      description = "redraw screen",
    },
    {
      tag = "<CR>",
      key = "<CR>",
      description = "1  cursor to the first CHAR N lines lower",
    },
    {
      tag = "<S-CR>",
      key = "<S-CR>",
      description = "1  same as CTRL-F",
    },
    {
      tag = "CTRL-M",
      key = "CTRL-M",
      description = "1  same as <CR>",
    },
    {
      tag = "CTRL-N",
      key = "CTRL-N",
      description = '1  same as "j"',
    },
    {
      tag = "CTRL-O",
      key = "CTRL-O",
      description = "1  go to N older entry in jump list",
    },
    {
      tag = "CTRL-P",
      key = "CTRL-P",
      description = '1  same as "k" CTRL-Q\9\9   not used, or used for terminal control flow',
    },
    {
      tag = "CTRL-R",
      key = "CTRL-R",
      description = "2  redo changes which were undone with 'u' CTRL-S\9\9   not used, or used for terminal control flow",
    },
    {
      tag = "CTRL-T",
      key = "CTRL-T",
      description = "jump to N older Tag in tag list",
    },
    {
      tag = "CTRL-U",
      key = "CTRL-U",
      description = "scroll N lines Upwards (default: half a screen)",
    },
    {
      tag = "CTRL-V",
      key = "CTRL-V",
      description = "start blockwise Visual mode",
    },
    {
      tag = "CTRL-W",
      key = "CTRL-W {char}",
      description = "window commands, see |CTRL-W|",
    },
    {
      tag = "CTRL-X",
      key = "CTRL-X",
      description = "2  subtract N from number at/after cursor",
    },
    {
      tag = "CTRL-Y",
      key = "CTRL-Y",
      description = "scroll N lines downwards",
    },
    {
      tag = "CTRL-Z",
      key = "CTRL-Z",
      description = "suspend program (or start new shell) CTRL-[ <Esc>\9   not used",
    },
    {
      tag = "CTRL-\\_CTRL-N",
      key = "CTRL-\\ CTRL-N",
      description = "go to Normal mode (no-op)",
    },
    {
      tag = "CTRL-\\_CTRL-G",
      key = "CTRL-\\ CTRL-G",
      description = "go to Normal mode (no-op) CTRL-\\ a - z\9   reserved for extensions CTRL-\\ others\9   not used",
    },
    {
      tag = "CTRL-]",
      key = "CTRL-]",
      description = ":ta to ident under cursor",
    },
    {
      tag = "CTRL-^",
      key = "CTRL-^",
      description = 'edit Nth alternate file (equivalent to ":e #N")',
    },
    {
      tag = "CTRL-<Tab>",
      key = "CTRL-<Tab>",
      description = "same as `g<Tab>` : go to last accessed tab page CTRL-_\9\9   not used",
    },
    {
      tag = "<Space>",
      key = "<Space>",
      description = '1  same as "l"',
    },
    {
      tag = "!",
      key = "!{motion}{filter}",
      description = "2  filter Nmove text through the {filter} command",
    },
    {
      tag = "!!",
      key = "!!{filter}",
      description = "2  filter N lines through the {filter} command",
    },
    {
      tag = "quote",
      key = '"{register}',
      description = "use {register} for next delete, yank or put ({.%#:} only work with put)",
    },
    {
      tag = "#",
      key = "#",
      description = "1  search backward for the Nth occurrence of the ident under the cursor",
    },
    {
      tag = "$",
      key = "$",
      description = "1  cursor to the end of Nth next line",
    },
    {
      tag = "%",
      key = "%",
      description = "1  find the next (curly/square) bracket on this line and go to its match, or go to matching comment bracket, or go to matching preprocessor directive.",
    },
    {
      tag = "N%",
      key = "{count}%",
      description = "1  go to N percentage in the file",
    },
    {
      tag = "&",
      key = "&",
      description = "2  repeat last :s",
    },
    {
      tag = "'",
      key = "'{a-zA-Z0-9}",
      description = "1  cursor to the first CHAR on the line with mark {a-zA-Z0-9}",
    },
    {
      tag = "''",
      key = "''",
      description = "1  cursor to the first CHAR of the line where the cursor was before the latest jump.",
    },
    {
      tag = "'(",
      key = "'(",
      description = "1  cursor to the first CHAR on the line of the start of the current sentence",
    },
    {
      tag = "')",
      key = "')",
      description = "1  cursor to the first CHAR on the line of the end of the current sentence",
    },
    {
      tag = "'<",
      key = "'<",
      description = "1  cursor to the first CHAR of the line where highlighted area starts/started in the current buffer.",
    },
    {
      tag = "'>",
      key = "'>",
      description = "1  cursor to the first CHAR of the line where highlighted area ends/ended in the current buffer.",
    },
    {
      tag = "'[",
      key = "'[",
      description = "1  cursor to the first CHAR on the line of the start of last operated text or start of put text",
    },
    {
      tag = "']",
      key = "']",
      description = "1  cursor to the first CHAR on the line of the end of last operated text or end of put text",
    },
    {
      tag = "'{",
      key = "'{",
      description = "1  cursor to the first CHAR on the line of the start of the current paragraph",
    },
    {
      tag = "'}",
      key = "'}",
      description = "1  cursor to the first CHAR on the line of the end of the current paragraph",
    },
    {
      tag = "(",
      key = "(",
      description = "1  cursor N sentences backward",
    },
    {
      tag = ")",
      key = ")",
      description = "1  cursor N sentences forward",
    },
    {
      tag = "star",
      key = "*",
      description = "1  search forward for the Nth occurrence of the ident under the cursor",
    },
    {
      tag = "+",
      key = "+",
      description = "1  same as <CR>",
    },
    {
      tag = "<S-Plus>",
      key = "<S-+>",
      description = "1  same as CTRL-F",
    },
    {
      tag = ",",
      key = ",",
      description = "1  repeat latest f, t, F or T in opposite direction N times",
    },
    {
      tag = "-",
      key = "-",
      description = "1  cursor to the first CHAR N lines higher",
    },
    {
      tag = "<S-Minus>",
      key = "<S-->",
      description = "1  same as CTRL-B",
    },
    {
      tag = ".",
      key = ".",
      description = "2  repeat last change with count replaced with N",
    },
    {
      tag = "/",
      key = "/{pattern}<CR>",
      description = "1  search forward for the Nth occurrence of {pattern}",
    },
    {
      tag = "/<CR>",
      key = "/<CR>",
      description = "1  search forward for {pattern} of last search",
    },
    {
      tag = "0",
      key = "0",
      description = "1  cursor to the first char of the line",
    },
    {
      tag = "count",
      key = "1",
      description = "prepend to command to give a count",
    },
    {
      tag = "count",
      key = "2",
      description = '"',
    },
    {
      tag = "count",
      key = "3",
      description = '"',
    },
    {
      tag = "count",
      key = "4",
      description = '"',
    },
    {
      tag = "count",
      key = "5",
      description = '"',
    },
    {
      tag = "count",
      key = "6",
      description = '"',
    },
    {
      tag = "count",
      key = "7",
      description = '"',
    },
    {
      tag = "count",
      key = "8",
      description = '"',
    },
    {
      tag = "count",
      key = "9",
      description = '"',
    },
    {
      tag = ":",
      key = ":",
      description = "1  start entering an Ex command",
    },
    {
      tag = "N:",
      key = "{count}:",
      description = "start entering an Ex command with range from current line to N-1 lines down",
    },
    {
      tag = ";",
      key = ";",
      description = "1  repeat latest f, t, F or T N times",
    },
    {
      tag = "<",
      key = "<{motion}",
      description = "2  shift Nmove lines one 'shiftwidth' leftwards",
    },
    {
      tag = "<<",
      key = "<<",
      description = "2  shift N lines one 'shiftwidth' leftwards",
    },
    {
      tag = "=",
      key = "={motion}",
      description = '2  filter Nmove lines through "indent"',
    },
    {
      tag = "==",
      key = "==",
      description = '2  filter N lines through "indent"',
    },
    {
      tag = ">",
      key = ">{motion}",
      description = "2  shift Nmove lines one 'shiftwidth' rightwards",
    },
    {
      tag = ">>",
      key = ">>",
      description = "2  shift N lines one 'shiftwidth' rightwards",
    },
    {
      tag = "?",
      key = "?{pattern}<CR>",
      description = "1  search backward for the Nth previous occurrence of {pattern}",
    },
    {
      tag = "?<CR>",
      key = "?<CR>",
      description = "1  search backward for {pattern} of last search",
    },
    {
      tag = "@",
      key = "@{a-z}",
      description = "2  execute the contents of register {a-z} N times",
    },
    {
      tag = "@:",
      key = "@:",
      description = 'repeat the previous ":" command N times',
    },
    {
      tag = "@@",
      key = "@@",
      description = "2  repeat the previous @{a-z} N times",
    },
    {
      tag = "A",
      key = "A",
      description = "2  append text after the end of the line N times",
    },
    {
      tag = "B",
      key = "B",
      description = "1  cursor N WORDS backward",
    },
    {
      tag = "C",
      key = '["x]C',
      description = '2  change from the cursor position to the end of the line, and N-1 more lines [into register x]; synonym for "c$"',
    },
    {
      tag = "D",
      key = '["x]D',
      description = '2  delete the characters under the cursor until the end of the line and N-1 more lines [into register x]; synonym for "d$"',
    },
    {
      tag = "E",
      key = "E",
      description = "1  cursor forward to the end of WORD N",
    },
    {
      tag = "F",
      key = "F{char}",
      description = "1  cursor to the Nth occurrence of {char} to the left",
    },
    {
      tag = "G",
      key = "G",
      description = "1  cursor to line N, default last line",
    },
    {
      tag = "H",
      key = "H",
      description = "1  cursor to line N from top of screen",
    },
    {
      tag = "I",
      key = "I",
      description = "2  insert text before the first CHAR on the line N times",
    },
    {
      tag = "J",
      key = "J",
      description = "2  Join N lines; default is 2",
    },
    {
      tag = "K",
      key = "K",
      description = "lookup Keyword under the cursor with 'keywordprg'",
    },
    {
      tag = "L",
      key = "L",
      description = "1  cursor to line N from bottom of screen",
    },
    {
      tag = "M",
      key = "M",
      description = "1  cursor to middle line of screen",
    },
    {
      tag = "N",
      key = "N",
      description = "1  repeat the latest '/' or '?' N times in opposite direction",
    },
    {
      tag = "O",
      key = "O",
      description = "2  begin a new line above the cursor and insert text, repeat N times",
    },
    {
      tag = "P",
      key = '["x]P',
      description = "2  put the text [from register x] before the cursor N times",
    },
    {
      tag = "R",
      key = "R",
      description = "2  enter replace mode: overtype existing characters, repeat the entered text N-1 times",
    },
    {
      tag = "S",
      key = '["x]S',
      description = '2  delete N lines [into register x] and start insert; synonym for "cc".',
    },
    {
      tag = "T",
      key = "T{char}",
      description = "1  cursor till after Nth occurrence of {char} to the left",
    },
    {
      tag = "U",
      key = "U",
      description = "2  undo all latest changes on one line",
    },
    {
      tag = "V",
      key = "V",
      description = "start linewise Visual mode",
    },
    {
      tag = "W",
      key = "W",
      description = "1  cursor N WORDS forward",
    },
    {
      tag = "X",
      key = '["x]X',
      description = "2  delete N characters before the cursor [into register x]",
    },
    {
      tag = "Y",
      key = '["x]Y',
      description = 'yank N lines [into register x]; synonym for "yy" Note: Mapped to "y$" by default. |default-mappings|',
    },
    {
      tag = "ZZ",
      key = "ZZ",
      description = "write if buffer changed and close window",
    },
    {
      tag = "ZQ",
      key = "ZQ",
      description = "close window without writing",
    },
    {
      tag = "[",
      key = "[{char}",
      description = "square bracket command (see |[| below) \\\9\9   not used",
    },
    {
      tag = "]",
      key = "]{char}",
      description = "square bracket command (see |]| below)",
    },
    {
      tag = "^",
      key = "^",
      description = "1  cursor to the first CHAR of the line",
    },
    {
      tag = "_",
      key = "_",
      description = "1  cursor to the first CHAR N - 1 lines lower",
    },
    {
      tag = "`",
      key = "`{a-zA-Z0-9}",
      description = "1  cursor to the mark {a-zA-Z0-9}",
    },
    {
      tag = "`(",
      key = "`(",
      description = "1  cursor to the start of the current sentence",
    },
    {
      tag = "`)",
      key = "`)",
      description = "1  cursor to the end of the current sentence",
    },
    {
      tag = "`<",
      key = "`<",
      description = "1  cursor to the start of the highlighted area",
    },
    {
      tag = "`>",
      key = "`>",
      description = "1  cursor to the end of the highlighted area",
    },
    {
      tag = "`[",
      key = "`[",
      description = "1  cursor to the start of last operated text or start of putted text",
    },
    {
      tag = "`]",
      key = "`]",
      description = "1  cursor to the end of last operated text or end of putted text",
    },
    {
      tag = "``",
      key = '"``"',
      description = "1  cursor to the position before latest jump",
    },
    {
      tag = "`{",
      key = "`{",
      description = "1  cursor to the start of the current paragraph",
    },
    {
      tag = "`}",
      key = "`}",
      description = "1  cursor to the end of the current paragraph",
    },
    {
      tag = "a",
      key = "a",
      description = "2  append text after the cursor N times",
    },
    {
      tag = "b",
      key = "b",
      description = "1  cursor N words backward",
    },
    {
      tag = "c",
      key = '["x]c{motion}',
      description = "2  delete Nmove text [into register x] and start insert",
    },
    {
      tag = "cc",
      key = '["x]cc',
      description = "2  delete N lines [into register x] and start insert",
    },
    {
      tag = "d",
      key = '["x]d{motion}',
      description = "2  delete Nmove text [into register x]",
    },
    {
      tag = "dd",
      key = '["x]dd',
      description = "2  delete N lines [into register x]",
    },
    {
      tag = "do",
      key = "do",
      description = '2  same as ":diffget"',
    },
    {
      tag = "dp",
      key = "dp",
      description = '2  same as ":diffput"',
    },
    {
      tag = "e",
      key = "e",
      description = "1  cursor forward to the end of word N",
    },
    {
      tag = "f",
      key = "f{char}",
      description = "1  cursor to Nth occurrence of {char} to the right",
    },
    {
      tag = "g",
      key = "g{char}",
      description = "extended commands, see |g| below",
    },
    {
      tag = "h",
      key = "h",
      description = "1  cursor N chars to the left",
    },
    {
      tag = "i",
      key = "i",
      description = "2  insert text before the cursor N times",
    },
    {
      tag = "j",
      key = "j",
      description = "1  cursor N lines downward",
    },
    {
      tag = "k",
      key = "k",
      description = "1  cursor N lines upward",
    },
    {
      tag = "l",
      key = "l",
      description = "1  cursor N chars to the right",
    },
    {
      tag = "m",
      key = "m{A-Za-z}",
      description = "set mark {A-Za-z} at cursor position",
    },
    {
      tag = "n",
      key = "n",
      description = "1  repeat the latest '/' or '?' N times",
    },
    {
      tag = "o",
      key = "o",
      description = "2  begin a new line below the cursor and insert text, repeat N times",
    },
    {
      tag = "p",
      key = '["x]p',
      description = "2  put the text [from register x] after the cursor N times",
    },
    {
      tag = "q",
      key = 'q{0-9a-zA-Z"}',
      description = 'record typed characters into named register {0-9a-zA-Z"} (uppercase to append)',
    },
    {
      tag = "q",
      key = "q",
      description = "(while recording) stops recording",
    },
    {
      tag = "Q",
      key = "Q",
      description = "2  replay last recorded register",
    },
    {
      tag = "q:",
      key = "q:",
      description = "edit : command-line in command-line window",
    },
    {
      tag = "q/",
      key = "q/",
      description = "edit / command-line in command-line window",
    },
    {
      tag = "q?",
      key = "q?",
      description = "edit ? command-line in command-line window",
    },
    {
      tag = "r",
      key = "r{char}",
      description = "2  replace N chars with {char}",
    },
    {
      tag = "s",
      key = '["x]s',
      description = "2  (substitute) delete N characters [into register x] and start insert",
    },
    {
      tag = "t",
      key = "t{char}",
      description = "1  cursor till before Nth occurrence of {char} to the right",
    },
    {
      tag = "u",
      key = "u",
      description = "2  undo changes",
    },
    {
      tag = "v",
      key = "v",
      description = "start charwise Visual mode",
    },
    {
      tag = "w",
      key = "w",
      description = "1  cursor N words forward",
    },
    {
      tag = "x",
      key = '["x]x',
      description = "2  delete N characters under and after the cursor [into register x]",
    },
    {
      tag = "y",
      key = '["x]y{motion}',
      description = "yank Nmove text [into register x]",
    },
    {
      tag = "yy",
      key = '["x]yy',
      description = "yank N lines [into register x]",
    },
    {
      tag = "z",
      key = "z{char}",
      description = "commands starting with 'z', see |z| below",
    },
    {
      tag = "{",
      key = "{",
      description = "1  cursor N paragraphs backward",
    },
    {
      tag = "bar",
      key = "|",
      description = "1  cursor to column N",
    },
    {
      tag = "}",
      key = "}",
      description = "1  cursor N paragraphs forward",
    },
    {
      tag = "~",
      key = "~",
      description = "2  'tildeop' off: switch case of N characters under cursor and move the cursor N characters to the right",
    },
    {
      tag = "~",
      key = "~{motion}",
      description = "'tildeop' on: switch case of Nmove text",
    },
    {
      tag = "<C-End>",
      key = "<C-End>",
      description = '1  same as "G"',
    },
    {
      tag = "<C-Home>",
      key = "<C-Home>",
      description = '1  same as "gg"',
    },
    {
      tag = "<C-Left>",
      key = "<C-Left>",
      description = '1  same as "b"',
    },
    {
      tag = "<C-LeftMouse>",
      key = "<C-LeftMouse>",
      description = '":ta" to the keyword at the mouse click',
    },
    {
      tag = "<C-Right>",
      key = "<C-Right>",
      description = '1  same as "w"',
    },
    {
      tag = "<C-RightMouse>",
      key = "<C-RightMouse>",
      description = 'same as "CTRL-T"',
    },
    {
      tag = "<C-Tab>",
      key = "<C-Tab>",
      description = 'same as "g<Tab>"',
    },
    {
      tag = "<Del>",
      key = '["x]<Del>',
      description = '2  same as "x"',
    },
    {
      tag = "N<Del>",
      key = "{count}<Del>",
      description = "remove the last digit from {count}",
    },
    {
      tag = "<Down>",
      key = "<Down>",
      description = '1  same as "j"',
    },
    {
      tag = "<End>",
      key = "<End>",
      description = '1  same as "$"',
    },
    {
      tag = "<F1>",
      key = "<F1>",
      description = "same as <Help>",
    },
    {
      tag = "<Help>",
      key = "<Help>",
      description = "open a help window",
    },
    {
      tag = "<Home>",
      key = "<Home>",
      description = '1  same as "0"',
    },
    {
      tag = "<Insert>",
      key = "<Insert>",
      description = '2  same as "i"',
    },
    {
      tag = "<Left>",
      key = "<Left>",
      description = '1  same as "h"',
    },
    {
      tag = "<LeftMouse>",
      key = "<LeftMouse>",
      description = "1  move cursor to the mouse click position",
    },
    {
      tag = "<MiddleMouse>",
      key = "<MiddleMouse>",
      description = '2  same as "gP" at the mouse click position',
    },
    {
      tag = "<PageDown>",
      key = "<PageDown>",
      description = "same as CTRL-F",
    },
    {
      tag = "<PageUp>",
      key = "<PageUp>",
      description = "same as CTRL-B",
    },
    {
      tag = "<Right>",
      key = "<Right>",
      description = '1  same as "l"',
    },
    {
      tag = "<RightMouse>",
      key = "<RightMouse>",
      description = "start Visual mode, move cursor to the mouse click position",
    },
    {
      tag = "<S-Down>",
      key = "<S-Down>",
      description = "1  same as CTRL-F",
    },
    {
      tag = "<S-Left>",
      key = "<S-Left>",
      description = '1  same as "b"',
    },
    {
      tag = "<S-LeftMouse>",
      key = "<S-LeftMouse>",
      description = 'same as "*" at the mouse click position',
    },
    {
      tag = "<S-Right>",
      key = "<S-Right>",
      description = '1  same as "w"',
    },
    {
      tag = "<S-RightMouse>",
      key = "<S-RightMouse>",
      description = 'same as "#" at the mouse click position',
    },
    {
      tag = "<S-Up>",
      key = "<S-Up>",
      description = "1  same as CTRL-B",
    },
    {
      tag = "<Undo>",
      key = "<Undo>",
      description = '2  same as "u"',
    },
    {
      tag = "<Up>",
      key = "<Up>",
      description = '1  same as "k"',
    },
  },
}
