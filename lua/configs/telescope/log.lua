-- Keeps telescope's log out of the message area and sends it to lib.logger as well.

local M = {}

local configured = false

local format = function(is_console, mode_name, _, _, msg)
  local nameupper = mode_name:upper()
  if is_console then
    return string.format("[%-6s%s] : %s", nameupper, os.date("%H:%M:%S"), msg)
  end
  return string.format("[%-6s%s] : %s\n", nameupper, os.date("%m.%d.%y %H:%M:%S"), msg)
end

M.setup = function()
  if configured then
    return
  end
  configured = true

  local log = require("telescope.log")
  local logger = require("lib.logger").init("telescope")

  for _, target in ipairs({ log, log.timing }) do
    target.level = "debug"
    target.use_console = false
    target.fmt_msg = format
    for _, level in ipairs({ "trace", "debug", "info", "warn", "error" }) do
      local write = target[level]
      target[level] = function(...)
        write(...)
        logger[level](logger, ...)
      end
    end
  end
end

return M
