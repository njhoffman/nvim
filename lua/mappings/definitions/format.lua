local M = {
  dial_increment1 = { cmd = "<Plug>(dial-increment)", short = "dial increment", long = "increment item(s)" },
  dial_decrement1 = { cmd = "<Plug>(dial-decrement)", short = "dial decrement", long = "decrement item(s)" },
  dial_increment2 = { cmd = "<Plug>(dial-increment)", short = "dial increment", long = "increment item(s)" },
  dial_decrement2 = { cmd = "<Plug>(dial-decrement)", short = "dial decrement", long = "decrement item(s)" },
  v_dial_increment1 = {
    cmd = "<Plug>(dial-increment)",
    short = "dial increment",
    long = "increment item(s) selected in visual mode"
  },
  v_dial_decrement1 = {
    cmd = "<Plug>(dial-decrement)",
    short = "dial decrement",
    long = "decrement item(s) selected in visual mode"
  },
  v_dial_increment2 = {
    cmd = "<Plug>(dial-increment)",
    short = "dial increment",
    long = "increment item(s) selected in visual mode"
  },
  v_dial_decrement2 = {
    cmd = "<Plug>(dial-decrement)",
    short = "dial decrement",
    long = "decrement item(s) selected in visual mode"
  },
  v_dial_increment_additional = {
    -- cmd = "g<C-a>"
    -- cmd = "<Plug>(dial-increment-additional)",
    short = "dial increment additional",
    long = "increment item(s) selected in visual mode"
  },
  v_dial_decrement_additional = {
    -- cmd = "g<C-x>"
    -- cmd = "<Plug>(dial-decrement-additional)",
    short = "dial decrement additional",
    long = "decrement item(s) selected in visual mode"
  },
  swap = {
    cmd   = "<cmd>ISwap<cr>",
    short = "swap",
    long  = "swap/exchange text objects with text hints",
  },
  indent_all = {
    cmd   = "`[V`]<",
    short = "indent all lines",
    long  = "indent all lines",
  },
  unindent_all = { cmd = "`[V`]>", short = "unindent all lines", long = "unindent all lines" },
  uppercase2 = { cmd = "gUw", short = "uppercase", long = "format uppercase" },
  lowercase2 = { cmd = "guw", short = "lowercase", long = "format lowercase" },
  snakecase = { cmd = "<cmd>Snek<cr>", short = "snake case", long = "format snake case" },
  kebabcase = { cmd = "<cmd>Kebab<cr>", short = "kebab case", long = "format kebab case" },
  camelcase = { cmd = "<cmd>Camel<cr>", short = "camel case", long = "format camel case" },
  camelbcase = { cmd = "<cmd>CamelB<cr>", short = "camelB case", long = "format camelB case" },
  v_snakecase = { cmd = "<cmd>Snek<cr>", short = "snake case", long = "format visual snake case" },
  v_kebabcase = { cmd = "<cmd>Kebab<cr>", short = "kebab case", long = "format visual kebab case" },
  v_camelcase = { cmd = "<cmd>Camel<cr>", short = "camel case", long = "format visual camel case" },
  v_camelbcase = { cmd = "<cmd>CamelB<cr>", short = "camelB case", long = "format visual camelB case" },
  lowercase1 = { short = "lowercase", long = "lowercase" }, -- virtual
  uppercase1 = { short = "uppercase", long = "uppercase" }, -- virtual
  rename = { short = "ts rename under cursor", long = "ts rename under cursor" }, -- virtual
  v_unindent = { cmd = "<gv", short = "unindent repeatedly", long = "unindent repeatedly visual mode" },
  v_indent = { cmd = ">gv", short = "indent repeatedly", long = "indent repeatedly visual mode" }
}
return M
