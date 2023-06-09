-- local get_splits = function(directions, ignore_quickfix)
--   -- let window_count = winnr('$')
--   -- let prev_window = winnr('#')
--   local splits = {}
--   local curwin = vim.fn.winnr()
--   for _, dir in ipairs(directions) do
--     local testwin = vim.fn.winnr(dir)
--     local testwinid = vim.fn.win_getid(testwin)
--     if curwin ~= testwinid and not vim.tbl_contains(splits, testwinid) then
--       local bufid = vim.api.nvim_win_get_buf(testwinid)
--       local ft = vim.api.nvim_buf_get_option(bufid, 'filetype')
--       if not ignore_quickfix or ft ~= 'qf' then
--         table.insert(splits, testwinid)
--       end
--     end
--   end
--   return splits
-- end
--
-- local close_multi = function()
--   local tabs = vim.api.nvim_list_tabpages() or {}
--   local splits = get_splits({ 'l', 'h', 'j', 'k' }, true) or {}
--   local curr_win = vim.api.nvim_get_current_win()
--   local is_popup = vim.tbl_get(vim.api.nvim_win_get_config(curr_win), 'relative') ~= ''
--   if #tabs > 1 then
--     vim.cmd('tabclose!')
--   elseif is_popup then
--     vim.api.nvim_win_close(curr_win, false)
--   elseif #splits > 1 then
--     vim.api.nvim_win_close(curr_win, false)
--   else
--     vim.cmd('BufferDelete')
--   end
-- end
--
-- print('hello')
-- -- close_multi()

local function get_loaded_buffers(options)
  local buffers = {}
  local len = 0
  local vim_fn = vim.fn
  local buflisted = vim_fn.buflisted

  for buffer = 1, vim_fn.bufnr('$') do
    if buflisted(buffer) == 1 then
      len = len + 1
      buffers[len] = buffer
    end
  end

  return buffers
end

vim.dbglog(get_loaded_buffers())
