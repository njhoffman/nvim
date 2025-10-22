local base_source = require("tracker.sources._base")

local all_scopes = {
  g = "global",
  s = "script",
  b = "buffer",
  w = "window",
  t = "terminal",
  v = "perdef",
  l = "language",
}

local get_scoped_variables = function(scope)
  local scope_cmd = "let " .. scope .. ":"

  vim.cmd([[ let temp_reg = @" | redir @" ]])
  vim.cmd('silent execute ":' .. scope_cmd .. '"')
  vim.cmd([[
    redir END | let out = copy(@")  | let @" = temp_reg
    let w:output=split(out, "\n")
  ]])
  local variables = vim.api.nvim_eval("w:output")
  local ignored_vars = { "output" }
  local parsed_vars = {}
  for _, line in ipairs(variables) do
    local name = vim.fn.split(line, " \\+")[1]
    local value = vim.fn.join(vim.fn.slice(vim.fn.split(line, " \\+"), 2), " ")
    if not vim.tbl_contains(ignored_vars, name) then
      table.insert(
        parsed_vars,
        { name = vim.fn.trim(name), value = vim.fn.trim(value), scope = scope }
      )
    end
  end
  return parsed_vars
end

local get_variables = function(scopes)
  return function(self)
    if not vim.islist(scopes) then
      scopes = vim.tbl_keys(scopes)
    end
    local results = {}
    for _, scope in ipairs(scopes) do
      local build_opts = { extra = { scope = scope } }
      local varmaps = get_scoped_variables(scope)
      self:_build_results(results, varmaps, build_opts)
    end
    return results.items, results.columns
  end
end

local init_provider = function(scopes)
  scopes = type(scopes) == "table" and scopes
    or type(scopes) == "string" and { scopes }
    or vim.tbl_keys(all_scopes)
  return vim.tbl_extend("force", base_source, {
    name = "variables_" .. vim.fn.join(scopes, ""),
    icon = "",
    fields = { "name", "value", "scope" },
    get = get_variables(scopes),
    -- output    = output_variables,
  })
end

return init_provider
