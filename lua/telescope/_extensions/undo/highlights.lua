-- TelescopeTitle
-- stylua: ignore
local setup_highlights = function()
  local pfx = 'TelescopeUndo'
  vim.api.nvim_set_hl(0, pfx .. 'ID',            { default = true, link = 'Comment' })
  vim.api.nvim_set_hl(0, pfx .. 'Node',          { default = true, link = 'TelescopeNormal' })
  vim.api.nvim_set_hl(0, pfx .. 'NodeSaved',     { default = true, link = 'TelescopeNormal' })
  vim.api.nvim_set_hl(0, pfx .. 'NodeCurrent',   { default = true, link = 'TelescopeNormal' })
  vim.api.nvim_set_hl(0, pfx .. 'NodeConnector', { default = true, link = 'TelescopeNormal' })
  vim.api.nvim_set_hl(0, pfx .. 'Stat',          { fg = '#007799', italic = true })
  vim.api.nvim_set_hl(0, pfx .. 'StatAdd',       { fg = '#007799', italic = true })
  vim.api.nvim_set_hl(0, pfx .. 'StatDel',       { fg = '#007799', italic = true })
  vim.api.nvim_set_hl(0, pfx .. 'Time',          { fg = '#007799', italic = true })
  vim.api.nvim_set_hl(0, pfx .. 'Prefix',        { fg = '#007799', italic = true })
  -- vim.api.nvim_set_hl(0, 'TelescopeProjectGroupRecent', { link = 'Constant', italic = true })
end
-- comment #4a6a7b

-- TelescopeUndoID
-- TelescopeUndoNode
-- TelescopeUndoNodeSaved
-- TelescopeUndoNodeCurrent
-- TelescopeUndoNodeConnector
-- TelescopeUndoStat
-- TelescopeUndoStatAdd
-- TelescopeUndoStatDel
-- TelescopeUndoTime
-- TelescopeUndoPrefix

return { setup_highlights = setup_highlights }
