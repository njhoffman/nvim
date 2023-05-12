-- stylua: ignore start

local icons = {
  lsp = {
    Array         = {" ", " "},
    Boolean       = {"◩ ", " "},
    Class         = {" ", " ", "ﴯ "},
    Color         = {" ", " "},
    Constant      = {" ", " ", "ﲀ ", " ", ' ', " "},
    Constructor   = {" ", " ", "⌘ ", " ", " "},
    Default       = {" "},
    Enum          = {" ", "練", " ", "了"},
    EnumMember    = {" ", " "},
    Event         = {" ", " ", "ﳅ "},
    Field         = {" ", " ", "ﰠ "},
    File          = {" ", " ", " "},
    Folder        = {" ", " "},
    Function      = {" ", " ", " "},
    Interface     = {" ", "練", "ﰮ ", " "},
    Key           = {" ", " ", "廓", " "},
    Keyword       = {" ", " ", "廓", " "},
    Macro         = {" "},
    Method        = {" ", " ", " ", " "},
    Module        = {" ", " ", " ", ' '},
    Namespace     = {" ", " "},
    Null          = {"ﳠ ", " "},
    Number        = {" ", " "},
    Object        = {" ", " "},
    Operator      = {" ", " ", " "},
    Package       = {" ", " "},
    Property      = {" ", " ", " ", "襁", "ﰠ "},
    Reference     = {" ", ' ', " ", " "},
    Snippet       = {" ", " ", " ", " "},
    String        = {" ", " "},
    Struct        = {" ", " ", "ﳤ ", " ", 'פּ ', " "},
    Text          = {' ', " ", " ", " ", " "},
    TypeParameter = {" ", " ", " "},
    Unit          = {" ", " ", "塞", ' '},
    Value         = {" ", " "},
    Variable      = {" ", " ", " ", " ", " "},
  },
  git = {
    git           = "",
    added         = "",
    branch        = "",
    changed       = "",
    conflict      = "",
    deleted       = "",
    ignored       = "◌",
    renamed       = "➜",
    staged        = "✓",
    unstaged      = "✗",
    untracked     = "★",
  },
  action = {
    buffer_close = "",
    paste        = "",
    search       = "",
    tab_close    = "",
  }
}

icons.lsp_numbers = {
  [1] = icons.lsp.File,
  [2] = icons.lsp.Module,
  [3] = icons.lsp.Namespace,
  [4] = icons.lsp.Package,
  [5] = icons.lsp.Class,
  [6] = icons.lsp.Method,
  [7] = icons.lsp.Property,
  [8] = icons.lsp.Field,
  [9] = icons.lsp.Constructor,
  [10] = icons.lsp.Enum,
  [11] = icons.lsp.Interface,
  [12] = icons.lsp.Function,
  [13] = icons.lsp.Variable,
  [14] = icons.lsp.Constant,
  [15] = icons.lsp.String,
  [16] = icons.lsp.Number,
  [17] = icons.lsp.Boolean,
  [18] = icons.lsp.Array,
  [19] = icons.lsp.Object,
  [20] = icons.lsp.Key,
  [21] = icons.lsp.Null,
  [22] = icons.lsp.Member,
  [23] = icons.lsp.Struct,
  [24] = icons.lsp.Event,
  [25] = icons.lsp.Operator,
  [26] = icons.lsp.Parameter,
  [255] = icons.lsp.Macro,
}

local get_icons = function(set)
  local icon_set = set and icons[set] or icons.lsp
  return vim.tbl_map(function(icon)
    return type(icon) == 'table' and icon[1] or icon
  end, icon_set)
end

return {
  icons = icons,
  get_icons = get_icons
}

--   lsp_ts = {
--     active_lsp = "",
--     active_ts = "",
--     lsp_loaded = "",
--     lsp_loading1 = "",
--     lsp_loading2 = "",
--     lsp_loading3 = "",
--   },
--   dap = {
--     breakpoint = "",
--     breakpoint_condition = "",
--     breakpoint_rejected = "",
--     logpoint = ".>",
--     stopped = "",
--   },
--   states = {
--     file_modified = "",
--     file_read_only = "",
--     fold_closed = "",
--     folder_closed = "",
--     folder_empty = "",
--     folder_open = "",
--     macro_recording = "",
--     selected = "❯",
--     spellcheck = "暈",
--   },
--   diagnostics = {
--     diagnostic = "裂",
--     error = "",
--     hint = "",
--     info = "",
--     warn = "",
--   },
--   misc = {
--     default_file = "",
--     ellipsis = "…",
--     arrow_left = "",
--     arrow_right = "",
--     file_modified = "",
--     fold_opened = "",
--     fold_separator = " ",
--     folder_closed = "",
--     folder_empty = "",
--     selected = "❯",
--     spellcheck = "暈",
--   },
-- }
--
