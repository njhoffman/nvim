local ignore_keys = function(keys)
  local ignore_map = {}
  for _, key in ipairs(keys) do
    ignore_map[key] = function(prompt_bufnr)
      -- logger:info('2 ignoring ' .. key .. ' for ' .. prompt_bufnr)
    end
  end
  return ignore_map
end

vim.dbglog(vim.tbl_extend(
  'force',
  {
    ['<C-Space>'] = 'keymap 1',
    ['C-p'] = 'keymap 2',
  },
  ignore_keys({
    '<C-Space>',
    '<M-q>',
  })
))
