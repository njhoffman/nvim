local structlog = require('structlog')

local M = {}
M.console = function()
  return structlog.sinks.Console(structlog.level.WARN, {
    processors = {
      structlog.processors.Namer(),
      -- structlog.processors.Timestamper("%H:%M:%S"),
    },
    formatter = structlog.formatters.FormatColorizer(
      '[%s] %s: %-30s',
      { 'level', 'logger_name', 'msg' },
      { level = structlog.formatters.FormatColorizer.color_level() }
      -- "%s [%s] %s: %-30s",
      -- { "timestamp", "level", "logger_name", "msg" },
    ),
  })
end

M.notify = function()
  return structlog.sinks.NvimNotify(structlog.level.WARN, {
    processors = {
      structlog.processors.Namer(),
    },
    formatter = structlog.formatters.Format('%s', { 'msg' }, { blacklist = { 'level', 'logger_name' } }), --
    params_map = { title = 'logger_name' },
  })
end

-- TODO: get tmux pane width
-- TODO: make clear function that wipes history outputs new lines
local banner_files = {}
local log_banner = function(file)
  local bar = string.rep('_', 70, '') --
  local banner = { bar, '', '--        Enter at ' .. os.date(), bar, '' }
  local fd = io.open(file, 'a')
  if fd ~= nil then
    fd:write(vim.fn.join(banner, '\n') .. '\n')
  end
  table.insert(banner_files, file)
end

M.file = function(level, logfile, config)
  config = config or {}
  if type(logfile) ~= 'string' or #logfile == 0 then
    logfile = vim.fn.stdpath('data') .. '/nvim.log'
  end
  level = level or structlog.level.TRACE
  if config.banner and not vim.tbl_contains(banner_files, logfile) then
    log_banner(logfile)
  end
  return structlog.sinks.File(level, logfile, {
    processors = {
      structlog.processors.Namer(),
      -- structlog.processors.StackWriter({ "line", "file" }, {
      --   max_parents = 12,
      --   stack_level = 0,
      -- }),
      structlog.processors.Timestamper('%H:%M:%S'),
      function(_, kwargs)
        if type(kwargs['msg']) == 'table' then
          kwargs['msg'] = vim.inspect(kwargs['msg'])
        end
        return kwargs
      end,
    },
    formatter = structlog.formatters.Format(
      '%s [%s] %s: %-30s',
      { 'timestamp', 'level', 'logger_name', 'msg' },
      { level = structlog.formatters.FormatColorizer.color_level() }
    ),
  })
end

return M
