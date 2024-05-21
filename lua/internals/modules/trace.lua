--------------------------------------------------------------------------
--- profile.nvim
-- start with NVIM_PROFILE=1 nvim,  <F1> to start a profile, and <F1> again to complete the profile and save it to a file.
-- to profile the startup of neovim: do NVIM_PROFILE=start nvim and then hit <F1> as soon as neovim loads.
-- Specific modules: instead of start("*"), use start("aerial*") to profile just my aerial nvim plugin.
-- You can view the traces in chrome://tracing or at https://ui.perfetto.dev/

--- For testing whether a function is slow you down or not, you can use this snippets
-- keymap("n", "o", function()
--   vim.g.type_o = true
--   return "o"
-- end, { expr = true })
--- and put this at the top of the function
-- if vim.g.type_o then
--   local n = 1
--   for i = 1, 2000000000 do
--     n = n + 1
--   end
-- end

local utils = require('internals.utils')
local prof = require('profile')

local default_state = {
  running = prof.is_recording(),
  start_time = nil,
  completed = {},
}

local state = vim.fn.deepcopy(default_state)

local default_config = {
  path = '', -- vim.fn.tempname()
  name = 'default',
  base_dir = vim.fn.stdpath('log') .. '/profiles/',
}

local config = {}

local init = function(_)
  -- TODO: check if plenary and profile.nvim available
  local should_trace = os.getenv('NVIM_PROFILE')
  if should_trace then
    prof.instrument_autocmds()
    if should_trace:lower():match('^start') then
      prof.start('*')
    else
      prof.instrument('*')
    end
  end
end

local stop = function(_)
  prof.stop()

  if config.path then
    prof.export(config.path)
    vim.notify(string.format('Wrote %s', config.path))
  end

  local time_duration = vim.fn.reltime(state.start_time)

  state.running = false
  state.start_time = nil

  table.insert(
    state.completed,
    vim.tbl_deep_extend('force', config, { date = os.date(), duration = time_duration })
  )
end

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

  if config.name == '' then
    coroutine.resume(select_name)
  end

  local target_dir = config.base_dir .. '/' .. config.name
  vim.fn.mkdir(target_dir, 'p')
  config.path = target_dir .. '/vfile-' .. tostring(config.level) .. '.log'
  return true
end

local start = function(opts)
  if not setup_config(opts) then
    vim.notify('Failed to setup trace profiler: ' .. vim.inspect(config), vim.log.levels.ERROR)
    return
  end

  state.start_time = vim.fn.reltime()
  state.running = true
  prof.start('*')
end

return {
  init = init,
  start = start,
  stop = stop,
  state = state,
}
