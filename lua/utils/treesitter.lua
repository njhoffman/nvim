local M = {}

---Convert TS 0-indexed range to Vim 1-indexed range.
---@param range integer[]
---@param buf integer|nil
---@return integer, integer, integer, integer
function M.get_vim_range(range, buf)
  local srow, scol, erow, ecol = unpack(range)
  srow = srow + 1
  scol = scol + 1
  erow = erow + 1

  if ecol == 0 then
    erow = erow - 1
    if not buf or buf == 0 then
      ecol = vim.fn.col({ erow, "$" }) - 1
    else
      ecol = #vim.api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1]
    end
    ecol = math.max(ecol, 1)
  end
  return srow, scol, erow, ecol
end

function M.highlight_range(range, buf, hl_namespace, hl_group)
  local start_row, start_col, end_row, end_col = unpack(range)
  ---@diagnostic disable-next-line: missing-parameter
  vim.highlight.range(buf, hl_namespace, hl_group, { start_row, start_col }, { end_row, end_col })
end

function M.highlight_node(node, buf, hl_namespace, hl_group)
  if not node then
    return
  end
  M.highlight_range({ node:range() }, buf, hl_namespace, hl_group)
end

return M
