local M = {}

local namespace = vim.api.nvim_create_namespace('nvim-notify')

function M.namespace()
  return namespace
end

function M.body_hl(bufnr, line, col, hl_group, end_line, end_col)
  local opts = {
    hl_group = hl_group,
    end_line = end_line,
    priority = 50,
  }
  if type(end_col) ~= 'nil' then
    opts.end_col = end_col
  end
  vim.api.nvim_buf_set_extmark(bufnr, namespace, line, col, opts)
end

function M.content_hl(bufnr, start_line, start_col, highlights, notif)
  for _, hl in ipairs(notif.body_highlights) do
    local col = start_col + hl[3]
    local line = start_line + hl[2]
    local opts = {
      hl_group = highlights.content[hl[1]],
      end_col = hl[4],
      end_line = line,
      priority = 60,
    }
    vim.dbglog('setting:', line, col, opts)
    vim.api.nvim_buf_set_extmark(bufnr, namespace, line, col, opts)
  end
end
return M
