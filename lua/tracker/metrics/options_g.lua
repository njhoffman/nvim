local get_options = function()
  local res = {}
  local scope = "all" -- all, win, global, buf

  for _, v in pairs(vim.api.nvim_get_all_options_info()) do
    if scope == "all" or scope == v.scope then
      table.insert(res, v)
    end
  end

  table.sort(res, function(left, right)
    return left.scope .. left.name < right.scope .. right.name
  end)
  return res
end

local provider = function(_)
  return {
    name = "options",
    id_fields = { "scope", "name" },
    get_data = get_options,
  }
end

return provider
