local namespace = vim.api.nvim_create_namespace('nvim-notify')
local namespace = function()
  return namespace
end

local extmark_fail = function(err)
  vim.notify('failed to set extmark: ' .. vim.inspect(err), vim.log.levels.WARN)
  return false
end

local generic_hls = function(bufnr, highlights, notif, start_line, start_col, end_line)
  local body_hl = notif.body_hl_group and notif.body_hl_group or 'body'
  local opts = {
    hl_group = highlights[body_hl] or highlights.body,
    end_line = end_line,
    priority = 50,
  }
  local ok, err = nil, nil
  if not highlights.repeat_count then
    -- vim.api.nvim_buf_set_extmark(bufnr, namespace, start_line, start_col, opts)
    ok, err = pcall(vim.api.nvim_buf_set_extmark, bufnr, namespace(), start_line, start_col, opts)
  else
    local repeat_label = '#' .. tostring(notif.repeat_count)
    opts.end_col = opts.end_col - #repeat_label - 1
    ok, err = pcall(vim.api.nvim_buf_set_extmark, bufnr, namespace(), start_line, start_col, opts)
    if not ok then
      return extmark_fail(err)
    end
    -- vim.api.nvim_buf_set_extmark(bufnr, namespace, start_line, start_col, opts)
    opts.hl_group = highlights.repeat_count
    start_col = opts.end_col + 1
    -- opts.end_col = opts.end_col + #repeat_label + 1
    opts.end_col = -1
    ok, err = pcall(vim.api.nvim_buf_set_extmark, bufnr, namespace(), start_line, start_col, opts)
    -- vim.api.nvim_buf_set_extmark(bufnr, namespace, start_line, start_col, opts)
  end
  if not ok then
    extmark_fail(err)
  end
end

local embedded_hls = function(bufnr, highlights, notif, start_line, start_col)
  for _, hl in ipairs(notif.highlights.body) do
    local col = start_col + hl[3]
    local line = start_line + hl[2]
    local opts = {
      hl_group = highlights.content[hl[1]],
      end_col = hl[4],
      end_line = line,
      priority = 60,
    }
    vim.api.nvim_buf_set_extmark(bufnr, namespace(), line, col, opts)
  end
end

local content_hl = function(bufnr, highlights, notif, start_line, start_col, end_line)
  if vim.tbl_get(notif, 'highlights', 'body') then
    -- predefined body highlights
    embedded_hls(bufnr, highlights, notif, start_line, start_col)
  else
    -- generic full body highlighting
    generic_hls(bufnr, highlights, notif, start_line, start_col, end_line)
  end
end

return { content_hl = content_hl, namespace = namespace }
