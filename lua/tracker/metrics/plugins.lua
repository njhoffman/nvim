local provider = function(_)
  return {
    name = "plugins",
    id_fields = { "name" },
    get_data = function()
      local plugins = vim.tbl_filter(function(plugin)
        return plugin[1]._.loaded
      end, require("lazy.core.config").spec.plugins)
      return plugins
    end,
  }
end

return provider
