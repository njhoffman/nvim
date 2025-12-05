return {
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
}
