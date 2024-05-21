local modules = require('internals.modules')

local create_cmd = vim.api.nvim_create_user_command

local command_exists = function(name)
  local cmds = vim.api.nvim_get_commands({})
  return vim.tbl_contains(cmds, name)
end

local delete_cmd = function(names)
  names = type(names) == 'table' and names or { names } or {}
  for _, name in ipairs(names) do
    if command_exists(name) then
      vim.api.nvim_del_user_command(name)
    end
  end
end

local create_start_completion = function()
  local cmds = {}
  for name, mod in pairs(modules.profilers) do
    if mod and type(mod.start) == 'function' then
      table.insert(cmds, name)
    end
  end
  return cmds
end

local create_view_completion = function()
  return { 'one', 'two', 'three' }
end

local M = {}
M.create_start = function(_)
  create_cmd('ProfileStart', function(cmd_opts)
    local p_name = cmd_opts and cmd_opts.args or ''
    if
      p_name ~= ''
      and modules.profilers[p_name]
      and type(modules.profilers[p_name].start == 'function')
    then
      modules.profilers[p_name].start(_)
      vim.defer_fn(M.update, 100)
    end
  end, {
    nargs = 1,
    desc = 'Start one of the configured profilers',
    complete = create_start_completion,
  })
end

M.create_stop = function(_)
  create_cmd('ProfileStop', function(cmd_opts)
    local p_name = cmd_opts and cmd_opts.args or ''
    if
      p_name ~= ''
      and modules.profilers[p_name]
      and type(modules.profilers[p_name].stop == 'function')
    then
      modules.profilers[p_name].stop(_)
      vim.defer_fn(M.update, 100)
    end
  end, {
    desc = 'Stop any profilers that are running',
  })
end

M.create_view = function(_)
  create_cmd('ProfileView', function(cmd_opts)
    local p_name = cmd_opts and cmd_opts.args or ''
    if p_name ~= '' then
      vim.dbglog('view profile command', p_name)
    end
  end, {
    nargs = 1,
    complete = create_view_completion,
    desc = 'View completed profile reports',
  })
end

M.update = function(_)
  local running = vim.tbl_map(function(mod)
    return mod.state and mod.state.running
  end, modules.profilers)

  local completed = vim.tbl_map(function(mod)
    return mod.state and mod.state.completed and #mod.state.completed > 0
  end, modules.profilers)

  if #completed == 0 then
    delete_cmd('ProfileView')
  end

  if #running == 0 then
    delete_cmd('ProfileStop')
    M.create_start(_)
    if #completed > 0 then
      M.create_view(_)
    end
  else
    delete_cmd({ 'ProfileStart', 'ProfileView' })
    M.create_stop(_)
  end
end

return M
