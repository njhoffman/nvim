local logger = require('logger').init('notify')

local find = function(array, key, val)
  for _, v in ipairs(array) do
    if v[key] == val then
      return v
    end
  end
end

local function open_lua_error(bufnr, path, line, orig_map)
  -- vim.api.nvim_set_current_win(currwin)
  -- vim.api.nvim_win_close(notify_win, true)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local run_cmd = 'edit'
  if bufname ~= path then
    run_cmd = 'split'
  end

  if type(orig_map) == 'table' and type(orig_map.lhs) == 'string' then
    pcall(vim.api.nvim_del_keymap, { 'n', 'gF' })
    pcall(vim.api.nvim_set_keymap, {
      orig_map.mode,
      orig_map.lhs,
      orig_map.rhs,
      {
        nowait = orig_map.nowait,
        noremap = orig_map.noremap,
        silent = 1,
      },
    })
  end
  vim.cmd(run_cmd .. ' +' .. line .. ' ' .. path)
end

local on_open = function(win)
  vim.api.nvim_win_set_option(win, 'winblend', 10)
  vim.api.nvim_win_set_option(win, 'wrap', false)
  vim.api.nvim_win_set_config(win, { zindex = 100 })
  local bufnr = vim.api.nvim_win_get_buf(win)
  local file_ok, notify_file = pcall(vim.api.nvim_buf_get_var, bufnr, 'notify_file')
  local _, notify_line = pcall(vim.api.nvim_buf_get_var, bufnr, 'notify_line')
  if file_ok and #notify_file > 0 then
    local orig_map = find(vim.api.nvim_get_keymap('n'), 'lhs', 'gF')
    logger:trace('file assigned (' .. notify_file .. ':' .. notify_line .. ')')
    vim.api.nvim_set_keymap('n', 'gF', '', {
      callback = function()
        logger:debug('going to error (' .. notify_file .. ':' .. notify_line .. ')')
        open_lua_error(bufnr, notify_file, notify_line, orig_map)
      end,
    })
  end
end

return on_open
