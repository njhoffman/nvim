local utils = require('commands.ui.utils')

local config = {
  auto_close_ft = {
    'noice',
    'qf',
    'help',
    'notify',
  },
  cmd = 'bdelete', -- 'BufferDelete', 'Bdelete'
}

local state = {}

local is_popup = function(win)
  return vim.tbl_get(vim.api.nvim_win_get_config(win or 0), 'relative') ~= ''
end

local get_state = function()
  state = vim.tbl_deep_extend('force', state, {
    tabs = vim.api.nvim_list_tabpages() or {},
    splits = utils.get_splits({ 'l', 'h', 'j', 'k' }) or {},
    curr_win = vim.api.nvim_get_current_win(),
    curr_tab = vim.api.nvim_get_current_tabpage(),
    bufs = utils.get_loaded_buffers(),
    ft = vim.bo.filetype,
  })
  state.curr_is_popup = is_popup(state.curr_win)
  state.curr_tab_wins = vim.api.nvim_tabpage_list_wins(state.curr_tab)
  vim.dbglog('state', state)
end

local close_multi = function(skip_prompt)
  get_state()

  if #state.tabs > 1 and #state.curr_tab_wins == 1 then
    return vim.cmd('tabclose!')
  end

  if state.curr_is_popup or #state.splits > 1 then
    return vim.api.nvim_win_close(state.curr_win, skip_prompt)
  end

  -- if vim.tbl_contains(auto_close_ft, ft) then
  --   pcall(vim.api.nvim_win_close, curr_win, skip_prompt)
  -- end

  if #state.bufs > 1 then
    return vim.api.nvim_command('silent! ' .. config.cmd)
  end

  if #state.bufs == 1 then
    vim.cmd('silent! Alpha')
    return vim.api.nvim_command(config.cmd .. ' #')
  end
  -- elseif state.ft ~= 'alpha' then
  --   vim.api.nvim_command('silent! ' .. config.cmd .. (skip_prompt == true and '!' or ''))
end

-- TODO: autocmd to handle start page as last buffer

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
