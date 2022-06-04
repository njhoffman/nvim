-- local treeParsers = require('settings-parsers')
local settings = {}

settings.Load = {
  type = "normal", -- normal, async
  impatient = true,
  profile_load = false,
  profile_impatient = false,
  profile_packer = false
}

-- TODO: notify_level and notify_visual_level, telescope log, dap log, efm log
settings.Logging = {
  notify_level = "trace",
  log_level = "debug",
  console_level = "debug",
  lsp_level = "info"
}

local levels = vim.lsp.log_levels
settings.Logging.numeric = {
  notify_level = levels[settings.Logging.notify_level:upper()],
  log_level = levels[settings.Logging.log_level:upper()],
  console_level = levels[settings.Logging.console_level:upper()],
  lsp_level = levels[settings.Logging.lsp_level:upper()]
}

settings.Opts = {
  preserve_cursor = true,
  highlight_yank = true,
  relativenumber = true,
  cursorline = true,
  listchars = true,
  wrap = false,
  timeoutlen = 200,
  updatetime = 300,
  scrolloff = 10,
  explorer_side = "right",
  log_stdout = false,
}

settings.Theming = {
  colorscheme = "nord",
  diagnostic_colors = {
    Error = "#db4b4b",
    -- Warning = "#e0af68",
    Warning = "#904f38",
    Information = "#0db9d7",
    Hint = "#10B981"
  }
}

settings.DAP = {
  enabled = true,
  log_level = "error",
  -- log_path = vim.fn.stdpath("log") .. "/dap.log",
  virtual_text = true,
  python = true,
  go = true,
  javascript = true
}

-- -- trace, debug, info, warn, error
-- vim.lsp.set_log_level("info")
settings.LSP = {
  enabled = true,
  -- TODO: efm or other lsp format boolean
  underline = false,
  update_in_insert = true,
  signs = true,
  highlight_word = false,
  hover_diagnostic = false, -- false, virtual, popup
  virtual_text = false,
  -- virtual_text = {
  --   show_diagnostic_autocmds = { "InsertLeave", "TextChanged" },
  --   diagnostic_delay = 500,
  --   spacing = 2,
  --   severity_limit = "Warning",
  --   prefix = "●",
  -- },
  -------------
  -- Autostart --
  ---------------
  angular = false,
  bash = true,
  cmake = false,
  cpp = true,
  csharp = true,
  css = true,
  dockerfile = true,
  elixir = false,
  elm = true,
  go = true,
  graphql = true,
  html = true,
  java = true,
  json = true,
  kotlin = false,
  latex = false,
  lua = true,
  php = true,
  python = true,
  ruby = true,
  rust = true,
  svelte = false,
  tailwindcss = true,
  terraform = true,
  typescript = true,
  vim = true,
  vue = false,
  yaml = true,
  -- non-language specific
  deno = false,
  diagnosticls = false,
  efm = true,
  rome = false
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
  format_on_save = true,
  trim_trailing_space = true,
  indent_size = 2
}

settings.Treesitter = {
  enabled = true,
  rainbow = false,
  indent = true,
  highlight = false,
  context = false,
  autotag = true
  -------------
  -- Parsers --
  -------------
  -- parsers = treeParsers
}

settings.Plugins = { disabled = {} }

return settings
