-- local treeParsers = require('settings-parsers')
local settings = {}
local get_opt = require('utils.options').get_option_value

settings.Load = {
  impatient         = true,
  profile_load      = false,
  profile_impatient = false,
  profile_packer    = false
}

-- TODO: notify_level and notify_visual_level, telescope log, dap log, efm log
settings.Logging = {
  notify_level_show   = get_opt('notify_level_show'),
  notify_level_record = get_opt('notify_level_record'),
  notify_level_log    = get_opt('notify_level_log'),
  log_level           = "debug",
  console_level       = "debug",
  lsp_level           = "warn"
}

local levels = vim.lsp.log_levels
settings.Logging.numeric = {
  notify_level_show   = levels[settings.Logging.notify_level_show:upper()],
  notify_level_record = levels[settings.Logging.notify_level_record:upper()],
  notify_level_log    = levels[settings.Logging.notify_level_log:upper()],
  log_level           = levels[settings.Logging.log_level:upper()],
  console_level       = levels[settings.Logging.console_level:upper()],
  lsp_level           = levels[settings.Logging.lsp_level:upper()]
}

settings.Opts = {
  preserve_cursor = true,
  highlight_yank  = true,
  relativenumber  = true,
  cursorline      = true,
  listchars       = true,
  wrap            = false,
  timeoutlen      = 200,
  updatetime      = 300,
  scrolloff       = 10,
  explorer_side   = "right",
  log_stdout      = false,
}

settings.Theming = {
  colorscheme       = "nord",
  diagnostic_colors = {
    Error       = "#db4b4b",
    -- Warning = "#e0af68",
    Warning     = "#904f38",
    Information = "#0db9d7",
    Hint        = "#10B981"
  }
}

settings.DAP = {
  enabled      = true,
  log_level    = "error",
  -- log_path = vim.fn.stdpath("data") .. "/dap.log",
  virtual_text = true,
  python       = true,
  go           = true,
  javascript   = true
}

-- -- trace, debug, info, warn, error
-- vim.lsp.set_log_level("info")
settings.LSP = {
  enabled          = true,
  -- TODO: efm or other lsp format boolean
  underline        = false,
  update_in_insert = true,
  signs            = true,
  highlight_word   = false,
  hover_diagnostic = false, -- false, virtual, popup
  virtual_text     = false,
  -- virtual_text = {
  --   show_diagnostic_autocmds = { "InsertLeave", "TextChanged" },
  --   diagnostic_delay = 500,
  --   spacing = 2,
  --   severity_limit = "Warning",
  --   prefix = "●",
  -- },
}

settings.Formatting = {
  -- if format_on_save is enable it will always trim trailing white spaces
  format_on_save = true,
  trim_trailing_space = true,
  indent_size = 2
}

settings.Completion = {
  enabled = true,
  autopairs = true,
  items = 10,
  ---------------------------
  -- Sources of Completion --
  ---------------------------
  snippets = true,
  lsp = true,
  buffer = true,
  path = true,
  calc = true,
  spell = false,
  emoji = true
}

settings.Formatting = {
  -- if format_on_save is enable it will always trim trailing white spaces
  format_on_save      = true,
  trim_trailing_space = true,
  indent_size         = 2
}

settings.Treesitter = {
  enabled = true,
  rainbow = false,
  indent = true,
  highlight = false,
  context = false,
  autotag = true
}

return settings
