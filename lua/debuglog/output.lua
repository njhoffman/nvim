local M = {}
local config = require('debuglog.config')

M.output_log = function(level, level_config, message_maker, ...)
  -- Return early if we're below the config.level
  local nameupper = level_config.name:upper()

  local msg = message_maker(...)
  local info = debug.getinfo(2, 'Sl')
  local lineinfo = info.short_src .. ':' .. info.currentline

  -- Output to console
  if config.use_console then
    local console_string = string.format('[%-6s%s] %s: %s', nameupper, os.date('%H:%M:%S'), lineinfo, msg)

    if config.highlights and level_config.hl then
      vim.cmd(string.format('echohl %s', level_config.hl))
    end

    local split_console = vim.split(console_string, '\n')
    for _, v in ipairs(split_console) do
      vim.cmd(string.format([[echom "[%s] %s"]], config.plugin, vim.fn.escape(v, '"')))
    end

    if config.highlights and level_config.hl then
      vim.cmd('echohl NONE')
    end
  end

  -- Output to log file
  if config.use_file then
    local files = type(config.outfile) == 'string' and { config.outfile } or config.outfile
    for _, file in ipairs(config.outfile) do
      local fp = io.open(file, 'a')
      if fp then
        local time_diff = string.sub(tostring((os.clock() - config.start_time) * 1), 1, 9)
        time_diff = #tostring(vim.fn.trim(time_diff)) < 9 and time_diff .. string.rep('0', 9 - #tostring(time_diff))
          or time_diff
        local str = string.format('%-9s %s\n', time_diff, msg)
        fp:write(str)
        fp:close()
      end
    end
  end
end

return M.output_log
