local M = {}

M.lsp_format_async = function()
  if type(vim.lsp.buf.format) == 'function' then
    vim.lsp.buf.format({ async = true })
  elseif type(vim.lsp.buf.formatting) == 'function' then
    vim.lsp.buf.formatting()
  end
end

M.lsp_format = function()
  if type(vim.lsp.buf.format) == 'function' then
    vim.lsp.buf.format()
  elseif type(vim.lsp.buf.formatting_sync) == 'function' then
    vim.lsp.buf.formatting_sync()
  end
end

M.get_repo = function(bufnr)
  bufnr = bufnr or vim.fn.bufnr()
  local ok, gitsigns = pcall(vim.api.nvim_buf_get_var, bufnr, 'gitsigns_status_dict')
  if ok == true then
    -- vim.dbglog("get_repo", gitsigns)
    return {
      worktree = gitsigns.root,
      gitdir = gitsigns.gitdir,
    }
  else
    vim.dbglog('get_repo failed', bufnr, gitsigns)
    return {}
  end
end

M.split_string = function(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

M.get_widths = function(part_lines)
  local widths = {}
  for _, line in ipairs(part_lines) do
    for n, part in ipairs(line) do
      if type(widths[n]) == 'nil' then
        widths[n] = 0
      end
      if type(part) == 'string' and #part > widths[n] then
        widths[n] = #part
      end
    end
  end
  return widths
end

M.escape_chars = function(x)
  return (x:gsub('%%', '%%%%'):gsub('^%^', '%%^'):gsub('%$$', '%%$'):gsub('%(', '%%('):gsub('%)', '%%)'):gsub('%.', '%%.'):gsub('%[', '%%['):gsub('%]', '%%]'):gsub('%*', '%%*'):gsub('%+', '%%+'):gsub('%-', '%%-'):gsub('%?', '%%?'))
end

return M
