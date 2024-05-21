-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

local utils = require('internals.utils')

local verbose_defs = {
  ['1'] = 'Lua assignments to options, mappings, etc',
  ['2'] = 'When a file is ":source"d, or |shada| file is read or written',
  ['3'] = 'UI info, terminal capabilities',
  ['4'] = 'Shell commands',
  ['5'] = 'Every searched tags file and include file (1)',
  ['6'] = 'Every searched tags file and include file (2)',
  ['7'] = 'Every searched tags file and include file (3)',
  ['8'] = 'Files for which a group of autocommands is executed',
  ['9'] = 'Executed autocommands (1)',
  ['10'] = 'Executed autocommands (2)',
  ['11'] = 'Finding items in a path',
  ['12'] = 'Vimscript function calls',
  ['13'] = 'When an exception is thrown, caught, finished, or discarded',
  ['14'] = 'Anything pending in a ":finally" clause',
  ['15'] = 'Ex commands from a script (truncated at 200 characters)',
  ['16'] = 'Ex commands',
}

local verbose_levels = vim.fn.sort(vim.fn.keys(verbose_defs), function(a, b)
  return tonumber(a) > tonumber(b)
end)

local default_state = {
  running = false,
  start_time = nil,
  timer_id = nil,
  completed = {},
}

local state = vim.fn.deepcopy(default_state)

local default_config = {
  level = 0,
  path = '', -- vim.fn.tempname()
  name = 'default',
  base_dir = vim.fn.stdpath('log') .. '/profiles/',
}

local config = {}

local select_level = utils.async(function()
  vim.ui.select(verbose_levels, {
    prompt = 'Set verbose level (1-16):',
    format_item = function(level)
      return level .. ': ' .. verbose_levels[level]
    end,
  }, function(level)
    level = tonumber(level) or 0
    if level > 0 then
      config.level = level
    end
  end)
end)

local select_name = utils.async(function()
  vim.ui.input({
    prompt = 'Set profile name:',
    default = config.name,
  }, function(name)
    if name and name ~= '' then
      config.name = name
    end
  end)
end)

local setup_config = function(opts)
  config = vim.tbl_deep_extend('force', default_config, opts or {})
  if config.verbose == 0 then
    coroutine.resume(select_level)
  end

  if config.name == '' then
    coroutine.resume(select_name)
  end

  if config.level == 0 or config.name == '' then
    return false
  end

  local target_dir = config.base_dir .. '/' .. config.name
  vim.fn.mkdir(target_dir, 'p')
  config.path = target_dir .. '/vfile-' .. tostring(config.level) .. '.log'
  return true
end

local set_option = vim.api.nvim_set_option_value

local start = function(opts)
  if not setup_config(opts) then
    vim.notify(
      'Failed to setup verbosefile profiler: ' .. vim.inspect(config),
      vim.log.levels.ERROR
    )
    return
  end

  state.start_time = vim.fn.reltime()
  state.running = true

  set_option('verbosefile', config.path, { scope = 'global' })
  set_option('verbose', config.level, { scope = 'global' })
end

local stop = function()
  set_option('verbosefile', '', { scope = 'global' })
  set_option('verbose', 0, { scope = 'global' })

  local time_duration = vim.fn.reltime(state.start_time)
  table.insert(
    state.completed,
    vim.tbl_deep_extend('force', config, { date = os.date(), duration = time_duration })
  )

  state.running = false
  state.start_time = nil
end

return {
  start = start,
  stop = stop,
  state = state,
}
