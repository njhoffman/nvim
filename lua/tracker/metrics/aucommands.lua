local provider = function(_)
  return {
    name = "aucommands",
    id_fields = { "pattern", "event" },
    desc_fields = { "group_name", "pattern", "event" },
    get_data = function()
      return vim.api.nvim_get_autocmds({})
    end,
    -- parse_data = function() end
  }
end

return provider
