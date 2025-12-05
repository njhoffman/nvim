return {
  tag = "presets-visual",
  mappings = {
    ["v"] = {
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
}
