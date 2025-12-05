return {
  tag = "presets-ex",
  mappings = {
    ["c"] = {
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
}
