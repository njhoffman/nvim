-- stylua: ignore
local SYMBOL_MAP = {
  Text           = " ",
  Method         = " ",
  Function       = "",
  Constructor    = " ",
  Field          = " ",
  Variable       = " ",
  Class          = " ",
  Interface      = " ",
  Module         = " ",
  Property       = " ",
  Unit           = "塞",
  Value          = " ",
  Enum           = " ",
  Keyword        = " ",
  Snippet        = " ",
  Color          = " ",
  File           = " ",
  Reference      = " ",
  Folder         = " ",
  EnumMember     = " ",
  Constant       = " ",
  Struct         = " ",
  Event          = "",
  Operator       = " ",
  TypeParameter  = " ",
}

-- stylua: ignore
local lsp_symbols = {
  Text            = "", --   Text = " ",
  Method          = "",
  Function        = "",
  Constructor     = "", --   Constructor = "⌘ ",
  Field           = "ﰠ", --   Field = "ﰠ ",
  Variable        = "", --   Variable = " ",
  Class           = "", --   Class = "ﴯ ",
  Interface       = "ﰮ", --   Interface = " ",
  Module          = "", --   Module = " ",
  Property        = "襁", --   Property = "ﰠ",
  Unit            = "", --   Unit = "塞 ",
  Value           = "",
  Enum            = "練", --   Enum = " ",
  Keyword         = "", --   Keyword = "廓 ",
  Snippet         = "", --   Snippet = " ",
  Color           = "",
  File            = "", --   File = " ",
  Reference       = "", --   Reference = " ",
  Folder          = "",
  EnumMember      = "",
  Constant        = "ﲀ", --   Constant = " ",
  Struct          = "ﳤ", --   Struct = "פּ ",
  Event           = "",
  Operator        = "", --   Operator = " ",
  TypeParameter   = "",
}

-- stylua: ignore
local icons2    = {
  Array         = " ", --
  Boolean       = " ", --
  Class         = " ", --   Class = " ﴯ","  "
  Color         = " ",
  Constant      = " ﲀ", --   Constant = " ",
  Constructor   = " ⌘", --   Constructor = "⌘ ","" ' ', " ",
  Enum          = " 練", --   Enum = " " " " ,
  EnumMember    = " ", -- ' '
  Event         = " ", -- " "
  Field         = " ", --   Field = "ﰠ ", " ", " ﰠ",
  File          = " ", --   File = " ", " ", " " ,
  Folder        = " ",
  Function      = " ",
  Interface     = " ", --   Interface = " ", ' ', " ﰮ",
  Keyword       = " ", --   Keyword = "廓 ",
  Key           = " ",
  Method        = " ",
  Number        = " ",
  Null          = " ", -- "", " "
  Module        = " ", --   Module = " ",
  Object        = " ", --
  Operator      = " ", --   Operator = " ",  " ", " ",
  Property      = " ", --   Property = "ﰠ", " ", " 襁"," "," ﰠ"
  Reference     = " ", --   Reference = " ", " ",
  Snippet       = " ", --   Snippet = " ",
  String        = "  ",
  Struct        = "  ", --   Struct = "פּ ", "  ", " ﳤ",
  Text          = " ", --   Text = " ",
  TypeParameter = " ", --   ' ', " "
  Unit          = " ", --   Unit = "塞 ",
  Value         = " ",
  Variable      = " ", --   Variable = " ", ' ',
}
local icons3 = {
  actions = {
    buffer_close = "",
    paste = "",
    search = "",
    tab_close = "",
  },
  git = {
    git = "",
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
    stopped = "",
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
    spellcheck = "暈",
  },
  diagnostics = {
    diagnostic = "裂",
    error = "",
    hint = "",
    info = "",
    warn = "",
  },
  misc = {
    default_file = "",
    ellipsis = "…",
    arrow_left = "",
    arrow_right = "",
    file_modified = "",
    fold_opened = "",
    fold_separator = " ",
    folder_closed = "",
    folder_empty = "",
    selected = "❯",
    spellcheck = "暈",
  },
}

return {
  SYMBOL_MAP = SYMBOL_MAP,
}
