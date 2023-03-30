local state = {}

local print_stats = function(name, plugins)
  local line = "(" .. #vim.tbl_keys(state.start) .. ":" .. #vim.tbl_keys(state.lazy)
  line = line .. ":" .. #vim.tbl_keys(state.configs) .. ") +" .. #plugins .. " " .. name
  if #state.errors > 0 then
    line = line .. ", errors: " .. #vim.tbl_keys(state.errors)
  end
  -- vim.dbglog(line)
end

local get_stray_configs = function()
  local scan = require("plenary.scandir")
  local basepath = vim.fn.stdpath("config") .. "/lua/plugs/config"
  local files = scan.scan_dir(basepath, {
    depth = 1,
    search_pattern = ".lua$",
  })
  local strays = {}
  for i, file in ipairs(files) do
    local name_parts = vim.split(file, "/")
    local config_name = string.gsub(name_parts[#name_parts], ".lua$", "")
    if not state.configs[config_name] then
      table.insert(strays, config_name)
    end
  end
  vim.dbglog(strays, state.configs)
  return strays
end

return {
  state = state,
}
