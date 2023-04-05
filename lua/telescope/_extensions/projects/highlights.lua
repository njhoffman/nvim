local setup = function()
  vim.api.nvim_set_hl(0, "TelescopeProjectPath", { default = true, link = "Comment" })
  vim.api.nvim_set_hl(0, "TelescopeProjectName", { default = true, link = "@keyword" })
  vim.api.nvim_set_hl(0, "TelescopeProjectGroupRecent", {
    default = true,
    fg = "#0088aa",
    -- italic = true,
  })
  vim.api.nvim_set_hl(0, "TelescopeProjectGroup1", { default = true, fg = "#00aaaa" })
  vim.api.nvim_set_hl(0, "TelescopeProjectGroup2", { default = true, fg = "#0066aa" })
  vim.api.nvim_set_hl(0, "TelescopeProjectGroup3", { default = true, fg = "#5555aa" })
end
return { setup = setup }
