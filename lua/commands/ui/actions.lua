local utils = require('commands.ui.utils')

local auto_close = {
  'noice',
  'qf',
  'help',
  'notify',
}

-- local cmd = 'BufferDelete'
local cmd = 'Bdelete'
local close_multi = function(skip_prompt)
  local tabs = vim.api.nvim_list_tabpages() or {}
  local splits = utils.get_splits({ 'l', 'h', 'j', 'k' }, true) or {}
  local curr_win = vim.api.nvim_get_current_win()
  local is_popup = vim.tbl_get(vim.api.nvim_win_get_config(curr_win), 'relative') ~= ''
  if #tabs > 1 then
    vim.cmd('silent! ' .. cmd .. '')
    vim.cmd('tabclose!')
    return
  end
  local bufs = utils.get_loaded_buffers()
  local ft = vim.bo.filetype

  if vim.tbl_contains(auto_close, ft) then
    pcall(vim.api.nvim_win_close, curr_win, skip_prompt)
  elseif is_popup then
    pcall(vim.api.nvim_win_close, curr_win, skip_prompt)
  elseif #splits > 1 then
    pcall(vim.api.nvim_win_close, curr_win, skip_prompt)
  else
    if skip_prompt == true then
      vim.cmd('silent! ' .. cmd .. '!')
      if #bufs == 0 then
        vim.cmd('exit')
      end
    else
      if #bufs > 0 then
        local ok, err = pcall(vim.api.nvim_command, 'silent ' .. cmd)
        if not ok then
          vim.notify('close_multi failed: silent ' .. cmd .. ' ' .. vim.inspect(err), 1)
        end
      end
    end
  end
  if #bufs == 0 then
    vim.cmd('silent! Alpha')
  end
end

local close_multi_no_prompt = function()
  close_multi(true)
end

local close_popups = function()
  local n = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= '' then
        n = n + 1
        vim.api.nvim_win_close(win, false)
      end
    end
  end
  print('Closed ' .. n .. ' popup windows')
end

return {
  close_multi = close_multi,
  close_multi_no_prompt = close_multi_no_prompt,
  close_popups = close_popups,
}
