local get_load_time = function()
  local load_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
  load_time = string.sub(string.gsub(load_time, ' ', ''), 1, 5)
  vim.g.load_time = load_time

  -- TODO: e for load .sh direct, aucmd for markdown to pandoc
  local bufname = vim.api.nvim_buf_get_name(0)
  if #bufname > 0 and not string.match(bufname, '^term://') and not string.match(bufname, '^man://') then
    vim.cmd('e')
  end

  vim.defer_fn(function()
    vim.api.nvim_exec_autocmds({ 'BufNewFile', 'BufReadPre', 'BufReadPost' }, {})
  end, 1)

  vim.defer_fn(function()
    vim.notify('Loaded in ' .. load_time .. 's', 1, { anchor = 'TC' })
  end, 1000)
end

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = get_load_time,
  desc = 'Create startup time notification when vim is finished loading',
})

local window_resized = function()
  -- TODO: use different values for startup and resizing
  local is_open = require('sidebar.state').open
  local win_width = vim.api.nvim_win_get_width(0)
  vim.defer_fn(function()
    -- vim.cmd('echom "Width: ' .. win_width .. '"')
    if win_width < 80 and not is_open then
      require('barbar.events').disable()
    else
      require('barbar.events').enable()
    end
    if win_width > 140 then
      require('sidebar').open()
      -- TODO: calculate width if sidebar open
      -- elseif is_open then
      --   require('sidebar').close()
    end
  end, 1)
end

vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResized' }, {
  pattern = '*',
  callback = window_resized,
  desc = 'Create startup time notification when vim is finished loading',
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
