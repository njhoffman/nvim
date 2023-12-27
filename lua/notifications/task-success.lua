-- local get_opts = function(output, cmd, time)
--   local on_open = function(notify_winnr)
--     local buf = vim.api.nvim_win_get_buf(notify_winnr)
--     -- require('baleia'):baleia:attach(buf)
--     vim.api.nvim_buf_set_option(buf, 'modifiable', true)
--     vim.api.nvim_buf_set_option(buf, 'filetype', 'notify')
--   end
--
--   return {
--     icon = '',
--     title = { cmd, time .. ' ms' },
--     on_open = on_open,
--     -- on_close = on_close,
--     filetype = 'notify',
--     hide_from_history = false,
--     render = 'default',
--     -- anchor = "TC",
--   }
-- end

local notify_success = function(output, cmd, time)
  if type(output) ~= 'table' or #output == 0 then
    output = { '[OK]' }
  end
  -- local opts = get_opts(output, cmd, time)
  local opts = {}
  require('notify').notify(output, 'run', opts)
end

return {
  -- test_render = test_success,
  notify = notify_success,
}
