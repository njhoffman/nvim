-- /home/nicholas/.local/share/nvenv/versions/nightly/share/nvim/runtime/lua/vim/lsp/handlers.lua

local M = {}
local util = require("vim.lsp.util")
M.hover_handler = function(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  if not (result and result.contents) then
    -- vim.notify("No information available")
    return
  end
  local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then
    vim.notify("No information available")
    return
  end
  return util.open_floating_preview(markdown_lines, "markdown", config)
end

return M
