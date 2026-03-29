local plenary_log = require("plenary.log").new({
  -- file = vim.fn.stdpath("data") .. "/logs/telescope.log",
  plugin = "telescope",
  level = "debug",
  use_console = false,
  fmt_msg = function(is_console, mode_name, src_path, src_line, msg)
    local nameupper = mode_name:upper()
    -- local lineinfo = src_path .. ":" .. src_line
    local lineinfo = ""
    if is_console then
      return string.format("[%-6s%s] %s: %s", nameupper, os.date("%H:%M:%S"), lineinfo, msg)
    else
      local date = os.date("%m.%d.%y %H:%M:%S")
      return string.format("[%-6s%s] %s: %s\n", nameupper, date, lineinfo, msg)
    end
  end,
})

local logger = require("logger").init("telescope")

local log = function(lvl, ...)
  -- notify(message, vim.log.levels.ERROR)
  plenary_log[lvl](...)
  logger[lvl](logger, ...)
end

local M = {}
M.trace = function(...)
  log("trace", ...)
end

M.debug = function(...)
  log("debug", ...)
end

M.info = function(...)
  log("info", ...)
end

M.warn = function(...)
  log("warn", ...)
end

M.error = function(...)
  log("error", ...)
end

return M
