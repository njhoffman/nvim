local setup_highlights = function()
  vim.api.nvim_set_hl(0, "TelescopeWhichKeyNormal", { default = true, link = "TelescopePrompt" })
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyBorder",
    { default = true, link = "TelescopePromptBorder" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyMode",
    { default = true, link = "TelescopeResultsConstant" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyBind",
    { default = true, link = "TelescopeResultsVariable" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyName",
    { default = true, link = "TelescopeResultsFunction" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyModeCustom",
    { default = true, link = "TelescopeWhichKeyMode" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyBindCustom",
    { default = true, link = "TelescopeWhichKeyBind" }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeWhichKeyNameCustom",
    { default = true, link = "TelescopeWhichKeyName" }
  )
end

return { setup_highlights = setup_highlights }
