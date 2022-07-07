local get_variables = function()
  local res = {}
  for _, v in pairs(vim.api.nvim_get_all_options_info()) do
    -- allows_duplicates = true,
    -- commalist = false,
    -- default = true,
    -- flaglist = false,
    -- global_local = false,
    -- last_set_chan = 0,
    -- last_set_linenr = 0,
    -- last_set_sid = 0,
    -- name = "autoindent",
    -- scope = "buf",
    -- shortname = "ai",
    -- type = "boolean",
    -- was_set = true
    table.insert(res, v)
  end
  table.sort(res, function(left, right)
    return left.scope .. left.name < right.scope .. right.name
  end)
  return res
end

return {
  get_variables = get_variables
}
