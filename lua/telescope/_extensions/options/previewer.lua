local previewers = require("telescope.previewers")
local utils = require('telescope.utils')
local defaulter = utils.make_default_callable

local M = {}

M.previewer = defaulter(function(_)
  return previewers.new_buffer_previewer({
    title = "Option Details",
    define_preview = function(self, entry, _)
      -- entry.display(), entry.entry.value: key, scope, value
      local lines = vim.fn.split(vim.inspect(entry.value.value), '\n')
      table.insert(lines, 1, ' ')
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "lua")
      vim.api.nvim_win_set_option(self.state.winid, "wrap", true)
    end
  })
end, {})

return M
