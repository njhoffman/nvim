local M = {}
local config = require("debuglog.config")

M.output_log = function(level, level_config, message_maker, ...)
  -- Return early if we're below the config.level
  local levels = {}
  for i, v in ipairs(config.modes) do
    levels[v.name] = i
  end
  if level < levels[config.level] then
    return
  end
  local nameupper = level_config.name:upper()

  local msg = message_maker(...)
  local info = debug.getinfo(2, "Sl")
  local lineinfo = info.short_src .. ":" .. info.currentline

  -- Output to console
  if config.use_console then
    local console_string = string.format("[%-6s%s] %s: %s", nameupper, os.date("%H:%M:%S"), lineinfo, msg)

    if config.highlights and level_config.hl then
      vim.cmd(string.format("echohl %s", level_config.hl))
    end

    local split_console = vim.split(console_string, "\n")
    for _, v in ipairs(split_console) do
      vim.cmd(string.format([[echom "[%s] %s"]], config.plugin, vim.fn.escape(v, '"')))
    end

    if config.highlights and level_config.hl then
      vim.cmd("echohl NONE")
    end
  end

  -- Output to log file
  if config.use_file then
    local fp = io.open(config.outfile, "a")
    local time_diff = string.sub((os.clock() - config.start_time) * 1, 1, 6)
    local str = string.format("%-6s [DEBUG] %s\n", time_diff, msg)
    fp:write(str)
    fp:close()
  end
end

return M.output_log
