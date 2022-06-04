-- /home/nicholas/.local/share/nvenv/versions/nightly/share/nvim/runtime/lua/vim/lsp/handlers.lua

local M = {}
local util = require("vim.lsp.util")

vim.lsp.with(vim.lsp.handlers.hover, {
  max_width = 80,
  border = 'rounded'
})

M.hover_handler = function(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  config.max_width = config.max_width or 80


  if (result.contents ~= nil) then
    local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
      vim.notify("No information available", "debug")
      return
    end
    return util.open_floating_preview(markdown_lines, "markdown", config)
  end
end

return M
