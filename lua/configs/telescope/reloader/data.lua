local get_reload_list = function(opts)
  local get_desc = function(req)
    return type(req) == "function" and "function"
      or type(req) == "table" and tostring(#vim.tbl_keys(req)) .. " keys"
      or tostring(req)
  end

  local package_loaded = vim.tbl_keys(package.loaded)
  local reload_list = {}

  local column_len = 0
  for index, module_name in pairs(package_loaded) do
    local req = require(module_name)
    local item = {
      type = type(req),
      index = index,
      filepath = _G.Find_Required_Path(module_name),
      packagepath = package.searchpath(module_name, package.path) or "",
      desc = get_desc(req),
      name = module_name,
    }
    column_len = math.max(column_len, #module_name)
    table.insert(reload_list, item)
  end
  return vim.fn.reverse(vim.fn.sort(reload_list, function(a, b)
    return a.name < b.name
  end)),
    column_len
end

return get_reload_list
