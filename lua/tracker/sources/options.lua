local base_source = require('tracker.sources._base')
local all_scopes = { g = 'global', b = 'buf', w = 'win' }

local get_scoped_options = function(scope, all_local)
  -- [357] = {
  --   allows_duplicates = true, commalist = false, default = true, flaglist = false,
  --  _local = false, last_set_chan = -9.2233720368548e+18, last_set_linenr = 0,
  --  _set_sid = -8, name = "wrap", scope = "win", shortname = "", type = "boolean", was_set = true
  -- }
  local scope_name = all_scopes[scope]
  local results = {}
  for _, v in pairs(vim.api.nvim_get_all_options_info()) do
    if v.was_set == true then
      if scope_name == 'global' and scope_name == v.scope then
        v.value = vim.api.nvim_get_option_value(v.name, { scope = 'global' })
        table.insert(results, v)
      elseif scope_name == 'win' and scope_name == v.scope then
        if not all_local then
          v.value = vim.api.nvim_get_option_value(v.name, { scope = 'local' })
          table.insert(results, v)
        else
          local windows = vim.api.nvim_list_wins()
          for _, winnr in ipairs(windows) do
            v.value = vim.api.nvim_get_option_value(v.name, { win = winnr })
            v.winnr = winnr
            table.insert(results, v)
          end
        end
      elseif scope_name == 'buf' and scope_name == v.scope then
        if not all_local then
          v.value = vim.api.nvim_get_option_value(v.name, { scope = 'local' })
          table.insert(results, v)
        else
          local buffers = vim.api.nvim_list_bufs()
          for _, bufnr in ipairs(buffers) do
            v.value = vim.api.nvim_get_option_value(v.name, { buf = bufnr })
            v.bufnr = bufnr
            table.insert(results, v)
          end
        end
      end
    end
  end
  table.sort(results, function(left, right)
    return left.scope .. left.name < right.scope .. right.name
  end)
  return results
end

local get_options = function(scopes)
  return function(self)
    local results = {}
    if not vim.tbl_islist(scopes) then
      scopes = vim.tbl_keys(scopes)
    end
    for _, scope in ipairs(scopes) do
      local option_items = get_scoped_options(scope)
      self:_build_results(results, option_items)
    end
    return results.items, results.columns
  end
end

--
local init_source = function(scopes)
  -- 漣   煉
  scopes = type(scopes) == 'table' and scopes or type(scopes) == 'string' and { scopes } or vim.tbl_keys(all_scopes)
  return vim.tbl_extend('force', base_source, {
    name = 'options_' .. vim.fn.join(scopes, ''),
    icon = '',
    fields = { 'scope', 'winnr', 'bufnr', 'name', 'value' },
    get = get_options(scopes),
    -- output    = output_options,
  })
end

return init_source
