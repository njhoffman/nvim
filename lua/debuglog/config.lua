-- User configuration section
local default_config = {
  -- Name of the plugin. Prepended to log messages
  plugin = "inspect",
  -- Should print the output to neovim while running
  use_console = false,
  -- Should highlighting be used in console (using echohl)
  highlights = true,
  -- Should write to a file
  use_file = true,
  -- Any messages above this level will be logged.
  level = "trace",
  -- Level configuration
  modes = {
    { name = "trace", hl = "Comment" },
    { name = "debug", hl = "Comment" },
    { name = "info", hl = "None" },
    { name = "warn", hl = "WarningMsg" },
    { name = "error", hl = "ErrorMsg" }
  },
  -- Can limit the number of decimals displayed for floats
  float_precision = 0.01
}

local config = {
  level = "trace",
  modes = {
    { name = "trace", hl = "Comment" },
    { name = "debug", hl = "Comment" },
    { name = "info", hl = "None" },
    { name = "warn", hl = "WarningMsg" },
    { name = "error", hl = "ErrorMsg" },
    { name = "fatal", hl = "ErrorMsg" },
    { name = "inspect", hl = "NotifyINSPECTTitle" },
    { name = "task", hl = "NotifyTASKTitle" },
    { name = "status", hl = "NotifySTATUSTitle" }
  },
  float_precision = 0.01,
  use_console = false,
  highlights = true,
  plugin = "inspect",
  use_file = true
}

config.outfile = string.format(
  "%s/%s.log",
  vim.api.nvim_call_function(
    "stdpath",
    {
      "cache"
    }
  ),
  config.plugin
)

config.start_time = os.clock()
config = vim.tbl_deep_extend("force", default_config, config)
return config
