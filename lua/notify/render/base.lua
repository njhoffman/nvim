local M = {}

local namespace = vim.api.nvim_create_namespace('nvim-notify')

function M.namespace()
  return namespace
end

function M.body_hl(bufnr, highlights, notif, start_line, start_col, end_line, end_col)
  local body_hl = notif.body_hl_group and notif.body_hl_group or 'body'
  local opts = {
    hl_group = highlights[body_hl] or highlights.body,
    end_line = end_line,
    priority = 50,
  }
  if type(end_col) ~= 'nil' then
    opts.end_col = end_col
  end
  local ok = nil
  if not highlights.repeat_count then
    -- vim.api.nvim_buf_set_extmark(bufnr, namespace, start_line, start_col, opts)
    ok, _ = pcall(vim.api.nvim_buf_set_extmark, bufnr, namespace, start_line, start_col, opts)
  else
    local repeat_label = '#' .. tostring(notif.repeat_count)
    opts.end_col = opts.end_col - #repeat_label - 1
    ok, _ = pcall(vim.api.nvim_buf_set_extmark, bufnr, namespace, start_line, start_col, opts)
    -- vim.api.nvim_buf_set_extmark(bufnr, namespace, start_line, start_col, opts)
    opts.hl_group = highlights.repeat_count
    start_col = opts.end_col + 1
    opts.end_col = opts.end_col + #repeat_label + 1
    ok, _ = pcall(vim.api.nvim_buf_set_extmark, bufnr, namespace, start_line, start_col, opts)
    -- vim.api.nvim_buf_set_extmark(bufnr, namespace, start_line, start_col, opts)
  end
  if not ok then
    vim.notify('failed to set extmark: ' .. vim.inspect(ok), vim.log.levels.WARN)
  end
end

function M.content_hl(bufnr, highlights, notif, start_line, start_col)
  for _, hl in ipairs(notif.body_highlights) do
    local col = start_col + hl[3]
    local line = start_line + hl[2]
    local opts = {
      hl_group = highlights.content[hl[1]],
      end_col = hl[4],
      end_line = line,
      priority = 60,
    }
    vim.api.nvim_buf_set_extmark(bufnr, namespace, line, col, opts)
  end
end
return M
