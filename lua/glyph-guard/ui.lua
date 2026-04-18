local M = {}
local ns = vim.api.nvim_create_namespace("glyph-guard")

function M.clear(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

function M.show(findings, buf, cfg)
  local hl = cfg.ui.highlight

  for _, f in ipairs(findings) do
    vim.api.nvim_buf_set_extmark(buf, ns, f.lnum - 1, f.col, {
      end_col = f.col + #f.char,
      hl_group = hl,
    })
  end
end

return M
