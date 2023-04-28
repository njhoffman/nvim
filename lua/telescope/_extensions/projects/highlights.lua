local setup = function()
  vim.api.nvim_set_hl(0, 'TelescopeProjectPath', { default = true, link = 'Comment' })
  vim.api.nvim_set_hl(0, 'TelescopeProjectName', { default = true, link = 'TelescopeNormal' })
  vim.api.nvim_set_hl(0, 'TelescopeProjectGroupRecent', { fg = '#007799', italic = true })
  -- vim.api.nvim_set_hl(0, 'TelescopeProjectGroupRecent', { link = 'Constant', italic = true })
  vim.api.nvim_set_hl(0, 'TelescopeProjectGroup1', { fg = '#00aaaa' })
  vim.api.nvim_set_hl(0, 'TelescopeProjectGroup2', { fg = '#0066aa' })
  vim.api.nvim_set_hl(0, 'TelescopeProjectGroup3', { fg = '#5555aa' })
end
return {
  setup = setup,
}
