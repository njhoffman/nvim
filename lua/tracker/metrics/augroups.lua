local provider = function(_)
  return {
    name = "augroups",
    id_fields = "group_name",
    get_data = function()
      return vim.api.nvim_get_autocmds({})
    end,
    -- parse_data = function() end
  }
end

return provider
