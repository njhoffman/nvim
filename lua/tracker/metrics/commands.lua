local provider = function(_)
  return {
    name = "commands",
    id_fields = { "name", "definition" },
    get_data = function()
      return vim.api.nvim_get_commands({})
    end,
  }
end

return provider
