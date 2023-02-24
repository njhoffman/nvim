local default_cfg = {

  -- tokyonight.normal = { bg = c.none, fg = c.fg_dark }
  -- tokyonight.modified = { fg = c.warning }
  -- tokyonight.ellipsis = { fg = c.dark5 }
  -- tokyonight.separator = { fg = c.dark5 }
  -- tokyonight.dirname = { fg = c.dark5 }
  -- tokyonight.basename = { fg = c.fg_dark, bold = true }
  -- tokyonight.context = { fg = c.fg_dark }
  --
  -- tokyonight.context_file = { fg = c.fg_dark }
  -- tokyonight.context_module = { fg = c.yellow }
  -- tokyonight.context_namespace = { fg = c.yellow }
  -- tokyonight.context_package = { fg = c.blue }
  -- tokyonight.context_class = { fg = c.orange }
  -- tokyonight.context_method = { fg = c.blue }
  -- tokyonight.context_property = { fg = c.green1 }
  -- tokyonight.context_field = { fg = c.green1 }
  -- tokyonight.context_constructor = { fg = c.blue }
  -- tokyonight.context_enum = { fg = c.orange }
  -- tokyonight.context_interface = { fg = c.orange }
  -- tokyonight.context_function = { fg = c.blue }
  -- tokyonight.context_variable = { fg = c.magenta }
  -- tokyonight.context_constant = { fg = c.magenta }
  -- tokyonight.context_string = { fg = c.green }
  -- tokyonight.context_number = { fg = c.orange }
  -- tokyonight.context_boolean = { fg = c.orange }
  -- tokyonight.context_array = { fg = c.orange }
  -- tokyonight.context_object = { fg = c.orange }
  -- tokyonight.context_key = { fg = c.purple }
  -- tokyonight.context_null = { fg = c.orange }
  -- tokyonight.context_enum_member = { fg = c.green1 }
  -- tokyonight.context_struct = { fg = c.orange }
  -- tokyonight.context_event = { fg = c.orange }
  -- tokyonight.context_operator = { fg = c.green1 }
  -- tokyonight.context_type_parameter = { fg = c.green1 }
  ---whether to attach navic to language servers automatically

  ---@type boolean
  attach_navic = true,

  ---whether to create winbar updater autocmd
  ---@type boolean
  create_autocmd = true,

  ---buftypes to enable winbar in
  ---@type string[]
  include_buftypes = { "" },

  ---filetypes not to enable winbar in
  ---@type string[]
  exclude_filetypes = { "gitcommit", "toggleterm" },

  modifiers = {
    ---filename modifiers applied to dirname
    ---@type string
    dirname = ":~:.",
    basename = "",
  },
  show_dirname = true,
  ---@type boolean
  show_modified = false,
  show_navic = true,
  custom_section = function()
    return ""
  end,
  symbols = {
    ---modification indicator
    ---@type string
    modified = "●",

    ---truncation indicator
    ---@type string
    ellipsis = "…",

    ---entry separator
    ---@type string
    separator = "",
  },
  kinds = {
    File = "",
    Module = "",
    Namespace = "",
    Package = "",
    Class = "",
    Method = "",
    Property = "",
    Field = "",
    Constructor = "",
    Enum = "",
    Interface = "",
    Function = "",
    Variable = "",
    Constant = "",
    String = "",
    Number = "",
    Boolean = "",
    Array = "",
    Object = "",
    Key = "",
    Null = "",
    EnumMember = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },
  theme = {
    normal = { fg = "#c0caf5" },
    -- these highlights correspond to symbols table from config
    ellipsis = { fg = "#737aa2" },
    separator = { fg = "#737aa2" },
    modified = { fg = "#737aa2" },

    -- these highlights represent the _text_ of three main parts of barbecue
    dirname = { fg = "#737aff" },
    basename = { bold = false },
    context = {},

    -- these highlights are used for context/navic icons
    context_file = { fg = "#ac8fe4" },
    context_module = { fg = "#ac8fe4" },
    context_namespace = { fg = "#ac8fe4" },
    context_package = { fg = "#ac8fe4" },
    context_class = { fg = "#ac8fe4" },
    context_method = { fg = "#ac8fe4" },
    context_property = { fg = "#ac8fe4" },
    context_field = { fg = "#ac8fe4" },
    context_constructor = { fg = "#ac8fe4" },
    context_enum = { fg = "#ac8fe4" },
    context_interface = { fg = "#ac8fe4" },
    context_function = { fg = "#ac8fe4" },
    context_variable = { fg = "#ac8fe4" },
    context_constant = { fg = "#ac8fe4" },
    context_string = { fg = "#ac8fe4" },
    context_number = { fg = "#ac8fe4" },
    context_boolean = { fg = "#ac8fe4" },
    context_array = { fg = "#ac8fe4" },
    context_object = { fg = "#ac8fe4" },
    context_key = { fg = "#ac8fe4" },
    context_null = { fg = "#ac8fe4" },
    context_enum_member = { fg = "#ac8fe4" },
    context_struct = { fg = "#ac8fe4" },
    context_event = { fg = "#ac8fe4" },
    context_operator = { fg = "#ac8fe4" },
    context_type_parameter = { fg = "#ac8fe4" },
  },
}

bg = "#222244"
local cfg = {
  theme = {
    normal = { fg = "#c0caf5", bg = "#111111" },
    -- these highlights correspond to symbols table from config
    ellipsis = { fg = "#737aa2" },
    separator = { fg = "#737aa2" },
    modified = { fg = "#737aa2" },

    -- these highlights represent the _text_ of three main parts of barbecue
    dirname = { fg = "#44aacc" },
    basename = { bold = true },
    context = {},

    -- these highlights are used for context/navic icons
    context_file = { fg = "#ac8fe4" },
    context_module = { fg = "#ac8fe4" },
    context_namespace = { fg = "#ac8fe4" },
    context_package = { fg = "#ac8fe4" },
    context_class = { fg = "#ac8fe4" },
    context_method = { fg = "#ac8fe4" },
    context_property = { fg = "#ac8fe4" },
    context_field = { fg = "#ac8fe4" },
    context_constructor = { fg = "#ac8fe4" },
    context_enum = { fg = "#ac8fe4" },
    context_interface = { fg = "#ac8fe4" },
    context_function = { fg = "#ac8fe4" },
    context_variable = { fg = "#ac8fe4" },
    context_constant = { fg = "#ac8fe4" },
    context_string = { fg = "#ac8fe4" },
    context_number = { fg = "#ac8fe4" },
    context_boolean = { fg = "#ac8fe4" },
    context_array = { fg = "#ac8fe4" },
    context_object = { fg = "#ac8fe4" },
    context_key = { fg = "#ac8fe4" },
    context_null = { fg = "#ac8fe4" },
    context_enum_member = { fg = "#ac8fe4" },
    context_struct = { fg = "#ac8fe4" },
    context_event = { fg = "#ac8fe4" },
    context_operator = { fg = "#ac8fe4" },
    context_type_parameter = { fg = "#ac8fe4" },
  },
}

require("barbecue").setup(cfg)
