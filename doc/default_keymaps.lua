-- Neovim Default Keymaps (from index.txt)
-- Generated: 2025-11-07 20:21:29
-- Source: $VIMRUNTIME/doc/index.txt

return {
  {
    number = "1.",
    name = "Insert mode",
    tag = "insert-index",
    mappings = {
      {
        tag = "i_CTRL-@",
        key = "CTRL-@",
        description = "insert previously inserted text and stop insert",
      },
      {
        tag = "i_CTRL-A",
        key = "CTRL-A",
        description = "insert previously inserted text",
      },
      {
        tag = "i_CTRL-C",
        key = "CTRL-C",
        description = "quit insert mode, without checking for abbreviation",
      },
      {
        tag = "i_CTRL-D",
        key = "CTRL-D",
        description = "delete one shiftwidth of indent in the current line",
      },
      {
        tag = "i_CTRL-E",
        key = "CTRL-E",
        description = "insert the character which is below the cursor CTRL-F\9\9not used (but by default it's in 'cinkeys' to re-indent the current line)",
      },
      {
        tag = "i_CTRL-G_j",
        key = "CTRL-G CTRL-J",
        description = "line down, to column where inserting started",
      },
      {
        tag = "i_CTRL-G_j",
        key = "CTRL-G j",
        description = "line down, to column where inserting started",
      },
      {
        tag = "i_CTRL-G_j",
        key = "CTRL-G <Down>",
        description = "line down, to column where inserting started",
      },
      {
        tag = "i_CTRL-G_k",
        key = "CTRL-G CTRL-K",
        description = "line up, to column where inserting started",
      },
      {
        tag = "i_CTRL-G_k",
        key = "CTRL-G k",
        description = "line up, to column where inserting started",
      },
      {
        tag = "i_CTRL-G_k",
        key = "CTRL-G <Up>",
        description = "line up, to column where inserting started",
      },
      {
        tag = "i_CTRL-G_u",
        key = "CTRL-G u",
        description = "start new undoable edit",
      },
      {
        tag = "i_CTRL-G_U",
        key = "CTRL-G U",
        description = "don't break undo with next cursor movement",
      },
      {
        tag = "i_<BS>",
        key = "<BS>",
        description = "delete character before the cursor",
      },
      {
        tag = "i_digraph",
        key = "{char1}<BS>{char2}",
        description = "enter digraph (only when 'digraph' option set)",
      },
      {
        tag = "i_CTRL-H",
        key = "CTRL-H",
        description = "same as <BS>",
      },
      {
        tag = "i_<Tab>",
        key = "<Tab>",
        description = "insert a <Tab> character",
      },
      {
        tag = "i_CTRL-I",
        key = "CTRL-I",
        description = "same as <Tab>",
      },
      {
        tag = "i_<NL>",
        key = "<NL>",
        description = "same as <CR>",
      },
      {
        tag = "i_CTRL-J",
        key = "CTRL-J",
        description = "same as <CR>",
      },
      {
        tag = "i_CTRL-K",
        key = "CTRL-K {char1} {char2}",
        description = "enter digraph",
      },
      {
        tag = "i_<CR>",
        key = "<CR>",
        description = "begin new line",
      },
      {
        tag = "i_CTRL-M",
        key = "CTRL-M",
        description = "same as <CR>",
      },
      {
        tag = "i_CTRL-N",
        key = "CTRL-N",
        description = "find next match for keyword in front of the cursor",
      },
      {
        tag = "i_CTRL-O",
        key = "CTRL-O",
        description = "execute a single command and return to insert mode",
      },
      {
        tag = "i_CTRL-P",
        key = "CTRL-P",
        description = "find previous match for keyword in front of the cursor",
      },
      {
        tag = "i_CTRL-Q",
        key = "CTRL-Q",
        description = "same as CTRL-V, unless used for terminal control flow",
      },
      {
        tag = "i_CTRL-SHIFT-Q",
        key = "CTRL-SHIFT-Q {char}",
        description = "like CTRL-Q unless |tui-modifyOtherKeys| is active",
      },
      {
        tag = "i_CTRL-R",
        key = "CTRL-R {register}",
        description = "insert the contents of a register",
      },
      {
        tag = "i_CTRL-R_CTRL-R",
        key = "CTRL-R CTRL-R {register}",
        description = "insert the contents of a register literally",
      },
      {
        tag = "i_CTRL-R_CTRL-O",
        key = "CTRL-R CTRL-O {register}",
        description = "insert the contents of a register literally and don't auto-indent",
      },
      {
        tag = "i_CTRL-R_CTRL-P",
        key = "CTRL-R CTRL-P {register}",
        description = "insert the contents of a register literally and fix indent. CTRL-S\9\9not used or used for terminal control flow",
      },
      {
        tag = "i_CTRL-T",
        key = "CTRL-T",
        description = "insert one shiftwidth of indent in current line",
      },
      {
        tag = "i_CTRL-U",
        key = "CTRL-U",
        description = "delete all entered characters in the current line",
      },
      {
        tag = "i_CTRL-V",
        key = "CTRL-V {char}",
        description = "insert next non-digit literally",
      },
      {
        tag = "i_CTRL-SHIFT-V",
        key = "CTRL-SHIFT-V {char}",
        description = "like CTRL-V unless |tui-modifyOtherKeys| is active",
      },
      {
        tag = "i_CTRL-V_digit",
        key = "CTRL-V {number} insert three digit decimal number as a single",
        description = "byte.",
      },
      {
        tag = "i_CTRL-W",
        key = "CTRL-W",
        description = "delete word before the cursor",
      },
      {
        tag = "i_CTRL-X",
        key = "CTRL-X {mode}",
        description = "enter CTRL-X sub mode, see |i_CTRL-X_index|",
      },
      {
        tag = "i_CTRL-Y",
        key = "CTRL-Y",
        description = "insert the character which is above the cursor",
      },
      {
        tag = "i_<Esc>",
        key = "<Esc>",
        description = "end insert mode",
      },
      {
        tag = "i_CTRL-[",
        key = "CTRL-[",
        description = "same as <Esc>",
      },
      {
        tag = "i_CTRL-\\_CTRL-N",
        key = "CTRL-\\ CTRL-N",
        description = "go to Normal mode",
      },
      {
        tag = "i_CTRL-\\_CTRL-G",
        key = "CTRL-\\ CTRL-G",
        description = "go to Normal mode CTRL-\\ a - z\9reserved for extensions CTRL-\\ others\9not used",
      },
      {
        tag = "i_CTRL-]",
        key = "CTRL-]",
        description = "trigger abbreviation",
      },
      {
        tag = "i_CTRL-^",
        key = "CTRL-^",
        description = "toggle use of |:lmap| mappings",
      },
      {
        tag = "i_CTRL-_",
        key = "CTRL-_",
        description = "When 'allowrevins' set: toggle 'revins'",
      },
      {
        tag = "",
        key = "<Space> to '~'",
        description = "not used, except '0' and '^' followed by CTRL-D",
      },
      {
        tag = "i_0_CTRL-D",
        key = "0 CTRL-D",
        description = "delete all indent in the current line",
      },
      {
        tag = "i_^_CTRL-D",
        key = "^ CTRL-D",
        description = "delete all indent in the current line, restore it in the next line",
      },
      {
        tag = "i_<Del>",
        key = "<Del>",
        description = "delete character under the cursor",
      },
      {
        tag = "i_<Left>",
        key = "<Left>",
        description = "cursor one character left",
      },
      {
        tag = "i_<S-Left>",
        key = "<S-Left>",
        description = "cursor one word left",
      },
      {
        tag = "i_<C-Left>",
        key = "<C-Left>",
        description = "cursor one word left",
      },
      {
        tag = "i_<Right>",
        key = "<Right>",
        description = "cursor one character right",
      },
      {
        tag = "i_<S-Right>",
        key = "<S-Right>",
        description = "cursor one word right",
      },
      {
        tag = "i_<C-Right>",
        key = "<C-Right>",
        description = "cursor one word right",
      },
      {
        tag = "i_<Up>",
        key = "<Up>",
        description = "cursor one line up",
      },
      {
        tag = "i_<S-Up>",
        key = "<S-Up>",
        description = "same as <PageUp>",
      },
      {
        tag = "i_<Down>",
        key = "<Down>",
        description = "cursor one line down",
      },
      {
        tag = "i_<S-Down>",
        key = "<S-Down>",
        description = "same as <PageDown>",
      },
      {
        tag = "i_<Home>",
        key = "<Home>",
        description = "cursor to start of line",
      },
      {
        tag = "i_<C-Home>",
        key = "<C-Home>",
        description = "cursor to start of file",
      },
      {
        tag = "i_<End>",
        key = "<End>",
        description = "cursor past end of line",
      },
      {
        tag = "i_<C-End>",
        key = "<C-End>",
        description = "cursor past end of file",
      },
      {
        tag = "i_<PageUp>",
        key = "<PageUp>",
        description = "one screenful backward",
      },
      {
        tag = "i_<PageDown>",
        key = "<PageDown>",
        description = "one screenful forward",
      },
      {
        tag = "i_<F1>",
        key = "<F1>",
        description = "same as <Help>",
      },
      {
        tag = "i_<Help>",
        key = "<Help>",
        description = "stop insert mode and display help window",
      },
      {
        tag = "i_<Insert>",
        key = "<Insert>",
        description = "toggle Insert/Replace mode",
      },
      {
        tag = "i_<LeftMouse>",
        key = "<LeftMouse>",
        description = "cursor at mouse click",
      },
      {
        tag = "i_<ScrollWheelDown>",
        key = "<ScrollWheelDown>",
        description = "move window three lines down",
      },
      {
        tag = "i_<S-ScrollWheelDown>",
        key = "<S-ScrollWheelDown>",
        description = "move window one page down",
      },
      {
        tag = "i_<ScrollWheelUp>",
        key = "<ScrollWheelUp>",
        description = "move window three lines up",
      },
      {
        tag = "i_<S-ScrollWheelUp>",
        key = "<S-ScrollWheelUp>",
        description = "move window one page up",
      },
      {
        tag = "i_<ScrollWheelLeft>",
        key = "<ScrollWheelLeft>",
        description = "move window six columns left",
      },
      {
        tag = "i_<S-ScrollWheelLeft>",
        key = "<S-ScrollWheelLeft>",
        description = "move window one page left",
      },
      {
        tag = "i_<ScrollWheelRight>",
        key = "<ScrollWheelRight>",
        description = "move window six columns right",
      },
      {
        tag = "i_<S-ScrollWheelRight>",
        key = "<S-ScrollWheelRight>",
        description = "move window one page right",
      },
      {
        tag = "i_CTRL-X_CTRL-D",
        key = "CTRL-X CTRL-D",
        description = "complete defined identifiers",
      },
      {
        tag = "i_CTRL-X_CTRL-E",
        key = "CTRL-X CTRL-E",
        description = "scroll up",
      },
      {
        tag = "i_CTRL-X_CTRL-F",
        key = "CTRL-X CTRL-F",
        description = "complete file names",
      },
      {
        tag = "i_CTRL-X_CTRL-I",
        key = "CTRL-X CTRL-I",
        description = "complete identifiers",
      },
      {
        tag = "i_CTRL-X_CTRL-K",
        key = "CTRL-X CTRL-K",
        description = "complete identifiers from dictionary",
      },
      {
        tag = "i_CTRL-X_CTRL-L",
        key = "CTRL-X CTRL-L",
        description = "complete whole lines",
      },
      {
        tag = "i_CTRL-X_CTRL-N",
        key = "CTRL-X CTRL-N",
        description = "next completion",
      },
      {
        tag = "i_CTRL-X_CTRL-O",
        key = "CTRL-X CTRL-O",
        description = "omni completion",
      },
      {
        tag = "i_CTRL-X_CTRL-P",
        key = "CTRL-X CTRL-P",
        description = "previous completion",
      },
      {
        tag = "i_CTRL-X_CTRL-R",
        key = "CTRL-X CTRL-R",
        description = "complete contents from registers",
      },
      {
        tag = "i_CTRL-X_CTRL-S",
        key = "CTRL-X CTRL-S",
        description = "spelling suggestions",
      },
      {
        tag = "i_CTRL-X_CTRL-T",
        key = "CTRL-X CTRL-T",
        description = "complete identifiers from thesaurus",
      },
      {
        tag = "i_CTRL-X_CTRL-Y",
        key = "CTRL-X CTRL-Y",
        description = "scroll down",
      },
      {
        tag = "i_CTRL-X_CTRL-U",
        key = "CTRL-X CTRL-U",
        description = "complete with 'completefunc'",
      },
      {
        tag = "i_CTRL-X_CTRL-V",
        key = "CTRL-X CTRL-V",
        description = "complete like in : command line",
      },
      {
        tag = "i_CTRL-X_CTRL-Z",
        key = "CTRL-X CTRL-Z",
        description = "stop completion, keeping the text as-is",
      },
      {
        tag = "i_CTRL-X_CTRL-]",
        key = "CTRL-X CTRL-]",
        description = "complete tags",
      },
      {
        tag = "i_CTRL-X_s",
        key = "CTRL-X s",
        description = "spelling suggestions",
      },
      {
        tag = "complete_CTRL-E",
        key = "CTRL-E",
        description = "stop completion and go back to original text",
      },
      {
        tag = "complete_CTRL-Y",
        key = "CTRL-Y",
        description = "accept selected match and stop completion CTRL-L\9\9insert one character from the current match <CR>\9\9insert currently selected match <BS>\9\9delete one character and redo search CTRL-H\9\9same as <BS> <Up>\9\9select the previous match <Down>\9\9select the next match <PageUp>\9select a match several entries back <PageDown>\9select a match several entries forward other\9\9stop completion and insert the typed character",
      },
    },
  },
  {
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
    subsections = {
      {
        number = "2.1",
        name = "Text objects",
        tag = "objects",
        mappings = {
          {
            tag = "v_aquote",
            key = 'a"',
            description = "double quoted string",
          },
          {
            tag = "v_a'",
            key = "a'",
            description = "single quoted string",
          },
          {
            tag = "v_a(",
            key = "a(",
            description = "same as ab",
          },
          {
            tag = "v_a)",
            key = "a)",
            description = "same as ab",
          },
          {
            tag = "v_a<",
            key = "a<",
            description = "\"a <>\" from '<' to the matching '>'",
          },
          {
            tag = "v_a>",
            key = "a>",
            description = "same as a<",
          },
          {
            tag = "v_aB",
            key = "aB",
            description = '"a Block" from `[{` to `]}` (with brackets)',
          },
          {
            tag = "v_aW",
            key = "aW",
            description = '"a WORD" (with white space)',
          },
          {
            tag = "v_a[",
            key = "a[",
            description = "\"a []\" from '[' to the matching ']'",
          },
          {
            tag = "v_a]",
            key = "a]",
            description = "same as a[",
          },
          {
            tag = "v_a`",
            key = "a`",
            description = "string in backticks",
          },
          {
            tag = "v_ab",
            key = "ab",
            description = '"a block" from "[(" to "])" (with braces)',
          },
          {
            tag = "v_ap",
            key = "ap",
            description = '"a paragraph" (with white space)',
          },
          {
            tag = "v_as",
            key = "as",
            description = '"a sentence" (with white space)',
          },
          {
            tag = "v_at",
            key = "at",
            description = '"a tag block" (with white space)',
          },
          {
            tag = "v_aw",
            key = "aw",
            description = '"a word" (with white space)',
          },
          {
            tag = "v_a{",
            key = "a{",
            description = "same as aB",
          },
          {
            tag = "v_a}",
            key = "a}",
            description = "same as aB",
          },
          {
            tag = "v_iquote",
            key = 'i"',
            description = "double quoted string without the quotes",
          },
          {
            tag = "v_i'",
            key = "i'",
            description = "single quoted string without the quotes",
          },
          {
            tag = "v_i(",
            key = "i(",
            description = "same as ib",
          },
          {
            tag = "v_i)",
            key = "i)",
            description = "same as ib",
          },
          {
            tag = "v_i<",
            key = "i<",
            description = "\"inner <>\" from '<' to the matching '>'",
          },
          {
            tag = "v_i>",
            key = "i>",
            description = "same as i<",
          },
          {
            tag = "v_iB",
            key = "iB",
            description = '"inner Block" from `[{` and `]}`',
          },
          {
            tag = "v_iW",
            key = "iW",
            description = '"inner WORD"',
          },
          {
            tag = "v_i[",
            key = "i[",
            description = "\"inner []\" from '[' to the matching ']'",
          },
          {
            tag = "v_i]",
            key = "i]",
            description = "same as i[",
          },
          {
            tag = "v_i`",
            key = "i`",
            description = "string in backticks without the backticks",
          },
          {
            tag = "v_ib",
            key = "ib",
            description = '"inner block" from "[(" to "])"',
          },
          {
            tag = "v_ip",
            key = "ip",
            description = '"inner paragraph"',
          },
          {
            tag = "v_is",
            key = "is",
            description = '"inner sentence"',
          },
          {
            tag = "v_it",
            key = "it",
            description = '"inner tag block"',
          },
          {
            tag = "v_iw",
            key = "iw",
            description = '"inner word"',
          },
          {
            tag = "v_i{",
            key = "i{",
            description = "same as iB",
          },
          {
            tag = "v_i}",
            key = "i}",
            description = "same as iB",
          },
        },
      },
      {
        number = "2.2",
        name = "Window commands",
        tag = "CTRL-W",
        mappings = {
          {
            tag = "CTRL-W_CTRL-B",
            key = "CTRL-W CTRL-B",
            description = 'same as "CTRL-W b"',
          },
          {
            tag = "CTRL-W_CTRL-C",
            key = "CTRL-W CTRL-C",
            description = "no-op",
          },
          {
            tag = "CTRL-W_CTRL-D",
            key = "CTRL-W CTRL-D",
            description = 'same as "CTRL-W d"',
          },
          {
            tag = "CTRL-W_CTRL-F",
            key = "CTRL-W CTRL-F",
            description = 'same as "CTRL-W f" CTRL-W CTRL-G\9   same as "CTRL-W g .."',
          },
          {
            tag = "CTRL-W_CTRL-H",
            key = "CTRL-W CTRL-H",
            description = 'same as "CTRL-W h"',
          },
          {
            tag = "CTRL-W_CTRL-I",
            key = "CTRL-W CTRL-I",
            description = 'same as "CTRL-W i"',
          },
          {
            tag = "CTRL-W_CTRL-J",
            key = "CTRL-W CTRL-J",
            description = 'same as "CTRL-W j"',
          },
          {
            tag = "CTRL-W_CTRL-K",
            key = "CTRL-W CTRL-K",
            description = 'same as "CTRL-W k"',
          },
          {
            tag = "CTRL-W_CTRL-L",
            key = "CTRL-W CTRL-L",
            description = 'same as "CTRL-W l"',
          },
          {
            tag = "CTRL-W_CTRL-N",
            key = "CTRL-W CTRL-N",
            description = 'same as "CTRL-W n"',
          },
          {
            tag = "CTRL-W_CTRL-O",
            key = "CTRL-W CTRL-O",
            description = 'same as "CTRL-W o"',
          },
          {
            tag = "CTRL-W_CTRL-P",
            key = "CTRL-W CTRL-P",
            description = 'same as "CTRL-W p"',
          },
          {
            tag = "CTRL-W_CTRL-Q",
            key = "CTRL-W CTRL-Q",
            description = 'same as "CTRL-W q"',
          },
          {
            tag = "CTRL-W_CTRL-R",
            key = "CTRL-W CTRL-R",
            description = 'same as "CTRL-W r"',
          },
          {
            tag = "CTRL-W_CTRL-S",
            key = "CTRL-W CTRL-S",
            description = 'same as "CTRL-W s"',
          },
          {
            tag = "CTRL-W_CTRL-T",
            key = "CTRL-W CTRL-T",
            description = 'same as "CTRL-W t"',
          },
          {
            tag = "CTRL-W_CTRL-V",
            key = "CTRL-W CTRL-V",
            description = 'same as "CTRL-W v"',
          },
          {
            tag = "CTRL-W_CTRL-W",
            key = "CTRL-W CTRL-W",
            description = 'same as "CTRL-W w"',
          },
          {
            tag = "CTRL-W_CTRL-X",
            key = "CTRL-W CTRL-X",
            description = 'same as "CTRL-W x"',
          },
          {
            tag = "CTRL-W_CTRL-Z",
            key = "CTRL-W CTRL-Z",
            description = 'same as "CTRL-W z"',
          },
          {
            tag = "CTRL-W_CTRL-]",
            key = "CTRL-W CTRL-]",
            description = 'same as "CTRL-W ]"',
          },
          {
            tag = "CTRL-W_CTRL-^",
            key = "CTRL-W CTRL-^",
            description = 'same as "CTRL-W ^"',
          },
          {
            tag = "CTRL-W_CTRL-_",
            key = "CTRL-W CTRL-_",
            description = 'same as "CTRL-W _"',
          },
          {
            tag = "CTRL-W_+",
            key = "CTRL-W +",
            description = "increase current window height N lines",
          },
          {
            tag = "CTRL-W_-",
            key = "CTRL-W -",
            description = "decrease current window height N lines",
          },
          {
            tag = "CTRL-W_<",
            key = "CTRL-W <",
            description = "decrease current window width N columns",
          },
          {
            tag = "CTRL-W_=",
            key = "CTRL-W =",
            description = "make all windows the same height & width",
          },
          {
            tag = "CTRL-W_>",
            key = "CTRL-W >",
            description = "increase current window width N columns",
          },
          {
            tag = "CTRL-W_H",
            key = "CTRL-W H",
            description = "move current window to the far left",
          },
          {
            tag = "CTRL-W_J",
            key = "CTRL-W J",
            description = "move current window to the very bottom",
          },
          {
            tag = "CTRL-W_K",
            key = "CTRL-W K",
            description = "move current window to the very top",
          },
          {
            tag = "CTRL-W_L",
            key = "CTRL-W L",
            description = "move current window to the far right",
          },
          {
            tag = "CTRL-W_P",
            key = "CTRL-W P",
            description = "go to preview window",
          },
          {
            tag = "CTRL-W_R",
            key = "CTRL-W R",
            description = "rotate windows upwards N times",
          },
          {
            tag = "CTRL-W_S",
            key = "CTRL-W S",
            description = 'same as "CTRL-W s"',
          },
          {
            tag = "CTRL-W_T",
            key = "CTRL-W T",
            description = "move current window to a new tab page",
          },
          {
            tag = "CTRL-W_W",
            key = "CTRL-W W",
            description = "go to N previous window (wrap around)",
          },
          {
            tag = "CTRL-W_]",
            key = "CTRL-W ]",
            description = "split window and jump to tag under cursor",
          },
          {
            tag = "CTRL-W_^",
            key = "CTRL-W ^",
            description = "split current window and edit alternate file N",
          },
          {
            tag = "CTRL-W__",
            key = "CTRL-W _",
            description = "set current window height to N (default: very high)",
          },
          {
            tag = "CTRL-W_b",
            key = "CTRL-W b",
            description = "go to bottom window",
          },
          {
            tag = "CTRL-W_c",
            key = "CTRL-W c",
            description = "close current window (like |:close|)",
          },
          {
            tag = "CTRL-W_d",
            key = "CTRL-W d",
            description = "split window and jump to definition under the cursor",
          },
          {
            tag = "CTRL-W_f",
            key = "CTRL-W f",
            description = "split window and edit file name under the cursor",
          },
          {
            tag = "CTRL-W_F",
            key = "CTRL-W F",
            description = "split window and edit file name under the cursor and jump to the line number following the file name.",
          },
          {
            tag = "CTRL-W_g_CTRL-]",
            key = "CTRL-W g CTRL-]  split window and do |:tjump| to tag under",
            description = "cursor",
          },
          {
            tag = "CTRL-W_g]",
            key = "CTRL-W g ]",
            description = "split window and do |:tselect| for tag under cursor",
          },
          {
            tag = "CTRL-W_g}",
            key = "CTRL-W g }",
            description = "do a |:ptjump| to the tag under the cursor",
          },
          {
            tag = "CTRL-W_gf",
            key = "CTRL-W g f",
            description = "edit file name under the cursor in a new tab page",
          },
          {
            tag = "CTRL-W_gF",
            key = "CTRL-W g F",
            description = "edit file name under the cursor in a new tab page and jump to the line number following the file name.",
          },
          {
            tag = "CTRL-W_gt",
            key = "CTRL-W g t",
            description = "same as `gt`: go to next tab page",
          },
          {
            tag = "CTRL-W_gT",
            key = "CTRL-W g T",
            description = "same as `gT`: go to previous tab page",
          },
          {
            tag = "CTRL-W_g<Tab>",
            key = "CTRL-W g <Tab>",
            description = "same as |g<Tab>|: go to last accessed tab page",
          },
          {
            tag = "CTRL-W_h",
            key = "CTRL-W h",
            description = "go to Nth left window (stop at first window)",
          },
          {
            tag = "CTRL-W_i",
            key = "CTRL-W i",
            description = "split window and jump to declaration of identifier under the cursor",
          },
          {
            tag = "CTRL-W_j",
            key = "CTRL-W j",
            description = "go N windows down (stop at last window)",
          },
          {
            tag = "CTRL-W_k",
            key = "CTRL-W k",
            description = "go N windows up (stop at first window)",
          },
          {
            tag = "CTRL-W_l",
            key = "CTRL-W l",
            description = "go to Nth right window (stop at last window)",
          },
          {
            tag = "CTRL-W_n",
            key = "CTRL-W n",
            description = "open new window, N lines high",
          },
          {
            tag = "CTRL-W_o",
            key = "CTRL-W o",
            description = "close all but current window (like |:only|)",
          },
          {
            tag = "CTRL-W_p",
            key = "CTRL-W p",
            description = "go to previous (last accessed) window",
          },
          {
            tag = "CTRL-W_q",
            key = "CTRL-W q",
            description = "quit current window (like |:quit|)",
          },
          {
            tag = "CTRL-W_r",
            key = "CTRL-W r",
            description = "rotate windows downwards N times",
          },
          {
            tag = "CTRL-W_s",
            key = "CTRL-W s",
            description = "split current window in two parts, new window N lines high",
          },
          {
            tag = "CTRL-W_t",
            key = "CTRL-W t",
            description = "go to top window",
          },
          {
            tag = "CTRL-W_v",
            key = "CTRL-W v",
            description = "split current window vertically, new window N columns wide",
          },
          {
            tag = "CTRL-W_w",
            key = "CTRL-W w",
            description = "go to N next window (wrap around)",
          },
          {
            tag = "CTRL-W_x",
            key = "CTRL-W x",
            description = "exchange current window with window N (default: next window)",
          },
          {
            tag = "CTRL-W_z",
            key = "CTRL-W z",
            description = "close preview window",
          },
          {
            tag = "CTRL-W_bar",
            key = "CTRL-W |",
            description = "set window width to N columns",
          },
          {
            tag = "CTRL-W_}",
            key = "CTRL-W }",
            description = "show tag under cursor in preview window",
          },
          {
            tag = "CTRL-W_<Down>",
            key = "CTRL-W <Down>",
            description = 'same as "CTRL-W j"',
          },
          {
            tag = "CTRL-W_<Up>",
            key = "CTRL-W <Up>",
            description = 'same as "CTRL-W k"',
          },
          {
            tag = "CTRL-W_<Left>",
            key = "CTRL-W <Left>",
            description = 'same as "CTRL-W h"',
          },
          {
            tag = "CTRL-W_<Right>",
            key = "CTRL-W <Right>",
            description = 'same as "CTRL-W l"',
          },
        },
      },
      {
        number = "2.3",
        name = "Square bracket commands",
        tag = "[",
        mappings = {
          {
            tag = "[_CTRL-D",
            key = "[ CTRL-D",
            description = "jump to first #define found in current and included files matching the word under the cursor, start searching at beginning of current file",
          },
          {
            tag = "[_CTRL-I",
            key = "[ CTRL-I",
            description = "jump to first line in current and included files that contains the word under the cursor, start searching at beginning of current file",
          },
          {
            tag = "[#",
            key = "[#",
            description = "1  cursor to N previous unmatched #if, #else or #ifdef",
          },
          {
            tag = "['",
            key = "['",
            description = "1  cursor to previous lowercase mark, on first non-blank",
          },
          {
            tag = "[(",
            key = "[(",
            description = "1  cursor N times back to unmatched '('",
          },
          {
            tag = "[star",
            key = "[*",
            description = '1  same as "[/"',
          },
          {
            tag = "[`",
            key = "[`",
            description = "1  cursor to previous lowercase mark",
          },
          {
            tag = "[/",
            key = "[/",
            description = "1  cursor to N previous start of a C comment",
          },
          {
            tag = "[D",
            key = "[D",
            description = "list all defines found in current and included files matching the word under the cursor, start searching at beginning of current file",
          },
          {
            tag = "[I",
            key = "[I",
            description = "list all lines found in current and included files that contain the word under the cursor, start searching at beginning of current file",
          },
          {
            tag = "[P",
            key = "[P",
            description = '2  same as "[p"',
          },
          {
            tag = "[[",
            key = "[[",
            description = "1  cursor N sections backward",
          },
          {
            tag = "[]",
            key = "[]",
            description = "1  cursor N SECTIONS backward",
          },
          {
            tag = "[c",
            key = "[c",
            description = "1  cursor N times backwards to start of change",
          },
          {
            tag = "[d",
            key = "[d",
            description = "show first #define found in current and included files matching the word under the cursor, start searching at beginning of current file",
          },
          {
            tag = "[f",
            key = "[f",
            description = 'same as "gf"',
          },
          {
            tag = "[i",
            key = "[i",
            description = "show first line found in current and included files that contains the word under the cursor, start searching at beginning of current file",
          },
          {
            tag = "[m",
            key = "[m",
            description = "1  cursor N times back to start of member function",
          },
          {
            tag = "[p",
            key = "[p",
            description = '2  like "P", but adjust indent to current line',
          },
          {
            tag = "[s",
            key = "[s",
            description = "1  move to the previous misspelled word",
          },
          {
            tag = "[z",
            key = "[z",
            description = "1  move to start of open fold",
          },
          {
            tag = "[{",
            key = "[{",
            description = "1  cursor N times back to unmatched '{'",
          },
          {
            tag = "[<MiddleMouse>",
            key = "[<MiddleMouse>",
            description = '2  same as "[p"',
          },
          {
            tag = "]_CTRL-D",
            key = "] CTRL-D",
            description = "jump to first #define found in current and included files matching the word under the cursor, start searching at cursor position",
          },
          {
            tag = "]_CTRL-I",
            key = "] CTRL-I",
            description = "jump to first line in current and included files that contains the word under the cursor, start searching at cursor position",
          },
          {
            tag = "]#",
            key = "]#",
            description = "1  cursor to N next unmatched #endif or #else",
          },
          {
            tag = "]'",
            key = "]'",
            description = "1  cursor to next lowercase mark, on first non-blank",
          },
          {
            tag = "])",
            key = "])",
            description = "1  cursor N times forward to unmatched ')'",
          },
          {
            tag = "]star",
            key = "]*",
            description = '1  same as "]/"',
          },
          {
            tag = "]`",
            key = "]`",
            description = "1  cursor to next lowercase mark",
          },
          {
            tag = "]/",
            key = "]/",
            description = "1  cursor to N next end of a C comment",
          },
          {
            tag = "]D",
            key = "]D",
            description = "list all #defines found in current and included files matching the word under the cursor, start searching at cursor position",
          },
          {
            tag = "]I",
            key = "]I",
            description = "list all lines found in current and included files that contain the word under the cursor, start searching at cursor position",
          },
          {
            tag = "]P",
            key = "]P",
            description = '2  same as "[p"',
          },
          {
            tag = "][",
            key = "][",
            description = "1  cursor N SECTIONS forward",
          },
          {
            tag = "]]",
            key = "]]",
            description = "1  cursor N sections forward",
          },
          {
            tag = "]c",
            key = "]c",
            description = "1  cursor N times forward to start of change",
          },
          {
            tag = "]d",
            key = "]d",
            description = "show first #define found in current and included files matching the word under the cursor, start searching at cursor position",
          },
          {
            tag = "]f",
            key = "]f",
            description = 'same as "gf"',
          },
          {
            tag = "]i",
            key = "]i",
            description = "show first line found in current and included files that contains the word under the cursor, start searching at cursor position",
          },
          {
            tag = "]m",
            key = "]m",
            description = "1  cursor N times forward to end of member function",
          },
          {
            tag = "]p",
            key = "]p",
            description = '2  like "p", but adjust indent to current line',
          },
          {
            tag = "]s",
            key = "]s",
            description = "1  move to next misspelled word",
          },
          {
            tag = "]z",
            key = "]z",
            description = "1  move to end of open fold",
          },
          {
            tag = "]}",
            key = "]}",
            description = "1  cursor N times forward to unmatched '}'",
          },
          {
            tag = "]<MiddleMouse>",
            key = "]<MiddleMouse>",
            description = '2  same as "]p"',
          },
        },
      },
      {
        number = "2.4",
        name = "Commands starting with 'g'",
        tag = "g",
        mappings = {
          {
            tag = "g_CTRL-G",
            key = "g CTRL-G",
            description = "show information about current cursor position",
          },
          {
            tag = "g_CTRL-H",
            key = "g CTRL-H",
            description = "start Select block mode",
          },
          {
            tag = "g_CTRL-]",
            key = "g CTRL-]",
            description = "|:tjump| to the tag under the cursor",
          },
          {
            tag = "g#",
            key = "g#",
            description = '1  like "#", but without using "\\<" and "\\>"',
          },
          {
            tag = "g$",
            key = "g$",
            description = "1  when 'wrap' off go to rightmost character of the current line that is on the screen; when 'wrap' on go to the rightmost character of the current screen line",
          },
          {
            tag = "g&",
            key = "g&",
            description = '2  repeat last ":s" on all lines',
          },
          {
            tag = "g'",
            key = "g'{mark}",
            description = "1  like |'| but without changing the jumplist",
          },
          {
            tag = "g`",
            key = "g`{mark}",
            description = "1  like |`| but without changing the jumplist",
          },
          {
            tag = "gstar",
            key = "g*",
            description = '1  like "*", but without using "\\<" and "\\>"',
          },
          {
            tag = "g+",
            key = "g+",
            description = "go to newer text state N times",
          },
          {
            tag = "g,",
            key = "g,",
            description = "1  go to N newer position in change list",
          },
          {
            tag = "g-",
            key = "g-",
            description = "go to older text state N times",
          },
          {
            tag = "g0",
            key = "g0",
            description = "1  when 'wrap' off go to leftmost character of the current line that is on the screen; when 'wrap' on go to the leftmost character of the current screen line",
          },
          {
            tag = "g8",
            key = "g8",
            description = "print hex value of bytes used in UTF-8 character under the cursor",
          },
          {
            tag = "g;",
            key = "g;",
            description = "1  go to N older position in change list",
          },
          {
            tag = "g<",
            key = "g<",
            description = "display previous command output",
          },
          {
            tag = "g?",
            key = "g?",
            description = "2  Rot13 encoding operator",
          },
          {
            tag = "g?g?",
            key = "g??",
            description = "2  Rot13 encode current line",
          },
          {
            tag = "g?g?",
            key = "g?g?",
            description = "2  Rot13 encode current line",
          },
          {
            tag = "gD",
            key = "gD",
            description = "1  go to definition of word under the cursor in current file",
          },
          {
            tag = "gE",
            key = "gE",
            description = "1  go backwards to the end of the previous WORD",
          },
          {
            tag = "gH",
            key = "gH",
            description = "start Select line mode",
          },
          {
            tag = "gI",
            key = "gI",
            description = '2  like "I", but always start in column 1',
          },
          {
            tag = "gJ",
            key = "gJ",
            description = "2  join lines without inserting space",
          },
          {
            tag = "gN",
            key = "gN",
            description = "1,2  find the previous match with the last used search pattern and Visually select it",
          },
          {
            tag = "gP",
            key = '["x]gP',
            description = "2  put the text [from register x] before the cursor N times, leave the cursor after it",
          },
          {
            tag = "gQ",
            key = "gQ",
            description = 'switch to "Ex" mode with Vim editing',
          },
          {
            tag = "gR",
            key = "gR",
            description = "2  enter Virtual Replace mode",
          },
          {
            tag = "gT",
            key = "gT",
            description = "go to the previous tab page",
          },
          {
            tag = "gU",
            key = "gU{motion}",
            description = "2  make Nmove text uppercase",
          },
          {
            tag = "gV",
            key = "gV",
            description = "don't reselect the previous Visual area when executing a mapping or menu in Select mode",
          },
          {
            tag = "g]",
            key = "g]",
            description = ":tselect on the tag under the cursor",
          },
          {
            tag = "g^",
            key = "g^",
            description = "1  when 'wrap' off go to leftmost non-white character of the current line that is on the screen; when 'wrap' on go to the leftmost non-white character of the current screen line",
          },
          {
            tag = "g_",
            key = "g_",
            description = "1  cursor to the last CHAR N - 1 lines lower",
          },
          {
            tag = "ga",
            key = "ga",
            description = "print ascii value of character under the cursor",
          },
          {
            tag = "gd",
            key = "gd",
            description = "1  go to definition of word under the cursor in current function",
          },
          {
            tag = "ge",
            key = "ge",
            description = "1  go backwards to the end of the previous word",
          },
          {
            tag = "gf",
            key = "gf",
            description = "start editing the file whose name is under the cursor",
          },
          {
            tag = "gF",
            key = "gF",
            description = "start editing the file whose name is under the cursor and jump to the line number following the filename.",
          },
          {
            tag = "gg",
            key = "gg",
            description = "1  cursor to line N, default first line",
          },
          {
            tag = "gh",
            key = "gh",
            description = "start Select mode",
          },
          {
            tag = "gi",
            key = "gi",
            description = '2  like "i", but first move to the |\'^| mark',
          },
          {
            tag = "gj",
            key = "gj",
            description = "1  like \"j\", but when 'wrap' on go N screen lines down",
          },
          {
            tag = "gk",
            key = "gk",
            description = "1  like \"k\", but when 'wrap' on go N screen lines up",
          },
          {
            tag = "gm",
            key = "gm",
            description = "1  go to character at middle of the screenline",
          },
          {
            tag = "gM",
            key = "gM",
            description = "1  go to character at middle of the text line",
          },
          {
            tag = "gn",
            key = "gn",
            description = "1,2  find the next match with the last used search pattern and Visually select it",
          },
          {
            tag = "go",
            key = "go",
            description = "1  cursor to byte N in the buffer",
          },
          {
            tag = "gp",
            key = '["x]gp',
            description = "2  put the text [from register x] after the cursor N times, leave the cursor after it",
          },
          {
            tag = "gq",
            key = "gq{motion}",
            description = "2  format Nmove text",
          },
          {
            tag = "gr",
            key = "gr{char}",
            description = "2  virtual replace N chars with {char}",
          },
          {
            tag = "gs",
            key = "gs",
            description = "go to sleep for N seconds (default 1)",
          },
          {
            tag = "gt",
            key = "gt",
            description = "go to the next tab page",
          },
          {
            tag = "gu",
            key = "gu{motion}",
            description = "2  make Nmove text lowercase",
          },
          {
            tag = "gv",
            key = "gv",
            description = "reselect the previous Visual area",
          },
          {
            tag = "gw",
            key = "gw{motion}",
            description = "2  format Nmove text and keep cursor",
          },
          {
            tag = "gx",
            key = "gx",
            description = "execute application for filepath at cursor",
          },
          {
            tag = "g@",
            key = "g@{motion}",
            description = "call 'operatorfunc'",
          },
          {
            tag = "g~",
            key = "g~{motion}",
            description = "2  swap case for Nmove text",
          },
          {
            tag = "g<Down>",
            key = "g<Down>",
            description = '1  same as "gj"',
          },
          {
            tag = "g<End>",
            key = "g<End>",
            description = '1  same as "g$" but go to the rightmost non-blank character instead',
          },
          {
            tag = "g<Home>",
            key = "g<Home>",
            description = '1  same as "g0"',
          },
          {
            tag = "g<LeftMouse>",
            key = "g<LeftMouse>",
            description = "same as <C-LeftMouse> g<MiddleMouse>\9   same as <C-MiddleMouse>",
          },
          {
            tag = "g<RightMouse>",
            key = "g<RightMouse>",
            description = "same as <C-RightMouse>",
          },
          {
            tag = "g<Tab>",
            key = "g<Tab>",
            description = "go to last accessed tab page",
          },
          {
            tag = "g<Up>",
            key = "g<Up>",
            description = '1  same as "gk"',
          },
        },
      },
      {
        number = "2.5",
        name = "Commands starting with 'z'",
        tag = "z",
        mappings = {
          {
            tag = "z<CR>",
            key = "z<CR>",
            description = "redraw, cursor line to top of window, cursor on first non-blank",
          },
          {
            tag = "zN<CR>",
            key = "z{height}<CR>",
            description = "redraw, make window {height} lines high",
          },
          {
            tag = "z+",
            key = "z+",
            description = 'cursor on line N (default line below window), otherwise like "z<CR>"',
          },
          {
            tag = "z-",
            key = "z-",
            description = "redraw, cursor line at bottom of window, cursor on first non-blank",
          },
          {
            tag = "z.",
            key = "z.",
            description = "redraw, cursor line to center of window, cursor on first non-blank",
          },
          {
            tag = "z=",
            key = "z=",
            description = "give spelling suggestions",
          },
          {
            tag = "zA",
            key = "zA",
            description = "open a closed fold or close an open fold recursively",
          },
          {
            tag = "zC",
            key = "zC",
            description = "close folds recursively",
          },
          {
            tag = "zD",
            key = "zD",
            description = "delete folds recursively",
          },
          {
            tag = "zE",
            key = "zE",
            description = "eliminate all folds",
          },
          {
            tag = "zF",
            key = "zF",
            description = "create a fold for N lines",
          },
          {
            tag = "zG",
            key = "zG",
            description = "temporarily mark word as correctly spelled",
          },
          {
            tag = "zH",
            key = "zH",
            description = "when 'wrap' off scroll half a screenwidth to the right",
          },
          {
            tag = "zL",
            key = "zL",
            description = "when 'wrap' off scroll half a screenwidth to the left",
          },
          {
            tag = "zM",
            key = "zM",
            description = "set 'foldlevel' to zero",
          },
          {
            tag = "zN",
            key = "zN",
            description = "set 'foldenable'",
          },
          {
            tag = "zO",
            key = "zO",
            description = "open folds recursively",
          },
          {
            tag = "zR",
            key = "zR",
            description = "set 'foldlevel' to the deepest fold",
          },
          {
            tag = "zW",
            key = "zW",
            description = "temporarily mark word as incorrectly spelled",
          },
          {
            tag = "zX",
            key = "zX",
            description = "re-apply 'foldlevel'",
          },
          {
            tag = "z^",
            key = "z^",
            description = 'cursor on line N (default line above window), otherwise like "z-"',
          },
          {
            tag = "za",
            key = "za",
            description = "open a closed fold, close an open fold",
          },
          {
            tag = "zb",
            key = "zb",
            description = "redraw, cursor line at bottom of window",
          },
          {
            tag = "zc",
            key = "zc",
            description = "close a fold",
          },
          {
            tag = "zd",
            key = "zd",
            description = "delete a fold",
          },
          {
            tag = "ze",
            key = "ze",
            description = "when 'wrap' off scroll horizontally to position the cursor at the end (right side) of the screen",
          },
          {
            tag = "zf",
            key = "zf{motion}",
            description = "create a fold for Nmove text",
          },
          {
            tag = "zg",
            key = "zg",
            description = "permanently mark word as correctly spelled",
          },
          {
            tag = "zh",
            key = "zh",
            description = "when 'wrap' off scroll screen N characters to the right",
          },
          {
            tag = "zi",
            key = "zi",
            description = "toggle 'foldenable'",
          },
          {
            tag = "zj",
            key = "zj",
            description = "1  move to the start of the next fold",
          },
          {
            tag = "zk",
            key = "zk",
            description = "1  move to the end of the previous fold",
          },
          {
            tag = "zl",
            key = "zl",
            description = "when 'wrap' off scroll screen N characters to the left",
          },
          {
            tag = "zm",
            key = "zm",
            description = "subtract one from 'foldlevel'",
          },
          {
            tag = "zn",
            key = "zn",
            description = "reset 'foldenable'",
          },
          {
            tag = "zo",
            key = "zo",
            description = "open fold",
          },
          {
            tag = "zp",
            key = "zp",
            description = "paste in block-mode without trailing spaces",
          },
          {
            tag = "zP",
            key = "zP",
            description = "paste in block-mode without trailing spaces",
          },
          {
            tag = "zr",
            key = "zr",
            description = "add one to 'foldlevel'",
          },
          {
            tag = "zs",
            key = "zs",
            description = "when 'wrap' off scroll horizontally to position the cursor at the start (left side) of the screen",
          },
          {
            tag = "zt",
            key = "zt",
            description = "redraw, cursor line at top of window",
          },
          {
            tag = "zuw",
            key = "zuw",
            description = "undo |zw|",
          },
          {
            tag = "zug",
            key = "zug",
            description = "undo |zg|",
          },
          {
            tag = "zuW",
            key = "zuW",
            description = "undo |zW|",
          },
          {
            tag = "zuG",
            key = "zuG",
            description = "undo |zG|",
          },
          {
            tag = "zv",
            key = "zv",
            description = "open enough folds to view the cursor line",
          },
          {
            tag = "zw",
            key = "zw",
            description = "permanently mark word as incorrectly spelled",
          },
          {
            tag = "zx",
            key = "zx",
            description = "re-apply 'foldlevel' and do \"zv\"",
          },
          {
            tag = "zy",
            key = "zy",
            description = "yank without trailing spaces",
          },
          {
            tag = "zz",
            key = "zz",
            description = "redraw, cursor line at center of window",
          },
          {
            tag = "z<Left>",
            key = "z<Left>",
            description = 'same as "zh"',
          },
          {
            tag = "z<Right>",
            key = "z<Right>",
            description = 'same as "zl"',
          },
        },
      },
      {
        number = "2.6",
        name = "Operator-pending mode",
        tag = "operator-pending-index",
        mappings = {
          {
            tag = "o_v",
            key = "v",
            description = "force operator to work charwise",
          },
          {
            tag = "o_V",
            key = "V",
            description = "force operator to work linewise",
          },
          {
            tag = "o_CTRL-V",
            key = "CTRL-V",
            description = "force operator to work blockwise",
          },
        },
      },
    },
  },
  {
    number = "3.",
    name = "Visual mode",
    tag = "visual-index",
    mappings = {
      {
        tag = "v_CTRL-\\_CTRL-N",
        key = "CTRL-\\ CTRL-N",
        description = "stop Visual mode",
      },
      {
        tag = "v_CTRL-\\_CTRL-G",
        key = "CTRL-\\ CTRL-G",
        description = "go to Normal mode",
      },
      {
        tag = "v_CTRL-A",
        key = "CTRL-A",
        description = "2  add N to number in highlighted text",
      },
      {
        tag = "v_CTRL-C",
        key = "CTRL-C",
        description = "stop Visual mode",
      },
      {
        tag = "v_CTRL-G",
        key = "CTRL-G",
        description = "toggle between Visual mode and Select mode",
      },
      {
        tag = "v_<BS>",
        key = "<BS>",
        description = "2  Select mode: delete highlighted area",
      },
      {
        tag = "v_CTRL-H",
        key = "CTRL-H",
        description = "2  same as <BS>",
      },
      {
        tag = "v_CTRL-O",
        key = "CTRL-O",
        description = "switch from Select to Visual mode for one command",
      },
      {
        tag = "v_CTRL-V",
        key = "CTRL-V",
        description = "make Visual mode blockwise or stop Visual mode",
      },
      {
        tag = "v_CTRL-X",
        key = "CTRL-X",
        description = "2  subtract N from number in highlighted text",
      },
      {
        tag = "v_<Esc>",
        key = "<Esc>",
        description = "stop Visual mode",
      },
      {
        tag = "v_CTRL-]",
        key = "CTRL-]",
        description = "jump to highlighted tag",
      },
      {
        tag = "v_!",
        key = "!{filter}",
        description = "2  filter the highlighted lines through the external command {filter}",
      },
      {
        tag = "v_:",
        key = ":",
        description = "start a command-line with the highlighted lines as a range",
      },
      {
        tag = "v_<",
        key = "<",
        description = "2  shift the highlighted lines one 'shiftwidth' left",
      },
      {
        tag = "v_=",
        key = "=",
        description = "2  filter the highlighted lines through the external program given with the 'equalprg' option",
      },
      {
        tag = "v_>",
        key = ">",
        description = "2  shift the highlighted lines one 'shiftwidth' right",
      },
      {
        tag = "v_b_A",
        key = "A",
        description = "2  block mode: append same text in all lines, after the highlighted area",
      },
      {
        tag = "v_C",
        key = "C",
        description = "2  delete the highlighted lines and start insert",
      },
      {
        tag = "v_D",
        key = "D",
        description = "2  delete the highlighted lines",
      },
      {
        tag = "v_b_I",
        key = "I",
        description = "2  block mode: insert same text in all lines, before the highlighted area",
      },
      {
        tag = "v_J",
        key = "J",
        description = "2  join the highlighted lines",
      },
      {
        tag = "v_K",
        key = "K",
        description = "run 'keywordprg' on the highlighted area",
      },
      {
        tag = "v_O",
        key = "O",
        description = "move horizontally to other corner of area",
      },
      {
        tag = "v_P",
        key = "P",
        description = "replace highlighted area with register contents; registers are unchanged",
      },
      {
        tag = "v_R",
        key = "R",
        description = "2  delete the highlighted lines and start insert",
      },
      {
        tag = "v_S",
        key = "S",
        description = "2  delete the highlighted lines and start insert",
      },
      {
        tag = "v_U",
        key = "U",
        description = "2  make highlighted area uppercase",
      },
      {
        tag = "v_V",
        key = "V",
        description = "make Visual mode linewise or stop Visual mode",
      },
      {
        tag = "v_X",
        key = "X",
        description = "2  delete the highlighted lines",
      },
      {
        tag = "v_Y",
        key = "Y",
        description = "yank the highlighted lines",
      },
      {
        tag = "v_aquote",
        key = 'a"',
        description = "extend highlighted area with a double quoted string",
      },
      {
        tag = "v_a'",
        key = "a'",
        description = "extend highlighted area with a single quoted string",
      },
      {
        tag = "v_a(",
        key = "a(",
        description = "same as ab",
      },
      {
        tag = "v_a)",
        key = "a)",
        description = "same as ab",
      },
      {
        tag = "v_a<",
        key = "a<",
        description = "extend highlighted area with a <> block",
      },
      {
        tag = "v_a>",
        key = "a>",
        description = "same as a<",
      },
      {
        tag = "v_aB",
        key = "aB",
        description = "extend highlighted area with a {} block",
      },
      {
        tag = "v_aW",
        key = "aW",
        description = 'extend highlighted area with "a WORD"',
      },
      {
        tag = "v_a[",
        key = "a[",
        description = "extend highlighted area with a [] block",
      },
      {
        tag = "v_a]",
        key = "a]",
        description = "same as a[",
      },
      {
        tag = "v_a`",
        key = "a`",
        description = "extend highlighted area with a backtick quoted string",
      },
      {
        tag = "v_ab",
        key = "ab",
        description = "extend highlighted area with a () block",
      },
      {
        tag = "v_ap",
        key = "ap",
        description = "extend highlighted area with a paragraph",
      },
      {
        tag = "v_as",
        key = "as",
        description = "extend highlighted area with a sentence",
      },
      {
        tag = "v_at",
        key = "at",
        description = "extend highlighted area with a tag block",
      },
      {
        tag = "v_aw",
        key = "aw",
        description = 'extend highlighted area with "a word"',
      },
      {
        tag = "v_a{",
        key = "a{",
        description = "same as aB",
      },
      {
        tag = "v_a}",
        key = "a}",
        description = "same as aB",
      },
      {
        tag = "v_c",
        key = "c",
        description = "2  delete highlighted area and start insert",
      },
      {
        tag = "v_d",
        key = "d",
        description = "2  delete highlighted area",
      },
      {
        tag = "v_g_CTRL-A",
        key = "g CTRL-A",
        description = "2  add N to number in highlighted text",
      },
      {
        tag = "v_g_CTRL-X",
        key = "g CTRL-X",
        description = "2  subtract N from number in highlighted text",
      },
      {
        tag = "v_gJ",
        key = "gJ",
        description = "2  join the highlighted lines without inserting spaces",
      },
      {
        tag = "v_gq",
        key = "gq",
        description = "2  format the highlighted lines",
      },
      {
        tag = "v_gv",
        key = "gv",
        description = "exchange current and previous highlighted area",
      },
      {
        tag = "v_iquote",
        key = 'i"',
        description = "extend highlighted area with a double quoted string (without quotes)",
      },
      {
        tag = "v_i'",
        key = "i'",
        description = "extend highlighted area with a single quoted string (without quotes)",
      },
      {
        tag = "v_i(",
        key = "i(",
        description = "same as ib",
      },
      {
        tag = "v_i)",
        key = "i)",
        description = "same as ib",
      },
      {
        tag = "v_i<",
        key = "i<",
        description = "extend highlighted area with inner <> block",
      },
      {
        tag = "v_i>",
        key = "i>",
        description = "same as i<",
      },
      {
        tag = "v_iB",
        key = "iB",
        description = "extend highlighted area with inner {} block",
      },
      {
        tag = "v_iW",
        key = "iW",
        description = 'extend highlighted area with "inner WORD"',
      },
      {
        tag = "v_i[",
        key = "i[",
        description = "extend highlighted area with inner [] block",
      },
      {
        tag = "v_i]",
        key = "i]",
        description = "same as i[",
      },
      {
        tag = "v_i`",
        key = "i`",
        description = "extend highlighted area with a backtick quoted string (without the backticks)",
      },
      {
        tag = "v_ib",
        key = "ib",
        description = "extend highlighted area with inner () block",
      },
      {
        tag = "v_ip",
        key = "ip",
        description = "extend highlighted area with inner paragraph",
      },
      {
        tag = "v_is",
        key = "is",
        description = "extend highlighted area with inner sentence",
      },
      {
        tag = "v_it",
        key = "it",
        description = "extend highlighted area with inner tag block",
      },
      {
        tag = "v_iw",
        key = "iw",
        description = 'extend highlighted area with "inner word"',
      },
      {
        tag = "v_i{",
        key = "i{",
        description = "same as iB",
      },
      {
        tag = "v_i}",
        key = "i}",
        description = "same as iB",
      },
      {
        tag = "v_o",
        key = "o",
        description = "move cursor to other corner of area",
      },
      {
        tag = "v_p",
        key = "p",
        description = "replace highlighted area with register contents; deleted text in unnamed register",
      },
      {
        tag = "v_r",
        key = "r",
        description = "2  replace highlighted area with a character",
      },
      {
        tag = "v_s",
        key = "s",
        description = "2  delete highlighted area and start insert",
      },
      {
        tag = "v_u",
        key = "u",
        description = "2  make highlighted area lowercase",
      },
      {
        tag = "v_v",
        key = "v",
        description = "make Visual mode charwise or stop Visual mode",
      },
      {
        tag = "v_x",
        key = "x",
        description = "2  delete the highlighted area",
      },
      {
        tag = "v_y",
        key = "y",
        description = "yank the highlighted area",
      },
      {
        tag = "v_~",
        key = "~",
        description = "2  swap case for the highlighted area",
      },
    },
  },
  {
    number = "4.",
    name = "Command-line editing",
    tag = "ex-edit-index",
    mappings = {
      {
        tag = "",
        key = "CTRL-@",
        description = "not used",
      },
      {
        tag = "c_CTRL-A",
        key = "CTRL-A",
        description = "do completion on the pattern in front of the cursor and insert all matches",
      },
      {
        tag = "c_CTRL-B",
        key = "CTRL-B",
        description = "cursor to begin of command-line",
      },
      {
        tag = "c_CTRL-C",
        key = "CTRL-C",
        description = "same as <Esc>",
      },
      {
        tag = "c_CTRL-D",
        key = "CTRL-D",
        description = "list completions that match the pattern in front of the cursor",
      },
      {
        tag = "c_CTRL-E",
        key = "CTRL-E",
        description = "cursor to end of command-line",
      },
      {
        tag = "c_CTRL-G",
        key = "CTRL-G",
        description = "next match when 'incsearch' is active",
      },
      {
        tag = "c_<BS>",
        key = "<BS>",
        description = "delete the character in front of the cursor",
      },
      {
        tag = "c_digraph",
        key = "{char1} <BS> {char2}",
        description = "enter digraph when 'digraph' is on",
      },
      {
        tag = "c_CTRL-H",
        key = "CTRL-H",
        description = "same as <BS>",
      },
      {
        tag = "c_<Tab>",
        key = "<Tab>",
        description = "if 'wildchar' is <Tab>: Do completion on the pattern in front of the cursor",
      },
      {
        tag = "c_<S-Tab>",
        key = "<S-Tab>",
        description = "same as CTRL-P",
      },
      {
        tag = "c_wildchar",
        key = "'wildchar'",
        description = "Do completion on the pattern in front of the cursor (default: <Tab>)",
      },
      {
        tag = "c_CTRL-I",
        key = "CTRL-I",
        description = "same as <Tab>",
      },
      {
        tag = "c_<NL>",
        key = "<NL>",
        description = "same as <CR>",
      },
      {
        tag = "c_CTRL-J",
        key = "CTRL-J",
        description = "same as <CR>",
      },
      {
        tag = "c_CTRL-K",
        key = "CTRL-K {char1} {char2}",
        description = "enter digraph",
      },
      {
        tag = "c_CTRL-L",
        key = "CTRL-L",
        description = "do completion on the pattern in front of the cursor and insert the longest common part",
      },
      {
        tag = "c_<CR>",
        key = "<CR>",
        description = "execute entered command",
      },
      {
        tag = "c_CTRL-M",
        key = "CTRL-M",
        description = "same as <CR>",
      },
      {
        tag = "c_CTRL-N",
        key = "CTRL-N",
        description = "after using 'wildchar' with multiple matches: go to next match, otherwise: recall older command-line from history. CTRL-O\9\9not used",
      },
      {
        tag = "c_CTRL-P",
        key = "CTRL-P",
        description = "after using 'wildchar' with multiple matches: go to previous match, otherwise: recall older command-line from history.",
      },
      {
        tag = "c_CTRL-Q",
        key = "CTRL-Q",
        description = "same as CTRL-V, unless it's used for terminal control flow",
      },
      {
        tag = "c_CTRL-R",
        key = "CTRL-R {regname}",
        description = "insert the contents of a register or object under the cursor as if typed",
      },
      {
        tag = "c_CTRL-R_CTRL-R",
        key = "CTRL-R CTRL-R {regname}",
        description = "",
      },
      {
        tag = "c_CTRL-R_CTRL-O",
        key = "CTRL-R CTRL-O {regname}",
        description = "insert the contents of a register or object under the cursor literally CTRL-S\9\9not used, or used for terminal control flow",
      },
      {
        tag = "c_CTRL-T",
        key = "CTRL-T",
        description = "previous match when 'incsearch' is active",
      },
      {
        tag = "c_CTRL-U",
        key = "CTRL-U",
        description = "remove all characters",
      },
      {
        tag = "c_CTRL-V",
        key = "CTRL-V",
        description = "insert next non-digit literally, insert three digit decimal number as a single byte.",
      },
      {
        tag = "c_CTRL-W",
        key = "CTRL-W",
        description = "delete the word in front of the cursor CTRL-X\9\9not used (reserved for completion) CTRL-Y\9\9copy (yank) modeless selection CTRL-Z\9\9not used (reserved for suspend)",
      },
      {
        tag = "c_<Esc>",
        key = "<Esc>",
        description = "abandon command-line without executing it",
      },
      {
        tag = "c_CTRL-[",
        key = "CTRL-[",
        description = "same as <Esc>",
      },
      {
        tag = "c_CTRL-\\_CTRL-N",
        key = "CTRL-\\ CTRL-N",
        description = "go to Normal mode, abandon command-line",
      },
      {
        tag = "c_CTRL-\\_CTRL-G",
        key = "CTRL-\\ CTRL-G",
        description = "go to Normal mode, abandon command-line CTRL-\\ a - d\9reserved for extensions",
      },
      {
        tag = "c_CTRL-\\_e",
        key = "CTRL-\\ e {expr} replace the command line with the result of",
        description = "{expr} CTRL-\\ f - z\9reserved for extensions CTRL-\\ others\9not used",
      },
      {
        tag = "c_CTRL-]",
        key = "CTRL-]",
        description = "trigger abbreviation",
      },
      {
        tag = "c_CTRL-^",
        key = "CTRL-^",
        description = "toggle use of |:lmap| mappings",
      },
      {
        tag = "c_<Del>",
        key = "<Del>",
        description = "delete the character under the cursor",
      },
      {
        tag = "c_<Left>",
        key = "<Left>",
        description = "cursor left",
      },
      {
        tag = "c_<S-Left>",
        key = "<S-Left>",
        description = "cursor one word left",
      },
      {
        tag = "c_<C-Left>",
        key = "<C-Left>",
        description = "cursor one word left",
      },
      {
        tag = "c_<Right>",
        key = "<Right>",
        description = "cursor right",
      },
      {
        tag = "c_<S-Right>",
        key = "<S-Right>",
        description = "cursor one word right",
      },
      {
        tag = "c_<C-Right>",
        key = "<C-Right>",
        description = "cursor one word right",
      },
      {
        tag = "c_<Up>",
        key = "<Up>",
        description = "recall previous command-line from history that matches pattern in front of the cursor",
      },
      {
        tag = "c_<S-Up>",
        key = "<S-Up>",
        description = "recall previous command-line from history",
      },
      {
        tag = "c_<Down>",
        key = "<Down>",
        description = "recall next command-line from history that matches pattern in front of the cursor",
      },
      {
        tag = "c_<S-Down>",
        key = "<S-Down>",
        description = "recall next command-line from history",
      },
      {
        tag = "c_<Home>",
        key = "<Home>",
        description = "cursor to start of command-line",
      },
      {
        tag = "c_<End>",
        key = "<End>",
        description = "cursor to end of command-line",
      },
      {
        tag = "c_<PageDown>",
        key = "<PageDown>",
        description = "same as <S-Down>",
      },
      {
        tag = "c_<PageUp>",
        key = "<PageUp>",
        description = "same as <S-Up>",
      },
      {
        tag = "c_<Insert>",
        key = "<Insert>",
        description = "toggle insert/overstrike mode",
      },
      {
        tag = "c_<LeftMouse>",
        key = "<LeftMouse>",
        description = "cursor at mouse click",
      },
      {
        tag = "",
        key = "<Up>",
        description = "move up to parent <Down>\9\9move down to submenu <Left>\9\9select the previous match <Right>\9\9select the next match <CR>\9\9move into submenu when doing menu completion CTRL-E\9\9stop completion and go back to original text CTRL-Y\9\9accept selected match and stop completion other\9\9stop completion and insert the typed character",
      },
      {
        tag = "",
        key = "<PageUp>",
        description = "select a match several entries back <PageDown>\9select a match several entries forward",
      },
    },
  },
  {
    number = "5.",
    name = "Terminal mode",
    tag = "terminal-mode-index",
    mappings = {},
  },
  {
    number = "6.",
    name = "EX commands",
    tag = "Ex-commands",
    mappings = {
      {
        tag = ":",
        key = ":",
        description = "nothing",
      },
      {
        tag = ":range",
        key = ":{range}",
        description = "go to last line in {range}",
      },
      {
        tag = ":!",
        key = ":!",
        description = "filter lines or execute an external command",
      },
      {
        tag = ":!!",
        key = ":!!",
        description = 'repeat last ":!" command',
      },
      {
        tag = ":#",
        key = ":#",
        description = 'same as ":number"',
      },
      {
        tag = ":&",
        key = ":&",
        description = 'repeat last ":substitute"',
      },
      {
        tag = ":star",
        key = ":*",
        description = "use the last Visual area, like \":'<,'>\"",
      },
      {
        tag = ":<",
        key = ":<",
        description = "shift lines one 'shiftwidth' left",
      },
      {
        tag = ":=",
        key = ":=",
        description = "print the last line number",
      },
      {
        tag = ":>",
        key = ":>",
        description = "shift lines one 'shiftwidth' right",
      },
      {
        tag = ":@",
        key = ":@",
        description = "execute contents of a register",
      },
      {
        tag = ":@@",
        key = ":@@",
        description = 'repeat the previous ":@"',
      },
      {
        tag = ":2match",
        key = ":2mat[ch]",
        description = "define a second match to highlight",
      },
      {
        tag = ":3match",
        key = ":3mat[ch]",
        description = "define a third match to highlight",
      },
      {
        tag = ":Next",
        key = ":N[ext]",
        description = "go to previous file in the argument list",
      },
      {
        tag = ":append",
        key = ":a[ppend]",
        description = "append text",
      },
      {
        tag = ":abbreviate",
        key = ":ab[breviate]",
        description = "enter abbreviation",
      },
      {
        tag = ":abclear",
        key = ":abc[lear]",
        description = "remove all abbreviations",
      },
      {
        tag = ":aboveleft",
        key = ":abo[veleft]",
        description = "make split window appear left or above",
      },
      {
        tag = ":all",
        key = ":al[l]",
        description = "open a window for each file in the argument list",
      },
      {
        tag = ":amenu",
        key = ":am[enu]",
        description = "enter new menu item for all modes",
      },
      {
        tag = ":anoremenu",
        key = ":an[oremenu]",
        description = "enter a new menu for all modes that will not be remapped",
      },
      {
        tag = ":args",
        key = ":ar[gs]",
        description = "print the argument list",
      },
      {
        tag = ":argadd",
        key = ":arga[dd]",
        description = "add items to the argument list",
      },
      {
        tag = ":argdedupe",
        key = ":argded[upe]",
        description = "remove duplicates from the argument list",
      },
      {
        tag = ":argdelete",
        key = ":argd[elete]",
        description = "delete items from the argument list",
      },
      {
        tag = ":argedit",
        key = ":arge[dit]",
        description = "add item to the argument list and edit it",
      },
      {
        tag = ":argdo",
        key = ":argdo",
        description = "do a command on all items in the argument list",
      },
      {
        tag = ":argglobal",
        key = ":argg[lobal]",
        description = "define the global argument list",
      },
      {
        tag = ":arglocal",
        key = ":argl[ocal]",
        description = "define a local argument list",
      },
      {
        tag = ":argument",
        key = ":argu[ment]",
        description = "go to specific file in the argument list",
      },
      {
        tag = ":ascii",
        key = ":as[cii]",
        description = "print ascii value of character under the cursor",
      },
      {
        tag = ":autocmd",
        key = ":au[tocmd]",
        description = "enter or show autocommands",
      },
      {
        tag = ":augroup",
        key = ":aug[roup]",
        description = "select the autocommand group to use",
      },
      {
        tag = ":aunmenu",
        key = ":aun[menu]",
        description = "remove menu for all modes",
      },
      {
        tag = ":buffer",
        key = ":b[uffer]",
        description = "go to specific buffer in the buffer list",
      },
      {
        tag = ":bNext",
        key = ":bN[ext]",
        description = "go to previous buffer in the buffer list",
      },
      {
        tag = ":ball",
        key = ":ba[ll]",
        description = "open a window for each buffer in the buffer list",
      },
      {
        tag = ":badd",
        key = ":bad[d]",
        description = "add buffer to the buffer list",
      },
      {
        tag = ":balt",
        key = ":balt",
        description = 'like ":badd" but also set the alternate file',
      },
      {
        tag = ":bdelete",
        key = ":bd[elete]",
        description = "remove a buffer from the buffer list",
      },
      {
        tag = ":belowright",
        key = ":bel[owright]",
        description = "make split window appear right or below",
      },
      {
        tag = ":bfirst",
        key = ":bf[irst]",
        description = "go to first buffer in the buffer list",
      },
      {
        tag = ":blast",
        key = ":bl[ast]",
        description = "go to last buffer in the buffer list",
      },
      {
        tag = ":bmodified",
        key = ":bm[odified]",
        description = "go to next buffer in the buffer list that has been modified",
      },
      {
        tag = ":bnext",
        key = ":bn[ext]",
        description = "go to next buffer in the buffer list",
      },
      {
        tag = ":botright",
        key = ":bo[tright]",
        description = "make split window appear at bottom or far right",
      },
      {
        tag = ":bprevious",
        key = ":bp[revious]",
        description = "go to previous buffer in the buffer list",
      },
      {
        tag = ":brewind",
        key = ":br[ewind]",
        description = "go to first buffer in the buffer list",
      },
      {
        tag = ":break",
        key = ":brea[k]",
        description = "break out of while loop",
      },
      {
        tag = ":breakadd",
        key = ":breaka[dd]",
        description = "add a debugger breakpoint",
      },
      {
        tag = ":breakdel",
        key = ":breakd[el]",
        description = "delete a debugger breakpoint",
      },
      {
        tag = ":breaklist",
        key = ":breakl[ist]",
        description = "list debugger breakpoints",
      },
      {
        tag = ":browse",
        key = ":bro[wse]",
        description = "use file selection dialog",
      },
      {
        tag = ":bufdo",
        key = ":bufd[o]",
        description = "execute command in each listed buffer",
      },
      {
        tag = ":buffers",
        key = ":buffers",
        description = "list all files in the buffer list",
      },
      {
        tag = ":bunload",
        key = ":bun[load]",
        description = "unload a specific buffer",
      },
      {
        tag = ":bwipeout",
        key = ":bw[ipeout]",
        description = "really delete a buffer",
      },
      {
        tag = ":change",
        key = ":c[hange]",
        description = "replace a line or series of lines",
      },
      {
        tag = ":cNext",
        key = ":cN[ext]",
        description = "go to previous error",
      },
      {
        tag = ":cNfile",
        key = ":cNf[ile]",
        description = "go to last error in previous file",
      },
      {
        tag = ":cabbrev",
        key = ":ca[bbrev]",
        description = 'like ":abbreviate" but for Command-line mode',
      },
      {
        tag = ":cabclear",
        key = ":cabc[lear]",
        description = "clear all abbreviations for Command-line mode",
      },
      {
        tag = ":cabove",
        key = ":cabo[ve]",
        description = "go to error above current line",
      },
      {
        tag = ":caddbuffer",
        key = ":cad[dbuffer]",
        description = "add errors from buffer",
      },
      {
        tag = ":caddexpr",
        key = ":cadde[xpr]",
        description = "add errors from expr",
      },
      {
        tag = ":caddfile",
        key = ":caddf[ile]",
        description = "add error message to current quickfix list",
      },
      {
        tag = ":cafter",
        key = ":caf[ter]",
        description = "go to error after current cursor",
      },
      {
        tag = ":call",
        key = ":cal[l]",
        description = "call a function",
      },
      {
        tag = ":catch",
        key = ":cat[ch]",
        description = "part of a :try command",
      },
      {
        tag = ":cbefore",
        key = ":cbe[fore]",
        description = "go to error before current cursor",
      },
      {
        tag = ":cbelow",
        key = ":cbel[ow]",
        description = "go to error below current line",
      },
      {
        tag = ":cbottom",
        key = ":cbo[ttom]",
        description = "scroll to the bottom of the quickfix window",
      },
      {
        tag = ":cbuffer",
        key = ":cb[uffer]",
        description = "parse error messages and jump to first error",
      },
      {
        tag = ":cc",
        key = ":cc",
        description = "go to specific error",
      },
      {
        tag = ":cclose",
        key = ":ccl[ose]",
        description = "close quickfix window",
      },
      {
        tag = ":cd",
        key = ":cd",
        description = "change directory",
      },
      {
        tag = ":cdo",
        key = ":cdo",
        description = "execute command in each valid error list entry",
      },
      {
        tag = ":cfdo",
        key = ":cfd[o]",
        description = "execute command in each file in error list",
      },
      {
        tag = ":center",
        key = ":ce[nter]",
        description = "format lines at the center",
      },
      {
        tag = ":cexpr",
        key = ":cex[pr]",
        description = "read errors from expr and jump to first",
      },
      {
        tag = ":cfile",
        key = ":cf[ile]",
        description = "read file with error messages and jump to first",
      },
      {
        tag = ":cfirst",
        key = ":cfir[st]",
        description = "go to the specified error, default first one",
      },
      {
        tag = ":cgetbuffer",
        key = ":cgetb[uffer]",
        description = "get errors from buffer",
      },
      {
        tag = ":cgetexpr",
        key = ":cgete[xpr]",
        description = "get errors from expr",
      },
      {
        tag = ":cgetfile",
        key = ":cg[etfile]",
        description = "read file with error messages",
      },
      {
        tag = ":changes",
        key = ":changes",
        description = "print the change list",
      },
      {
        tag = ":chdir",
        key = ":chd[ir]",
        description = "change directory",
      },
      {
        tag = ":checkhealth",
        key = ":che[ckhealth]",
        description = "run healthchecks",
      },
      {
        tag = ":checkpath",
        key = ":checkp[ath]",
        description = "list included files",
      },
      {
        tag = ":checktime",
        key = ":checkt[ime]",
        description = "check timestamp of loaded buffers",
      },
      {
        tag = ":chistory",
        key = ":chi[story]",
        description = "list the error lists",
      },
      {
        tag = ":clast",
        key = ":cla[st]",
        description = "go to the specified error, default last one",
      },
      {
        tag = ":clearjumps",
        key = ":cle[arjumps]",
        description = "clear the jump list",
      },
      {
        tag = ":clist",
        key = ":cl[ist]",
        description = "list all errors",
      },
      {
        tag = ":close",
        key = ":clo[se]",
        description = "close current window",
      },
      {
        tag = ":cmap",
        key = ":cm[ap]",
        description = 'like ":map" but for Command-line mode',
      },
      {
        tag = ":cmapclear",
        key = ":cmapc[lear]",
        description = "clear all mappings for Command-line mode",
      },
      {
        tag = ":cmenu",
        key = ":cme[nu]",
        description = "add menu for Command-line mode",
      },
      {
        tag = ":cnext",
        key = ":cn[ext]",
        description = "go to next error",
      },
      {
        tag = ":cnewer",
        key = ":cnew[er]",
        description = "go to newer error list",
      },
      {
        tag = ":cnfile",
        key = ":cnf[ile]",
        description = "go to first error in next file",
      },
      {
        tag = ":cnoremap",
        key = ":cno[remap]",
        description = 'like ":noremap" but for Command-line mode',
      },
      {
        tag = ":cnoreabbrev",
        key = ":cnorea[bbrev]",
        description = 'like ":noreabbrev" but for Command-line mode',
      },
      {
        tag = ":cnoremenu",
        key = ":cnoreme[nu]",
        description = 'like ":noremenu" but for Command-line mode',
      },
      {
        tag = ":copy",
        key = ":co[py]",
        description = "copy lines",
      },
      {
        tag = ":colder",
        key = ":col[der]",
        description = "go to older error list",
      },
      {
        tag = ":colorscheme",
        key = ":colo[rscheme]",
        description = "load a specific color scheme",
      },
      {
        tag = ":command",
        key = ":com[mand]",
        description = "create user-defined command",
      },
      {
        tag = ":comclear",
        key = ":comc[lear]",
        description = "clear all user-defined commands",
      },
      {
        tag = ":compiler",
        key = ":comp[iler]",
        description = "do settings for a specific compiler",
      },
      {
        tag = ":continue",
        key = ":con[tinue]",
        description = "go back to :while",
      },
      {
        tag = ":confirm",
        key = ":conf[irm]",
        description = "prompt user when confirmation required",
      },
      {
        tag = ":const",
        key = ":cons[t]",
        description = "create a variable as a constant",
      },
      {
        tag = ":copen",
        key = ":cope[n]",
        description = "open quickfix window",
      },
      {
        tag = ":cprevious",
        key = ":cp[revious]",
        description = "go to previous error",
      },
      {
        tag = ":cpfile",
        key = ":cpf[ile]",
        description = "go to last error in previous file",
      },
      {
        tag = ":cquit",
        key = ":cq[uit]",
        description = "quit Vim with an error code",
      },
      {
        tag = ":crewind",
        key = ":cr[ewind]",
        description = "go to the specified error, default first one",
      },
      {
        tag = ":cunmap",
        key = ":cu[nmap]",
        description = 'like ":unmap" but for Command-line mode',
      },
      {
        tag = ":cunabbrev",
        key = ":cuna[bbrev]",
        description = 'like ":unabbrev" but for Command-line mode',
      },
      {
        tag = ":cunmenu",
        key = ":cunme[nu]",
        description = "remove menu for Command-line mode",
      },
      {
        tag = ":cwindow",
        key = ":cw[indow]",
        description = "open or close quickfix window",
      },
      {
        tag = ":delete",
        key = ":d[elete]",
        description = "delete lines",
      },
      {
        tag = ":debug",
        key = ":deb[ug]",
        description = "run a command in debugging mode",
      },
      {
        tag = ":debuggreedy",
        key = ":debugg[reedy]",
        description = "read debug mode commands from normal input",
      },
      {
        tag = ":defer",
        key = ":defe[r]",
        description = "call function when current function is done",
      },
      {
        tag = ":delcommand",
        key = ":delc[ommand]",
        description = "delete user-defined command",
      },
      {
        tag = ":delfunction",
        key = ":delf[unction]",
        description = "delete a user function",
      },
      {
        tag = ":delmarks",
        key = ":delm[arks]",
        description = "delete marks",
      },
      {
        tag = ":detach",
        key = ":detach",
        description = "detach the current UI",
      },
      {
        tag = ":diffupdate",
        key = ":dif[fupdate]",
        description = "update 'diff' buffers",
      },
      {
        tag = ":diffget",
        key = ":diffg[et]",
        description = "remove differences in current buffer",
      },
      {
        tag = ":diffoff",
        key = ":diffo[ff]",
        description = "switch off diff mode",
      },
      {
        tag = ":diffpatch",
        key = ":diffp[atch]",
        description = "apply a patch and show differences",
      },
      {
        tag = ":diffput",
        key = ":diffpu[t]",
        description = "remove differences in other buffer",
      },
      {
        tag = ":diffsplit",
        key = ":diffs[plit]",
        description = "show differences with another file",
      },
      {
        tag = ":diffthis",
        key = ":difft[his]",
        description = "make current window a diff window",
      },
      {
        tag = ":digraphs",
        key = ":dig[raphs]",
        description = "show or enter digraphs",
      },
      {
        tag = ":display",
        key = ":di[splay]",
        description = "display registers",
      },
      {
        tag = ":djump",
        key = ":dj[ump]",
        description = "jump to #define",
      },
      {
        tag = ":dl",
        key = ":dl",
        description = "short for |:delete| with the 'l' flag",
      },
      {
        tag = ":dlist",
        key = ":dli[st]",
        description = "list #defines",
      },
      {
        tag = ":doautocmd",
        key = ":do[autocmd]",
        description = "apply autocommands to current buffer",
      },
      {
        tag = ":doautoall",
        key = ":doautoa[ll]",
        description = "apply autocommands for all loaded buffers",
      },
      {
        tag = ":dp",
        key = ":d[elete]p",
        description = "short for |:delete| with the 'p' flag",
      },
      {
        tag = ":drop",
        key = ":dr[op]",
        description = "jump to window editing file or edit file in current window",
      },
      {
        tag = ":dsearch",
        key = ":ds[earch]",
        description = "list one #define",
      },
      {
        tag = ":dsplit",
        key = ":dsp[lit]",
        description = "split window and jump to #define",
      },
      {
        tag = ":edit",
        key = ":e[dit]",
        description = "edit a file",
      },
      {
        tag = ":earlier",
        key = ":ea[rlier]",
        description = "go to older change, undo",
      },
      {
        tag = ":echo",
        key = ":ec[ho]",
        description = "echoes the result of expressions",
      },
      {
        tag = ":echoerr",
        key = ":echoe[rr]",
        description = "like :echo, show like an error and use history",
      },
      {
        tag = ":echohl",
        key = ":echoh[l]",
        description = "set highlighting for echo commands",
      },
      {
        tag = ":echomsg",
        key = ":echom[sg]",
        description = "same as :echo, put message in history",
      },
      {
        tag = ":echon",
        key = ":echon",
        description = "same as :echo, but without <EOL>",
      },
      {
        tag = ":else",
        key = ":el[se]",
        description = "part of an :if command",
      },
      {
        tag = ":elseif",
        key = ":elsei[f]",
        description = "part of an :if command",
      },
      {
        tag = ":emenu",
        key = ":em[enu]",
        description = "execute a menu by name",
      },
      {
        tag = ":endif",
        key = ":en[dif]",
        description = "end previous :if",
      },
      {
        tag = ":endfor",
        key = ":endfo[r]",
        description = "end previous :for",
      },
      {
        tag = ":endfunction",
        key = ":endf[unction]",
        description = "end of a user function started with :function",
      },
      {
        tag = ":endtry",
        key = ":endt[ry]",
        description = "end previous :try",
      },
      {
        tag = ":endwhile",
        key = ":endw[hile]",
        description = "end previous :while",
      },
      {
        tag = ":enew",
        key = ":ene[w]",
        description = "edit a new, unnamed buffer",
      },
      {
        tag = ":eval",
        key = ":ev[al]",
        description = "evaluate an expression and discard the result",
      },
      {
        tag = ":ex",
        key = ":ex",
        description = 'same as ":edit"',
      },
      {
        tag = ":execute",
        key = ":exe[cute]",
        description = "execute result of expressions",
      },
      {
        tag = ":exit",
        key = ":exi[t]",
        description = 'same as ":xit"',
      },
      {
        tag = ":exusage",
        key = ":exu[sage]",
        description = "overview of Ex commands",
      },
      {
        tag = ":fclose",
        key = ":fc[lose]",
        description = "close floating window",
      },
      {
        tag = ":file",
        key = ":f[ile]",
        description = "show or set the current file name",
      },
      {
        tag = ":files",
        key = ":files",
        description = "list all files in the buffer list",
      },
      {
        tag = ":filetype",
        key = ":filet[ype]",
        description = "switch file type detection on/off",
      },
      {
        tag = ":filter",
        key = ":filt[er]",
        description = "filter output of following command",
      },
      {
        tag = ":find",
        key = ":fin[d]",
        description = "find file in 'path' and edit it",
      },
      {
        tag = ":finally",
        key = ":fina[lly]",
        description = "part of a :try command",
      },
      {
        tag = ":finish",
        key = ":fini[sh]",
        description = "quit sourcing a Vim script",
      },
      {
        tag = ":first",
        key = ":fir[st]",
        description = "go to the first file in the argument list",
      },
      {
        tag = ":fold",
        key = ":fo[ld]",
        description = "create a fold",
      },
      {
        tag = ":foldclose",
        key = ":foldc[lose]",
        description = "close folds",
      },
      {
        tag = ":folddoopen",
        key = ":foldd[oopen]",
        description = "execute command on lines not in a closed fold",
      },
      {
        tag = ":folddoclosed",
        key = ":folddoc[losed]",
        description = "execute command on lines in a closed fold",
      },
      {
        tag = ":foldopen",
        key = ":foldo[pen]",
        description = "open folds",
      },
      {
        tag = ":for",
        key = ":for",
        description = "for loop",
      },
      {
        tag = ":function",
        key = ":fu[nction]",
        description = "define a user function",
      },
      {
        tag = ":global",
        key = ":g[lobal]",
        description = "execute commands for matching lines",
      },
      {
        tag = ":goto",
        key = ":go[to]",
        description = "go to byte in the buffer",
      },
      {
        tag = ":grep",
        key = ":gr[ep]",
        description = "run 'grepprg' and jump to first match",
      },
      {
        tag = ":grepadd",
        key = ":grepa[dd]",
        description = "like :grep, but append to current list",
      },
      {
        tag = ":gui",
        key = ":gu[i]",
        description = "start the GUI",
      },
      {
        tag = ":gvim",
        key = ":gv[im]",
        description = "start the GUI",
      },
      {
        tag = ":help",
        key = ":h[elp]",
        description = "open a help window",
      },
      {
        tag = ":helpclose",
        key = ":helpc[lose]",
        description = "close one help window",
      },
      {
        tag = ":helpgrep",
        key = ":helpg[rep]",
        description = 'like ":grep" but searches help files',
      },
      {
        tag = ":helptags",
        key = ":helpt[ags]",
        description = "generate help tags for a directory",
      },
      {
        tag = ":highlight",
        key = ":hi[ghlight]",
        description = "specify highlighting methods",
      },
      {
        tag = ":hide",
        key = ":hid[e]",
        description = "hide current buffer for a command",
      },
      {
        tag = ":history",
        key = ":his[tory]",
        description = "print a history list",
      },
      {
        tag = ":horizontal",
        key = ":hor[izontal]",
        description = "following window command work horizontally",
      },
      {
        tag = ":insert",
        key = ":i[nsert]",
        description = "insert text",
      },
      {
        tag = ":iabbrev",
        key = ":ia[bbrev]",
        description = 'like ":abbrev" but for Insert mode',
      },
      {
        tag = ":iabclear",
        key = ":iabc[lear]",
        description = 'like ":abclear" but for Insert mode',
      },
      {
        tag = ":if",
        key = ":if",
        description = "execute commands when condition met",
      },
      {
        tag = ":ijump",
        key = ":ij[ump]",
        description = "jump to definition of identifier",
      },
      {
        tag = ":ilist",
        key = ":il[ist]",
        description = "list lines where identifier matches",
      },
      {
        tag = ":imap",
        key = ":im[ap]",
        description = 'like ":map" but for Insert mode',
      },
      {
        tag = ":imapclear",
        key = ":imapc[lear]",
        description = 'like ":mapclear" but for Insert mode',
      },
      {
        tag = ":imenu",
        key = ":ime[nu]",
        description = "add menu for Insert mode",
      },
      {
        tag = ":inoremap",
        key = ":ino[remap]",
        description = 'like ":noremap" but for Insert mode',
      },
      {
        tag = ":inoreabbrev",
        key = ":inorea[bbrev]",
        description = 'like ":noreabbrev" but for Insert mode',
      },
      {
        tag = ":inoremenu",
        key = ":inoreme[nu]",
        description = 'like ":noremenu" but for Insert mode',
      },
      {
        tag = ":intro",
        key = ":int[ro]",
        description = "print the introductory message",
      },
      {
        tag = ":iput",
        key = ":ip[ut]",
        description = "like |:put|, but adjust the indent to the current line",
      },
      {
        tag = ":isearch",
        key = ":is[earch]",
        description = "list one line where identifier matches",
      },
      {
        tag = ":isplit",
        key = ":isp[lit]",
        description = "split window and jump to definition of identifier",
      },
      {
        tag = ":iunmap",
        key = ":iu[nmap]",
        description = 'like ":unmap" but for Insert mode',
      },
      {
        tag = ":iunabbrev",
        key = ":iuna[bbrev]",
        description = 'like ":unabbrev" but for Insert mode',
      },
      {
        tag = ":iunmenu",
        key = ":iunme[nu]",
        description = "remove menu for Insert mode",
      },
      {
        tag = ":join",
        key = ":j[oin]",
        description = "join lines",
      },
      {
        tag = ":jumps",
        key = ":ju[mps]",
        description = "print the jump list",
      },
      {
        tag = ":k",
        key = ":k",
        description = "set a mark",
      },
      {
        tag = ":keepalt",
        key = ":keepa[lt]",
        description = "following command keeps the alternate file",
      },
      {
        tag = ":keepmarks",
        key = ":kee[pmarks]",
        description = "following command keeps marks where they are",
      },
      {
        tag = ":keepjumps",
        key = ":keepj[umps]",
        description = "following command keeps jumplist and marks",
      },
      {
        tag = ":keeppatterns",
        key = ":keepp[atterns]",
        description = "following command keeps search pattern history",
      },
      {
        tag = ":lNext",
        key = ":lN[ext]",
        description = "go to previous entry in location list",
      },
      {
        tag = ":lNfile",
        key = ":lNf[ile]",
        description = "go to last entry in previous file",
      },
      {
        tag = ":list",
        key = ":l[ist]",
        description = "print lines",
      },
      {
        tag = ":labove",
        key = ":lab[ove]",
        description = "go to location above current line",
      },
      {
        tag = ":laddexpr",
        key = ":lad[dexpr]",
        description = "add locations from expr",
      },
      {
        tag = ":laddbuffer",
        key = ":laddb[uffer]",
        description = "add locations from buffer",
      },
      {
        tag = ":laddfile",
        key = ":laddf[ile]",
        description = "add locations to current location list",
      },
      {
        tag = ":lafter",
        key = ":laf[ter]",
        description = "go to location after current cursor",
      },
      {
        tag = ":last",
        key = ":la[st]",
        description = "go to the last file in the argument list",
      },
      {
        tag = ":language",
        key = ":lan[guage]",
        description = "set the language (locale)",
      },
      {
        tag = ":later",
        key = ":lat[er]",
        description = "go to newer change, redo",
      },
      {
        tag = ":lbefore",
        key = ":lbe[fore]",
        description = "go to location before current cursor",
      },
      {
        tag = ":lbelow",
        key = ":lbel[ow]",
        description = "go to location below current line",
      },
      {
        tag = ":lbottom",
        key = ":lbo[ttom]",
        description = "scroll to the bottom of the location window",
      },
      {
        tag = ":lbuffer",
        key = ":lb[uffer]",
        description = "parse locations and jump to first location",
      },
      {
        tag = ":lcd",
        key = ":lc[d]",
        description = "change directory locally",
      },
      {
        tag = ":lchdir",
        key = ":lch[dir]",
        description = "change directory locally",
      },
      {
        tag = ":lclose",
        key = ":lcl[ose]",
        description = "close location window",
      },
      {
        tag = ":ldo",
        key = ":ld[o]",
        description = "execute command in valid location list entries",
      },
      {
        tag = ":lfdo",
        key = ":lfd[o]",
        description = "execute command in each file in location list",
      },
      {
        tag = ":left",
        key = ":le[ft]",
        description = "left align lines",
      },
      {
        tag = ":leftabove",
        key = ":lefta[bove]",
        description = "make split window appear left or above",
      },
      {
        tag = ":let",
        key = ":let",
        description = "assign a value to a variable or option",
      },
      {
        tag = ":lexpr",
        key = ":lex[pr]",
        description = "read locations from expr and jump to first",
      },
      {
        tag = ":lfile",
        key = ":lf[ile]",
        description = "read file with locations and jump to first",
      },
      {
        tag = ":lfirst",
        key = ":lfir[st]",
        description = "go to the specified location, default first one",
      },
      {
        tag = ":lgetbuffer",
        key = ":lgetb[uffer]",
        description = "get locations from buffer",
      },
      {
        tag = ":lgetexpr",
        key = ":lgete[xpr]",
        description = "get locations from expr",
      },
      {
        tag = ":lgetfile",
        key = ":lg[etfile]",
        description = "read file with locations",
      },
      {
        tag = ":lgrep",
        key = ":lgr[ep]",
        description = "run 'grepprg' and jump to first match",
      },
      {
        tag = ":lgrepadd",
        key = ":lgrepa[dd]",
        description = "like :grep, but append to current list",
      },
      {
        tag = ":lhelpgrep",
        key = ":lh[elpgrep]",
        description = 'like ":helpgrep" but uses location list',
      },
      {
        tag = ":lhistory",
        key = ":lhi[story]",
        description = "list the location lists",
      },
      {
        tag = ":ll",
        key = ":ll",
        description = "go to specific location",
      },
      {
        tag = ":llast",
        key = ":lla[st]",
        description = "go to the specified location, default last one",
      },
      {
        tag = ":llist",
        key = ":lli[st]",
        description = "list all locations",
      },
      {
        tag = ":lmake",
        key = ":lmak[e]",
        description = "execute external command 'makeprg' and parse error messages",
      },
      {
        tag = ":lmap",
        key = ":lm[ap]",
        description = 'like ":map!" but includes Lang-Arg mode',
      },
      {
        tag = ":lmapclear",
        key = ":lmapc[lear]",
        description = 'like ":mapclear!" but includes Lang-Arg mode',
      },
      {
        tag = ":lnext",
        key = ":lne[xt]",
        description = "go to next location",
      },
      {
        tag = ":lnewer",
        key = ":lnew[er]",
        description = "go to newer location list",
      },
      {
        tag = ":lnfile",
        key = ":lnf[ile]",
        description = "go to first location in next file",
      },
      {
        tag = ":lnoremap",
        key = ":ln[oremap]",
        description = 'like ":noremap!" but includes Lang-Arg mode',
      },
      {
        tag = ":loadkeymap",
        key = ":loadk[eymap]",
        description = "load the following keymaps until EOF",
      },
      {
        tag = ":loadview",
        key = ":lo[adview]",
        description = "load view for current window from a file",
      },
      {
        tag = ":lockmarks",
        key = ":loc[kmarks]",
        description = "following command keeps marks where they are",
      },
      {
        tag = ":lockvar",
        key = ":lockv[ar]",
        description = "lock variables",
      },
      {
        tag = ":lolder",
        key = ":lol[der]",
        description = "go to older location list",
      },
      {
        tag = ":lopen",
        key = ":lop[en]",
        description = "open location window",
      },
      {
        tag = ":lprevious",
        key = ":lp[revious]",
        description = "go to previous location",
      },
      {
        tag = ":lpfile",
        key = ":lpf[ile]",
        description = "go to last location in previous file",
      },
      {
        tag = ":lrewind",
        key = ":lr[ewind]",
        description = "go to the specified location, default first one",
      },
      {
        tag = ":ls",
        key = ":ls",
        description = "list all buffers",
      },
      {
        tag = ":ltag",
        key = ":lt[ag]",
        description = "jump to tag and add matching tags to the location list",
      },
      {
        tag = ":lunmap",
        key = ":lu[nmap]",
        description = 'like ":unmap!" but includes Lang-Arg mode',
      },
      {
        tag = ":lua",
        key = ":lua",
        description = "execute |Lua| command",
      },
      {
        tag = ":luado",
        key = ":luad[o]",
        description = "execute Lua command for each line",
      },
      {
        tag = ":luafile",
        key = ":luaf[ile]",
        description = "execute |Lua| script file",
      },
      {
        tag = ":lvimgrep",
        key = ":lv[imgrep]",
        description = "search for pattern in files",
      },
      {
        tag = ":lvimgrepadd",
        key = ":lvimgrepa[dd]",
        description = "like :vimgrep, but append to current list",
      },
      {
        tag = ":lwindow",
        key = ":lw[indow]",
        description = "open or close location window",
      },
      {
        tag = ":move",
        key = ":m[ove]",
        description = "move lines",
      },
      {
        tag = ":mark",
        key = ":ma[rk]",
        description = "set a mark",
      },
      {
        tag = ":make",
        key = ":mak[e]",
        description = "execute external command 'makeprg' and parse error messages",
      },
      {
        tag = ":map",
        key = ":map",
        description = "show or enter a mapping",
      },
      {
        tag = ":mapclear",
        key = ":mapc[lear]",
        description = "clear all mappings for Normal and Visual mode",
      },
      {
        tag = ":marks",
        key = ":marks",
        description = "list all marks",
      },
      {
        tag = ":match",
        key = ":mat[ch]",
        description = "define a match to highlight",
      },
      {
        tag = ":menu",
        key = ":me[nu]",
        description = "enter a new menu item",
      },
      {
        tag = ":menutranslate",
        key = ":menut[ranslate] add a menu translation item",
        description = "",
      },
      {
        tag = ":messages",
        key = ":mes[sages]",
        description = "view previously displayed messages",
      },
      {
        tag = ":mkexrc",
        key = ":mk[exrc]",
        description = "write current mappings and settings to a file",
      },
      {
        tag = ":mksession",
        key = ":mks[ession]",
        description = "write session info to a file",
      },
      {
        tag = ":mkspell",
        key = ":mksp[ell]",
        description = "produce .spl spell file",
      },
      {
        tag = ":mkvimrc",
        key = ":mkv[imrc]",
        description = "write current mappings and settings to a file",
      },
      {
        tag = ":mkview",
        key = ":mkvie[w]",
        description = "write view of current window to a file",
      },
      {
        tag = ":mode",
        key = ":mod[e]",
        description = "show or change the screen mode",
      },
      {
        tag = ":next",
        key = ":n[ext]",
        description = "go to next file in the argument list",
      },
      {
        tag = ":new",
        key = ":new",
        description = "create a new empty window",
      },
      {
        tag = ":nmap",
        key = ":nm[ap]",
        description = 'like ":map" but for Normal mode',
      },
      {
        tag = ":nmapclear",
        key = ":nmapc[lear]",
        description = "clear all mappings for Normal mode",
      },
      {
        tag = ":nmenu",
        key = ":nme[nu]",
        description = "add menu for Normal mode",
      },
      {
        tag = ":nnoremap",
        key = ":nn[oremap]",
        description = 'like ":noremap" but for Normal mode',
      },
      {
        tag = ":nnoremenu",
        key = ":nnoreme[nu]",
        description = 'like ":noremenu" but for Normal mode',
      },
      {
        tag = ":noautocmd",
        key = ":noa[utocmd]",
        description = "following commands don't trigger autocommands",
      },
      {
        tag = ":noremap",
        key = ":no[remap]",
        description = "enter a mapping that will not be remapped",
      },
      {
        tag = ":nohlsearch",
        key = ":noh[lsearch]",
        description = "suspend 'hlsearch' highlighting",
      },
      {
        tag = ":noreabbrev",
        key = ":norea[bbrev]",
        description = "enter an abbreviation that will not be remapped",
      },
      {
        tag = ":noremenu",
        key = ":noreme[nu]",
        description = "enter a menu that will not be remapped",
      },
      {
        tag = ":normal",
        key = ":norm[al]",
        description = "execute Normal mode commands",
      },
      {
        tag = ":noswapfile",
        key = ":nos[wapfile]",
        description = "following commands don't create a swap file",
      },
      {
        tag = ":number",
        key = ":nu[mber]",
        description = "print lines with line number",
      },
      {
        tag = ":nunmap",
        key = ":nun[map]",
        description = 'like ":unmap" but for Normal mode',
      },
      {
        tag = ":nunmenu",
        key = ":nunme[nu]",
        description = "remove menu for Normal mode",
      },
      {
        tag = ":oldfiles",
        key = ":ol[dfiles]",
        description = "list files that have marks in the |shada| file",
      },
      {
        tag = ":omap",
        key = ":om[ap]",
        description = 'like ":map" but for Operator-pending mode',
      },
      {
        tag = ":omapclear",
        key = ":omapc[lear]",
        description = "remove all mappings for Operator-pending mode",
      },
      {
        tag = ":omenu",
        key = ":ome[nu]",
        description = "add menu for Operator-pending mode",
      },
      {
        tag = ":only",
        key = ":on[ly]",
        description = "close all windows except the current one",
      },
      {
        tag = ":onoremap",
        key = ":ono[remap]",
        description = 'like ":noremap" but for Operator-pending mode',
      },
      {
        tag = ":onoremenu",
        key = ":onoreme[nu]",
        description = 'like ":noremenu" but for Operator-pending mode',
      },
      {
        tag = ":options",
        key = ":opt[ions]",
        description = "open the options-window",
      },
      {
        tag = ":ounmap",
        key = ":ou[nmap]",
        description = 'like ":unmap" but for Operator-pending mode',
      },
      {
        tag = ":ounmenu",
        key = ":ounme[nu]",
        description = "remove menu for Operator-pending mode",
      },
      {
        tag = ":packadd",
        key = ":pa[ckadd]",
        description = "add a plugin from 'packpath'",
      },
      {
        tag = ":packloadall",
        key = ":packl[oadall]",
        description = "load all packages under 'packpath'",
      },
      {
        tag = ":pbuffer",
        key = ":pb[uffer]",
        description = "edit buffer in the preview window",
      },
      {
        tag = ":pclose",
        key = ":pc[lose]",
        description = "close preview window",
      },
      {
        tag = ":pedit",
        key = ":ped[it]",
        description = "edit file in the preview window",
      },
      {
        tag = ":perl",
        key = ":pe[rl]",
        description = "execute perl command",
      },
      {
        tag = ":perldo",
        key = ":perld[o]",
        description = "execute perl command for each line",
      },
      {
        tag = ":perlfile",
        key = ":perlf[ile]",
        description = "execute perl script file",
      },
      {
        tag = ":print",
        key = ":p[rint]",
        description = "print lines",
      },
      {
        tag = ":profdel",
        key = ":profd[el]",
        description = "stop profiling a function or script",
      },
      {
        tag = ":profile",
        key = ":prof[ile]",
        description = "profiling functions and scripts",
      },
      {
        tag = ":pop",
        key = ":po[p]",
        description = "jump to older entry in tag stack",
      },
      {
        tag = ":popup",
        key = ":popu[p]",
        description = "popup a menu by name",
      },
      {
        tag = ":ppop",
        key = ":pp[op]",
        description = '":pop" in preview window',
      },
      {
        tag = ":preserve",
        key = ":pre[serve]",
        description = "write all text to swap file",
      },
      {
        tag = ":previous",
        key = ":prev[ious]",
        description = "go to previous file in argument list",
      },
      {
        tag = ":psearch",
        key = ":ps[earch]",
        description = 'like ":ijump" but shows match in preview window',
      },
      {
        tag = ":ptag",
        key = ":pt[ag]",
        description = "show tag in preview window",
      },
      {
        tag = ":ptNext",
        key = ":ptN[ext]",
        description = "|:tNext| in preview window",
      },
      {
        tag = ":ptfirst",
        key = ":ptf[irst]",
        description = "|:trewind| in preview window",
      },
      {
        tag = ":ptjump",
        key = ":ptj[ump]",
        description = "|:tjump| and show tag in preview window",
      },
      {
        tag = ":ptlast",
        key = ":ptl[ast]",
        description = "|:tlast| in preview window",
      },
      {
        tag = ":ptnext",
        key = ":ptn[ext]",
        description = "|:tnext| in preview window",
      },
      {
        tag = ":ptprevious",
        key = ":ptp[revious]",
        description = "|:tprevious| in preview window",
      },
      {
        tag = ":ptrewind",
        key = ":ptr[ewind]",
        description = "|:trewind| in preview window",
      },
      {
        tag = ":ptselect",
        key = ":pts[elect]",
        description = "|:tselect| and show tag in preview window",
      },
      {
        tag = ":put",
        key = ":pu[t]",
        description = "insert contents of register in the text",
      },
      {
        tag = ":pwd",
        key = ":pw[d]",
        description = "print current directory",
      },
      {
        tag = ":py3",
        key = ":py3",
        description = "execute Python 3 command",
      },
      {
        tag = ":python3",
        key = ":python3",
        description = "same as :py3",
      },
      {
        tag = ":py3do",
        key = ":py3d[o]",
        description = "execute Python 3 command for each line",
      },
      {
        tag = ":py3file",
        key = ":py3f[ile]",
        description = "execute Python 3 script file",
      },
      {
        tag = ":python",
        key = ":py[thon]",
        description = "execute Python command",
      },
      {
        tag = ":pydo",
        key = ":pyd[o]",
        description = "execute Python command for each line",
      },
      {
        tag = ":pyfile",
        key = ":pyf[ile]",
        description = "execute Python script file",
      },
      {
        tag = ":pyx",
        key = ":pyx",
        description = "execute |python_x| command",
      },
      {
        tag = ":pythonx",
        key = ":pythonx",
        description = "same as :pyx",
      },
      {
        tag = ":pyxdo",
        key = ":pyxd[o]",
        description = "execute |python_x| command for each line",
      },
      {
        tag = ":pyxfile",
        key = ":pyxf[ile]",
        description = "execute |python_x| script file",
      },
      {
        tag = ":quit",
        key = ":q[uit]",
        description = "quit current window (when one window quit Vim)",
      },
      {
        tag = ":quitall",
        key = ":quita[ll]",
        description = "quit Vim",
      },
      {
        tag = ":qall",
        key = ":qa[ll]",
        description = "quit Vim",
      },
      {
        tag = ":read",
        key = ":r[ead]",
        description = "read file into the text",
      },
      {
        tag = ":recover",
        key = ":rec[over]",
        description = "recover a file from a swap file",
      },
      {
        tag = ":redo",
        key = ":red[o]",
        description = "redo one undone change",
      },
      {
        tag = ":redir",
        key = ":redi[r]",
        description = "redirect messages to a file or register",
      },
      {
        tag = ":redraw",
        key = ":redr[aw]",
        description = "force a redraw of the display",
      },
      {
        tag = ":redrawstatus",
        key = ":redraws[tatus]",
        description = "force a redraw of the status line(s) and window bar(s)",
      },
      {
        tag = ":redrawtabline",
        key = ":redrawt[abline]  force a redraw of the tabline",
        description = "",
      },
      {
        tag = ":registers",
        key = ":reg[isters]",
        description = "display the contents of registers",
      },
      {
        tag = ":resize",
        key = ":res[ize]",
        description = "change current window height",
      },
      {
        tag = ":restart",
        key = ":restart",
        description = "restart the Nvim server",
      },
      {
        tag = ":retab",
        key = ":ret[ab]",
        description = "change tab size",
      },
      {
        tag = ":return",
        key = ":retu[rn]",
        description = "return from a user function",
      },
      {
        tag = ":rewind",
        key = ":rew[ind]",
        description = "go to the first file in the argument list",
      },
      {
        tag = ":right",
        key = ":ri[ght]",
        description = "right align text",
      },
      {
        tag = ":rightbelow",
        key = ":rightb[elow]",
        description = "make split window appear right or below",
      },
      {
        tag = ":rshada",
        key = ":rsh[ada]",
        description = "read from |shada| file",
      },
      {
        tag = ":ruby",
        key = ":rub[y]",
        description = "execute Ruby command",
      },
      {
        tag = ":rubydo",
        key = ":rubyd[o]",
        description = "execute Ruby command for each line",
      },
      {
        tag = ":rubyfile",
        key = ":rubyf[ile]",
        description = "execute Ruby script file",
      },
      {
        tag = ":rundo",
        key = ":rund[o]",
        description = "read undo information from a file",
      },
      {
        tag = ":runtime",
        key = ":ru[ntime]",
        description = "source vim scripts in 'runtimepath'",
      },
      {
        tag = ":substitute",
        key = ":s[ubstitute]",
        description = "find and replace text",
      },
      {
        tag = ":sNext",
        key = ":sN[ext]",
        description = "split window and go to previous file in argument list",
      },
      {
        tag = ":sandbox",
        key = ":san[dbox]",
        description = "execute a command in the sandbox",
      },
      {
        tag = ":sargument",
        key = ":sa[rgument]",
        description = "split window and go to specific file in argument list",
      },
      {
        tag = ":sall",
        key = ":sal[l]",
        description = "open a window for each file in argument list",
      },
      {
        tag = ":saveas",
        key = ":sav[eas]",
        description = "save file under another name.",
      },
      {
        tag = ":sbuffer",
        key = ":sb[uffer]",
        description = "split window and go to specific file in the buffer list",
      },
      {
        tag = ":sbNext",
        key = ":sbN[ext]",
        description = "split window and go to previous file in the buffer list",
      },
      {
        tag = ":sball",
        key = ":sba[ll]",
        description = "open a window for each file in the buffer list",
      },
      {
        tag = ":sbfirst",
        key = ":sbf[irst]",
        description = "split window and go to first file in the buffer list",
      },
      {
        tag = ":sblast",
        key = ":sbl[ast]",
        description = "split window and go to last file in buffer list",
      },
      {
        tag = ":sbmodified",
        key = ":sbm[odified]",
        description = "split window and go to modified file in the buffer list",
      },
      {
        tag = ":sbnext",
        key = ":sbn[ext]",
        description = "split window and go to next file in the buffer list",
      },
      {
        tag = ":sbprevious",
        key = ":sbp[revious]",
        description = "split window and go to previous file in the buffer list",
      },
      {
        tag = ":sbrewind",
        key = ":sbr[ewind]",
        description = "split window and go to first file in the buffer list",
      },
      {
        tag = ":scriptnames",
        key = ":scr[iptnames]",
        description = "list names of all sourced Vim scripts",
      },
      {
        tag = ":scriptencoding",
        key = ":scripte[ncoding]  encoding used in sourced Vim script",
        description = "",
      },
      {
        tag = ":set",
        key = ":se[t]",
        description = "show or set options",
      },
      {
        tag = ":setfiletype",
        key = ":setf[iletype]",
        description = "set 'filetype', unless it was set already",
      },
      {
        tag = ":setglobal",
        key = ":setg[lobal]",
        description = "show global values of options",
      },
      {
        tag = ":setlocal",
        key = ":setl[ocal]",
        description = "show or set options locally",
      },
      {
        tag = ":sfind",
        key = ":sf[ind]",
        description = "split current window and edit file in 'path'",
      },
      {
        tag = ":sfirst",
        key = ":sfir[st]",
        description = "split window and go to first file in the argument list",
      },
      {
        tag = ":sign",
        key = ":sig[n]",
        description = "manipulate signs",
      },
      {
        tag = ":silent",
        key = ":sil[ent]",
        description = "run a command silently",
      },
      {
        tag = ":sleep",
        key = ":sl[eep]",
        description = "do nothing for a few seconds",
      },
      {
        tag = ":sleep!",
        key = ":sl[eep]!",
        description = "do nothing for a few seconds, without the cursor visible",
      },
      {
        tag = ":slast",
        key = ":sla[st]",
        description = "split window and go to last file in the argument list",
      },
      {
        tag = ":smagic",
        key = ":sm[agic]",
        description = ":substitute with 'magic'",
      },
      {
        tag = ":smap",
        key = ":smap",
        description = 'like ":map" but for Select mode',
      },
      {
        tag = ":smapclear",
        key = ":smapc[lear]",
        description = "remove all mappings for Select mode",
      },
      {
        tag = ":smenu",
        key = ":sme[nu]",
        description = "add menu for Select mode",
      },
      {
        tag = ":snext",
        key = ":sn[ext]",
        description = "split window and go to next file in the argument list",
      },
      {
        tag = ":snomagic",
        key = ":sno[magic]",
        description = ":substitute with 'nomagic'",
      },
      {
        tag = ":snoremap",
        key = ":snor[emap]",
        description = 'like ":noremap" but for Select mode',
      },
      {
        tag = ":snoremenu",
        key = ":snoreme[nu]",
        description = 'like ":noremenu" but for Select mode',
      },
      {
        tag = ":sort",
        key = ":sor[t]",
        description = "sort lines",
      },
      {
        tag = ":source",
        key = ":so[urce]",
        description = "read Vim or Ex commands from a file",
      },
      {
        tag = ":spelldump",
        key = ":spelld[ump]",
        description = "split window and fill with all correct words",
      },
      {
        tag = ":spellgood",
        key = ":spe[llgood]",
        description = "add good word for spelling",
      },
      {
        tag = ":spellinfo",
        key = ":spelli[nfo]",
        description = "show info about loaded spell files",
      },
      {
        tag = ":spellrare",
        key = ":spellra[re]",
        description = "add rare word for spelling",
      },
      {
        tag = ":spellrepall",
        key = ":spellr[epall]",
        description = "replace all bad words like last |z=|",
      },
      {
        tag = ":spellundo",
        key = ":spellu[ndo]",
        description = "remove good or bad word",
      },
      {
        tag = ":spellwrong",
        key = ":spellw[rong]",
        description = "add spelling mistake",
      },
      {
        tag = ":split",
        key = ":sp[lit]",
        description = "split current window",
      },
      {
        tag = ":sprevious",
        key = ":spr[evious]",
        description = "split window and go to previous file in the argument list",
      },
      {
        tag = ":srewind",
        key = ":sre[wind]",
        description = "split window and go to first file in the argument list",
      },
      {
        tag = ":stop",
        key = ":st[op]",
        description = "suspend the editor or escape to a shell",
      },
      {
        tag = ":stag",
        key = ":sta[g]",
        description = "split window and jump to a tag",
      },
      {
        tag = ":startinsert",
        key = ":star[tinsert]",
        description = "start Insert mode",
      },
      {
        tag = ":startgreplace",
        key = ":startg[replace] start Virtual Replace mode",
        description = "",
      },
      {
        tag = ":startreplace",
        key = ":startr[eplace]",
        description = "start Replace mode",
      },
      {
        tag = ":stopinsert",
        key = ":stopi[nsert]",
        description = "stop Insert mode",
      },
      {
        tag = ":stjump",
        key = ":stj[ump]",
        description = 'do ":tjump" and split window',
      },
      {
        tag = ":stselect",
        key = ":sts[elect]",
        description = 'do ":tselect" and split window',
      },
      {
        tag = ":sunhide",
        key = ":sun[hide]",
        description = 'same as ":unhide"',
      },
      {
        tag = ":sunmap",
        key = ":sunm[ap]",
        description = 'like ":unmap" but for Select mode',
      },
      {
        tag = ":sunmenu",
        key = ":sunme[nu]",
        description = "remove menu for Select mode",
      },
      {
        tag = ":suspend",
        key = ":sus[pend]",
        description = 'same as ":stop"',
      },
      {
        tag = ":sview",
        key = ":sv[iew]",
        description = "split window and edit file read-only",
      },
      {
        tag = ":swapname",
        key = ":sw[apname]",
        description = "show the name of the current swap file",
      },
      {
        tag = ":syntax",
        key = ":sy[ntax]",
        description = "syntax highlighting",
      },
      {
        tag = ":syntime",
        key = ":synti[me]",
        description = "measure syntax highlighting speed",
      },
      {
        tag = ":syncbind",
        key = ":sync[bind]",
        description = "sync scroll binding",
      },
      {
        tag = ":t",
        key = ":t",
        description = 'same as ":copy"',
      },
      {
        tag = ":tNext",
        key = ":tN[ext]",
        description = "jump to previous matching tag",
      },
      {
        tag = ":tabNext",
        key = ":tabN[ext]",
        description = "go to previous tab page",
      },
      {
        tag = ":tabclose",
        key = ":tabc[lose]",
        description = "close current tab page",
      },
      {
        tag = ":tabdo",
        key = ":tabd[o]",
        description = "execute command in each tab page",
      },
      {
        tag = ":tabedit",
        key = ":tabe[dit]",
        description = "edit a file in a new tab page",
      },
      {
        tag = ":tabfind",
        key = ":tabf[ind]",
        description = "find file in 'path', edit it in a new tab page",
      },
      {
        tag = ":tabfirst",
        key = ":tabfir[st]",
        description = "go to first tab page",
      },
      {
        tag = ":tablast",
        key = ":tabl[ast]",
        description = "go to last tab page",
      },
      {
        tag = ":tabmove",
        key = ":tabm[ove]",
        description = "move tab page to other position",
      },
      {
        tag = ":tabnew",
        key = ":tabnew",
        description = "edit a file in a new tab page",
      },
      {
        tag = ":tabnext",
        key = ":tabn[ext]",
        description = "go to next tab page",
      },
      {
        tag = ":tabonly",
        key = ":tabo[nly]",
        description = "close all tab pages except the current one",
      },
      {
        tag = ":tabprevious",
        key = ":tabp[revious]",
        description = "go to previous tab page",
      },
      {
        tag = ":tabrewind",
        key = ":tabr[ewind]",
        description = "go to first tab page",
      },
      {
        tag = ":tabs",
        key = ":tabs",
        description = "list the tab pages and what they contain",
      },
      {
        tag = ":tab",
        key = ":tab",
        description = "create new tab when opening new window",
      },
      {
        tag = ":tag",
        key = ":ta[g]",
        description = "jump to tag",
      },
      {
        tag = ":tags",
        key = ":tags",
        description = "show the contents of the tag stack",
      },
      {
        tag = ":tcd",
        key = ":tc[d]",
        description = "change directory for tab page",
      },
      {
        tag = ":tchdir",
        key = ":tch[dir]",
        description = "change directory for tab page",
      },
      {
        tag = ":terminal",
        key = ":te[rminal]",
        description = "open a terminal buffer",
      },
      {
        tag = ":tfirst",
        key = ":tf[irst]",
        description = "jump to first matching tag",
      },
      {
        tag = ":throw",
        key = ":th[row]",
        description = "throw an exception",
      },
      {
        tag = ":tjump",
        key = ":tj[ump]",
        description = 'like ":tselect", but jump directly when there is only one match',
      },
      {
        tag = ":tlast",
        key = ":tl[ast]",
        description = "jump to last matching tag",
      },
      {
        tag = ":tlmenu",
        key = ":tlm[enu]",
        description = "add menu for |Terminal-mode|",
      },
      {
        tag = ":tlnoremenu",
        key = ":tln[oremenu]",
        description = 'like ":noremenu" but for |Terminal-mode|',
      },
      {
        tag = ":tlunmenu",
        key = ":tlu[nmenu]",
        description = "remove menu for |Terminal-mode|",
      },
      {
        tag = ":tmapclear",
        key = ":tmapc[lear]",
        description = "remove all mappings for |Terminal-mode|",
      },
      {
        tag = ":tmap",
        key = ":tma[p]",
        description = 'like ":map" but for |Terminal-mode|',
      },
      {
        tag = ":tmenu",
        key = ":tm[enu]",
        description = "define menu tooltip",
      },
      {
        tag = ":tnext",
        key = ":tn[ext]",
        description = "jump to next matching tag",
      },
      {
        tag = ":tnoremap",
        key = ":tno[remap]",
        description = 'like ":noremap" but for |Terminal-mode|',
      },
      {
        tag = ":topleft",
        key = ":to[pleft]",
        description = "make split window appear at top or far left",
      },
      {
        tag = ":tprevious",
        key = ":tp[revious]",
        description = "jump to previous matching tag",
      },
      {
        tag = ":trewind",
        key = ":tr[ewind]",
        description = "jump to first matching tag",
      },
      {
        tag = ":trust",
        key = ":trust",
        description = "add or remove file from trust database",
      },
      {
        tag = ":try",
        key = ":try",
        description = "execute commands, abort on error or exception",
      },
      {
        tag = ":tselect",
        key = ":ts[elect]",
        description = "list matching tags and select one",
      },
      {
        tag = ":tunmap",
        key = ":tunma[p]",
        description = 'like ":unmap" but for |Terminal-mode|',
      },
      {
        tag = ":tunmenu",
        key = ":tu[nmenu]",
        description = "remove menu tooltip",
      },
      {
        tag = ":undo",
        key = ":u[ndo]",
        description = "undo last change(s)",
      },
      {
        tag = ":undojoin",
        key = ":undoj[oin]",
        description = "join next change with previous undo block",
      },
      {
        tag = ":undolist",
        key = ":undol[ist]",
        description = "list leafs of the undo tree",
      },
      {
        tag = ":unabbreviate",
        key = ":una[bbreviate]",
        description = "remove abbreviation",
      },
      {
        tag = ":unhide",
        key = ":unh[ide]",
        description = "open a window for each loaded file in the buffer list",
      },
      {
        tag = ":uniq",
        key = ":uni[q]",
        description = "uniq lines",
      },
      {
        tag = ":unlet",
        key = ":unl[et]",
        description = "delete variable",
      },
      {
        tag = ":unlockvar",
        key = ":unlo[ckvar]",
        description = "unlock variables",
      },
      {
        tag = ":unmap",
        key = ":unm[ap]",
        description = "remove mapping",
      },
      {
        tag = ":unmenu",
        key = ":unme[nu]",
        description = "remove menu",
      },
      {
        tag = ":unsilent",
        key = ":uns[ilent]",
        description = "run a command not silently",
      },
      {
        tag = ":update",
        key = ":up[date]",
        description = "write buffer if modified",
      },
      {
        tag = ":vglobal",
        key = ":v[global]",
        description = "execute commands for not matching lines",
      },
      {
        tag = ":version",
        key = ":ve[rsion]",
        description = "print version number and other info",
      },
      {
        tag = ":verbose",
        key = ":verb[ose]",
        description = "execute command with 'verbose' set",
      },
      {
        tag = ":vertical",
        key = ":vert[ical]",
        description = "make following command split vertically",
      },
      {
        tag = ":vimgrep",
        key = ":vim[grep]",
        description = "search for pattern in files",
      },
      {
        tag = ":vimgrepadd",
        key = ":vimgrepa[dd]",
        description = "like :vimgrep, but append to current list",
      },
      {
        tag = ":visual",
        key = ":vi[sual]",
        description = 'same as ":edit", but turns off "Ex" mode',
      },
      {
        tag = ":viusage",
        key = ":viu[sage]",
        description = "overview of Normal mode commands",
      },
      {
        tag = ":view",
        key = ":vie[w]",
        description = "edit a file read-only",
      },
      {
        tag = ":vmap",
        key = ":vm[ap]",
        description = 'like ":map" but for Visual+Select mode',
      },
      {
        tag = ":vmapclear",
        key = ":vmapc[lear]",
        description = "remove all mappings for Visual+Select mode",
      },
      {
        tag = ":vmenu",
        key = ":vme[nu]",
        description = "add menu for Visual+Select mode",
      },
      {
        tag = ":vnew",
        key = ":vne[w]",
        description = "create a new empty window, vertically split",
      },
      {
        tag = ":vnoremap",
        key = ":vn[oremap]",
        description = 'like ":noremap" but for Visual+Select mode',
      },
      {
        tag = ":vnoremenu",
        key = ":vnoreme[nu]",
        description = 'like ":noremenu" but for Visual+Select mode',
      },
      {
        tag = ":vsplit",
        key = ":vs[plit]",
        description = "split current window vertically",
      },
      {
        tag = ":vunmap",
        key = ":vu[nmap]",
        description = 'like ":unmap" but for Visual+Select mode',
      },
      {
        tag = ":vunmenu",
        key = ":vunme[nu]",
        description = "remove menu for Visual+Select mode",
      },
      {
        tag = ":windo",
        key = ":wind[o]",
        description = "execute command in each window",
      },
      {
        tag = ":write",
        key = ":w[rite]",
        description = "write to a file",
      },
      {
        tag = ":wNext",
        key = ":wN[ext]",
        description = "write to a file and go to previous file in argument list",
      },
      {
        tag = ":wall",
        key = ":wa[ll]",
        description = "write all (changed) buffers",
      },
      {
        tag = ":while",
        key = ":wh[ile]",
        description = "execute loop for as long as condition met",
      },
      {
        tag = ":winsize",
        key = ":wi[nsize]",
        description = "get or set window size (obsolete)",
      },
      {
        tag = ":wincmd",
        key = ":winc[md]",
        description = "execute a Window (CTRL-W) command",
      },
      {
        tag = ":winpos",
        key = ":winp[os]",
        description = "get or set window position",
      },
      {
        tag = ":wnext",
        key = ":wn[ext]",
        description = "write to a file and go to next file in argument list",
      },
      {
        tag = ":wprevious",
        key = ":wp[revious]",
        description = "write to a file and go to previous file in argument list",
      },
      {
        tag = ":wq",
        key = ":wq",
        description = "write to a file and quit window or Vim",
      },
      {
        tag = ":wqall",
        key = ":wqa[ll]",
        description = "write all changed buffers and quit Vim",
      },
      {
        tag = ":wshada",
        key = ":wsh[ada]",
        description = "write to ShaDa file",
      },
      {
        tag = ":wundo",
        key = ":wu[ndo]",
        description = "write undo information to a file",
      },
      {
        tag = ":xit",
        key = ":x[it]",
        description = "write if buffer changed and close window",
      },
      {
        tag = ":xall",
        key = ":xa[ll]",
        description = 'same as ":wqall"',
      },
      {
        tag = ":xmapclear",
        key = ":xmapc[lear]",
        description = "remove all mappings for Visual mode",
      },
      {
        tag = ":xmap",
        key = ":xm[ap]",
        description = 'like ":map" but for Visual mode',
      },
      {
        tag = ":xmenu",
        key = ":xme[nu]",
        description = "add menu for Visual mode",
      },
      {
        tag = ":xnoremap",
        key = ":xn[oremap]",
        description = 'like ":noremap" but for Visual mode',
      },
      {
        tag = ":xnoremenu",
        key = ":xnoreme[nu]",
        description = 'like ":noremenu" but for Visual mode',
      },
      {
        tag = ":xunmap",
        key = ":xu[nmap]",
        description = 'like ":unmap" but for Visual mode',
      },
      {
        tag = ":xunmenu",
        key = ":xunme[nu]",
        description = "remove menu for Visual mode",
      },
      {
        tag = ":yank",
        key = ":y[ank]",
        description = "yank lines into a register",
      },
      {
        tag = ":z",
        key = ":z",
        description = "print some lines",
      },
      {
        tag = ":~",
        key = ":~",
        description = 'repeat last ":substitute"',
      },
    },
  },
}
