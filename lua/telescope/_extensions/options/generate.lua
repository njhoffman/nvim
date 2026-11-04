local get_options = function(scope, conf_opts)
  local res = {}
  scope = scope or 'all'
  for _, v in pairs(vim.api.nvim_get_all_options_info()) do
    if v.was_set then
      if scope == 'all' or scope == v.scope then
        if scope == 'buf' or scope == 'win' then
          v.value = vim.api.nvim_get_option_value(v.name, { scope = 'local' })
        else
          v.value = vim.api.nvim_get_option_value(v.name, { scope = 'global' })
        end
        table.insert(res, v)
      end
    end
  end
  table.sort(res, function(left, right)
    return left.scope .. left.name < right.scope .. right.name
  end)
  return res
end

return {
  get_options = get_options,
}
