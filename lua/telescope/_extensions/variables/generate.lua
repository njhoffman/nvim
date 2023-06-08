local get_buffer_variables = function()
  vim.cmd([[
    let temp_reg = @" | redir @" | silent! execute ":let b:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_buffer=split(output, "\n")
  ]])
  return vim.api.nvim_eval('w:output_buffer')
end

local get_window_variables = function()
  vim.cmd([[
    let temp_reg = @" | redir @" | silent! execute ":let w:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_window=split(output, "\n")
  ]])
  return vim.api.nvim_eval('w:output_window')
end

local get_global_variables = function()
  vim.cmd([[
    let temp_reg = @" | redir @" | silent! execute ":let g:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_global=split(output, "\n")
  ]])
  return vim.api.nvim_eval('w:output_global')
end

local get_predef_variables = function()
  vim.cmd([[
    let temp_reg = @" | redir @" | silent! execute ":let v:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_predef=split(output, "\n")
  ]])
  return vim.api.nvim_eval('w:output_predef')
end

local parse_result = function(res, lines, scope)
  for _, line in pairs(lines) do
    local key = vim.fn.split(vim.fn.split(line, ' ')[1], ':')[2]
    local value = nil
    if key == nil then
      key = vim.fn.split(line, ' ')[1]
    end
    if scope == 'buffer' then
      value = vim.b[key]
    elseif scope == 'window' then
      value = vim.w[key]
    elseif scope == 'predef' then
      value = vim.v[key]
    elseif scope == 'global' then
      value = vim.g[key]
    end
    if value ~= nil then
      table.insert(res, { scope = scope, key = key, value = value })
    end
  end
end

local get_variables = function(var_type)
  local res = {}
  if var_type == nil or var_type == 'buffer' then
    parse_result(res, get_buffer_variables(), 'buffer')
    vim.w.output_buffer = nil
  end

  if var_type == nil or var_type == 'window' then
    parse_result(res, get_window_variables(), 'window')
    vim.w.output_window = nil
  end

  if var_type == nil or var_type == 'predef' then
    parse_result(res, get_predef_variables(), 'predef')
    vim.w.output_predef = nil
  end

  if var_type == nil or var_type == 'global' then
    parse_result(res, get_global_variables(), 'global')
    vim.w.output_global = nil
  end

  -- t:, l:, s:
  local scope_sort = { buffer = 0, window = 1, predef = 2, global = 3 }
  table.sort(res, function(left, right)
    return scope_sort[left.scope] .. left.key < scope_sort[right.scope] .. right.key
  end)
  return res
end

return {
  get_variables = get_variables,
}
