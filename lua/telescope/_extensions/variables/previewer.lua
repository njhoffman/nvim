local previewers = require('telescope.previewers')
local utils = require('telescope.utils')
local defaulter = utils.make_default_callable

local M = {}

M.previewer = defaulter(function(_)
  return previewers.new_buffer_previewer({
    title = 'Variable Details',
    define_preview = function(self, entry, _)
      -- entry.display(), entry.entry.value: key, scope, value
      local lines = vim.fn.split(vim.inspect(entry.value.value), '\n')
      table.insert(lines, 1, ' ')
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      vim.api.nvim_set_option_value('filetype', 'lua', { buf = self.state.bufnr })
      vim.api.nvim_set_option_value('wrap', true, { win = self.state.winid })
    end,
  })
end, {})

return M
