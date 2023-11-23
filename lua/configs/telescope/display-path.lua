local init = function(format)
  format = format or 'simple'
  if format == 'simple' then
    local path_display = function(_, path) -- tail, hidden, absolute, shorten
      path = string.gsub(path, '^./', '')
      path = string.gsub(path, os.getenv('HOME') or '', '~')
      return ' ' .. path
    end
    return path_display
  elseif format == 'file_first' then
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'TelescopeResults',
      callback = function()
        vim.fn.matchadd('TelescopeParent', '\t\t.*$')
        vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Comment' })
      end,
    })

    ---Requires the autocmd above
    ---@param _ table
    ---@param path string
    ---@return string
    local path_display = function(_, path)
      path = path:gsub('/$', '') -- trailing slash from directories breaks fs.basename
      local tail = vim.fs.basename(path)
      local parent = vim.fs.dirname(path)
      if parent == '.' then
        return tail
      end
      local parentDisplay = #parent > 20 and vim.fs.basename(parent) or parent
      return string.format('%s\t\t%s', tail, parentDisplay) -- parent colored via autocmd above
    end
    return path_display
  else
    -- tail, hidden, absolute, shorten
    return format
  end
end

return { init = init }
