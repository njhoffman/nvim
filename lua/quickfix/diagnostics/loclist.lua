local utils = require('quickfix.diagnostics.utils')

local is_open = function()
  return vim.fn.getloclist(0, { winid = 0 }).winid ~= 0
end

local get_as_qfitems = function()
  local all_diags = vim.diagnostic.get(0)
end

local diagnostics_hook = function()
  -- if vim.fn.win_gettype(0) == 'loclist' then
  --   if M.debug then
  --     print('loclist is focused, not updating')
  --   end
  --   return
  -- end
  -- FIXME: check foreign loclist
  vim.diagnostic.setloclist({
    open = false,
  })
end

local open_buffer_diagnostics = function()
  diagnostics_hook()
  vim.api.nvim_command([[lw]])
end

return {
  diagnostics_hook = diagnostics_hook,
  open_buffer_diagnostics = open_buffer_diagnostics,
}
