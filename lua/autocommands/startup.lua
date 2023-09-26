local get_load_time = function()
  local load_time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
  load_time = string.sub(string.gsub(load_time, ' ', ''), 1, 5)
  vim.g.load_time = load_time

  local win_width = vim.api.nvim_win_get_width(0)
  if win_width < 80 then
    require('barbar.events').disable()
  end
  if win_width > 160 then
    require('sidebar').open()
  end

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
