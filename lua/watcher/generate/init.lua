-- local sort_pairs = function(t, order)
--   local keys = {}
--   for k in pairs(t) do keys[#keys + 1] = k end
--   if order then
--     table.sort(keys, function(a, b) return order(t, a, b) end)
--   else
--     table.sort(keys)
--   end
--   local i = 0
--   return function()
--     i = i + 1
--     if keys[i] then
--       return keys[i], t[keys[i]]
--     end
--   end
-- end

local get_changelist = function()
  local lines = {}
  local changes = vim.api.nvim_command_output("changes")
  for change in changes:gmatch("[^\r\n]+") do
    table.insert(lines, change)
  end
  table.remove(lines, 1)
  return lines
end

local get_envlist = function()
  return vim.fn.environ()
end

local get_options = function(scope)
  local res = {}
  scope = scope or 'all'
  for _, v in pairs(vim.api.nvim_get_all_options_info()) do
    if scope == 'all' or scope == v.scope then
      table.insert(res, v)
    end
  end
  table.sort(res, function(left, right)
    return left.scope .. left.name < right.scope .. right.name
  end)
  return res
end

local get_variables = function(scope)
  if scope == 'buffer' then
    vim.cmd [[
      let temp_reg = @" | redir @" | silent! execute ":let b:" | redir END
      let output = copy(@") | let @" = temp_reg
      let w:output_variables=split(output, "\n")
    ]]
  elseif scope == 'window' then
    vim.cmd [[
      let temp_reg = @" | redir @" | silent! execute ":let w:" | redir END
      let output = copy(@") | let @" = temp_reg
      let w:output_variables=split(output, "\n")
    ]]
  else
    vim.cmd [[
      let temp_reg = @" | redir @" | silent! execute ":let g:" | redir END
      let output = copy(@") | let @" = temp_reg
      let w:output_variables=split(output, "\n")
      ]]
  end
  return vim.api.nvim_eval("w:output_variables")
end


return {
  envlist          = get_envlist,
  changelist       = get_changelist,
  options_buf      = get_options('buffer'),
  options_win      = get_options('window'),
  options_global   = get_options('global'),
  variables_buf    = get_variables('buffer'),
  variables_win    = get_variables('window'),
  variables_global = get_variables('global'),
  -- timers           = get_timers,
  -- functions        = get_functions,
  -- messages         = get_messages,
  -- highlights       = get_highlights,
  -- commands         = get_commands,
  -- history          = get_history,
  -- autogroups       = get_autogroups,
  -- autocommands     = get_autocommands,
  -- syntax_items     = get_syntax_items,
  -- keymaps_buf      = get_keymaps('buffer'),
  -- keymaps_win      = get_keymaps('window'),
  -- keymaps_global   = get_keymaps('global'),
}
