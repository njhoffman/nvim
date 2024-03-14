local M = {}

local neoscroll = require('neoscroll.neoscroll')

M.setup = function(custom_opts)
  -- Highlight group to hide the cursor
  local augroup_id = vim.api.nvim_create_augroup('neoscroll', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = augroup_id,
    pattern = '*',
    command = 'highlight NeoscrollHiddenCursor gui=reverse blend=100',
  })
  return neoscroll.init(custom_opts or {})
end

M = vim.tbl_deep_extend('force', {}, M, neoscroll)
return M
