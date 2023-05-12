-- stylua: ignore
local SYMBOL_MAP = {
  Text           = "󰉿 ",
  Method         = "󰆧 ",
  Function       = "󰊕",
  Constructor    = " ",
  Field          = "󰆧 ",
  Variable       = "󰆧 ",
  Class          = "󰅩 ",
  Interface      = " ",
  Module         = " ",
  Property       = "󰆧 ",
  Unit           = "󰑭",
  Value          = "󰎠 ",
  Enum           = " ",
  Keyword        = "󰌋 ",
  Snippet        = " ",
  Color          = "󰏘 ",
  File           = "󰈙 ",
  Reference      = "󰈇 ",
  Folder         = "󰉋 ",
  EnumMember     = " ",
  Constant       = "󰏿 ",
  Struct         = " ",
  Event          = "",
  Operator       = "󰆕 ",
  TypeParameter  = "󰆧 ",
}

-- stylua: ignore
local lsp_symbols = {
  Text            = "", --   Text = " ",
  Method          = "󰆧",
  Function        = "󰊕",
  Constructor     = "", --   Constructor = "⌘ ",
  Field           = "󰜢", --   Field = "󰜢 ",
  Variable        = "", --   Variable = "󰈜 ",
  Class           = "󰌗", --   Class = "󰠱 ",
  Interface       = "󰜰", --   Interface = " ",
  Module          = "󰅩", --   Module = "󰏓 ",
  Property        = "󰖷", --   Property = "󰜢",
  Unit            = "", --   Unit = "󰑭 ",
  Value           = "󰎠",
  Enum            = "󰕘", --   Enum = " ",
  Keyword         = "󰌋", --   Keyword = "󰔌 ",
  Snippet         = "", --   Snippet = "󰅱 ",
  Color           = "󰏘",
  File            = "󰈔", --   File = "󰈙 ",
  Reference       = "󰈝", --   Reference = "󰈇 ",
  Folder          = "󰉋",
  EnumMember      = "",
  Constant        = "󰞂", --   Constant = "󰐀 ",
  Struct          = "󰟦", --   Struct = "󰙅 ",
  Event           = "",
  Operator        = "󰃬", --   Operator = "󰆕 ",
  TypeParameter   = "󰊄",
}

-- stylua: ignore
local icons2    = {
  Array         = " ", --
  Boolean       = " ", --
  Class         = " 󰌗", --   Class = " 󰠱","  "
  Color         = " 󰏘",
  Constant      = " 󰞂", --   Constant = " 󰐀",
  Constructor   = " ⌘", --   Constructor = "⌘ ","" ' ', " ",
  Enum          = " 󰕘", --   Enum = " " " " ,
  EnumMember    = " ", -- ' '
  Event         = " ", -- " "
  Field         = " ", --   Field = "󰜢 ", " ", " 󰜢",
  File          = " ", --   File = "󰈙 ", " ", " 󰈔" ,
  Folder        = " 󰉋",
  Function      = " 󰊕",
  Interface     = " ", --   Interface = " ", ' ', " 󰜰",
  Keyword       = " 󰌋", --   Keyword = "󰔌 ",
  Key           = " ",
  Method        = " 󰆧",
  Number        = " ",
  Null          = " ", -- "", " "
  Module        = " 󰅩", --   Module = "󰏓 ",
  Object        = " ", --
  Operator      = " ", --   Operator = "󰆕 ",  " ", " 󰃬",
  Property      = " ", --   Property = "󰜢", " ", " 󰖷"," "," 󰜢"
  Reference     = " 󰈇", --   Reference = "󰈇 ", " 󰈝",
  Snippet       = " ", --   Snippet = "󰅱 ",
  String        = "  ",
  Struct        = "  ", --   Struct = "󰙅 ", "  ", " 󰟦",
  Text          = " ", --   Text = " ",
  TypeParameter = " ", --   ' ', " 󰊄"
  Unit          = " ", --   Unit = "󰑭 ",
  Value         = " 󰎠",
  Variable      = " ", --   Variable = "󰈜 ", ' ',
}
local icons3 = {
  actions = {
    buffer_close = "󰅖",
    paste = "󰅌",
    search = "",
    tab_close = "󰅙",
  },
  git = {
    git = "󰊢",
    added = "",
    branch = "",
    changed = "",
    conflict = "",
    deleted = "",
    ignored = "◌",
    renamed = "➜",
    staged = "✓",
    unstaged = "✗",
    untracked = "★",
  },
  lsp_ts = {
    active_lsp = "",
    active_ts = "",
    lsp_loaded = "",
    lsp_loading1 = "",
    lsp_loading2 = "",
    lsp_loading3 = "",
  },
  dap = {
    breakpoint = "",
    breakpoint_condition = "",
    breakpoint_rejected = "",
    logpoint = ".>",
    stopped = "󰁕",
  },
  states = {
    file_modified = "",
    file_read_only = "",
    fold_closed = "",
    folder_closed = "",
    folder_empty = "",
    folder_open = "",
    macro_recording = "",
    selected = "❯",
    spellcheck = "󰓆",
  },
  diagnostics = {
    diagnostic = "󰒡",
    error = "",
    hint = "󰌵",
    info = "󰋼",
    warn = "",
  },
  misc = {
    default_file = "󰈙",
    ellipsis = "…",
    arrow_left = "",
    arrow_right = "",
    file_modified = "",
    fold_opened = "",
    fold_separator = " ",
    folder_closed = "",
    folder_empty = "",
    selected = "❯",
    spellcheck = "󰓆",
  },
}

return {
  SYMBOL_MAP = SYMBOL_MAP,
}
