-- User configuration section
return {
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
