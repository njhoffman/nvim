return {
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
}
