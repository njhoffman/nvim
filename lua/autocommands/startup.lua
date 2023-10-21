local get_load_time = function()
  local load_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
  load_time = string.sub(string.gsub(load_time, ' ', ''), 1, 5)
  vim.g.load_time = load_time

  vim.o.cmdheight = 0
  -- TODO: e for load .sh direct, aucmd for markdown to pandoc
  local bufname = vim.api.nvim_buf_get_name(0)
  if #bufname > 0 and not string.match(bufname, '^term://') and not string.match(bufname, '^man://') then
    vim.cmd('e')
  end

  -- vim.defer_fn(function()
  --   vim.api.nvim_exec_autocmds({ 'BufNewFile', 'BufReadPre', 'BufReadPost' }, {})
  -- end, 1)

  vim.defer_fn(function()
    vim.notify('Loaded in ' .. load_time .. 's', 1, { anchor = 'TC' })
  end, 2000)
end

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = get_load_time,
  desc = 'Create startup time notification when vim is finished loading',
})

local barbar_enabled = function()
  local aucmds = vim.api.nvim_get_autocmds({ group = 'barbar_render' })
  return #aucmds > 0
end

local window_adjust = function(w)
  return function()
    -- vim.defer_fn(function()
    --   local sidebar_open = require('sidebar.state').open
    --   local width = vim.api.nvim_get_option_value('columns', {})
    --   if width < w.barbar.off and barbar_enabled() and w.barbar.off ~= -1 then
    --     require('barbar.events').disable()
    --   elseif width > w.barbar.on and not barbar_enabled() and w.barbar.on ~= -1 then
    --     require('barbar.events').enable()
    --   end
    --   if width > w.sidebar.on and not sidebar_open and w.sidebar.on ~= -1 then
    --     require('sidebar').open()
    --   elseif width < w.sidebar.off and sidebar_open and w.sidebar.off ~= -1 then
    --     require('sidebar').close()
    --   end
    -- end, 10)
  end
end

local w_start = {
  barbar = { off = 60, on = 100 },
  sidebar = { off = 80, on = -1 },
}

local w_resize = {
  barbar = { off = 60, on = 100 },
  sidebar = { off = 100, on = 120 },
}

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  pattern = '*',
  callback = window_adjust(w_start),
  desc = 'Show or hide barbar and sidebar when vim is finished loading',
})

vim.api.nvim_create_autocmd({ 'VimResized' }, {
  pattern = '*',
  callback = window_adjust(w_resize),
  desc = 'Show or hide barbar and sidebar when the window is resized',
})

local get_command_val = function(name)
  local val = nil
  for i, arg in pairs(vim.v.argv) do
    if arg == '--' .. name then
      val = vim.v.argv[i + 1]
    end
  end
  return val
end

local cmd_val = get_command_val('startup-script')
if cmd_val ~= nil then
  vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    callback = function()
      vim.notify('Startup script: ' .. cmd_val)
    end,
    desc = 'Run startup script after vim is finished loading',
  })
end

cmd_val = get_command_val('startup-command')
if cmd_val ~= nil then
  vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    callback = function()
      vim.notify('Startup command: ' .. cmd_val)
    end,
    desc = 'Run startup commands after vim is finished loading',
  })
end
