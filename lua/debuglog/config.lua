local default_config = require('debuglog.config-default')

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
  "%s/%s.log", vim.api.nvim_call_function("stdpath", { "data" }),
  config.plugin
)
config.start_time = os.clock()
config = vim.tbl_deep_extend("force", default_config, config)
return config
