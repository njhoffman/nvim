local get_variables = function()
  local lines = {
    buffer = {},
    window = {},
    global = {},
    predef = {},
  }

  vim.cmd [[
    let temp_reg = @" | redir @" | silent! execute ":let b:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_buffer=split(output, "\n")

    let temp_reg = @" | redir @" | silent! execute ":let w:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_window=split(output, "\n")

    let temp_reg = @" | redir @" | silent! execute ":let g:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_global=split(output, "\n")

    let temp_reg = @" | redir @" | silent! execute ":let v:" | redir END
    let output = copy(@") | let @" = temp_reg
    let w:output_predef=split(output, "\n")
  ]]

  lines.buffer = vim.api.nvim_eval("w:output_buffer")
  lines.window = vim.api.nvim_eval("w:output_window")
  lines.global = vim.api.nvim_eval("w:output_global")
  lines.predef = vim.api.nvim_eval("w:output_predef")

  local res = {}
  for _, line in pairs(lines.buffer) do
    local key = string.split(string.split(line, ' ')[1], ':')[2]
    local value = vim.b[key]
    table.insert(res, { scope = 'buffer', key = key, value = value })
  end

  -- for _, line in pairs(lines.window) do
  --   local key = string.split(string.split(line, ' ')[1], ':')[2]
  --   local value = vim.w[key]
  --   table.insert(res, { scope = 'window', key = key, value = value })
  -- end

  -- for _, line in pairs(lines.global) do
  --   local key = string.split(line, ' ')[1]
  --   local value = vim.g[key]
  --   table.insert(res, { scope = 'global', key = key, value = value })
  -- end

  -- for _, line in pairs(lines.predef) do
  --   local key = string.split(string.split(line, ' ')[1], ':')[2]
  --   local value = vim.v[key]
  --   table.insert(res, { scope = 'predef', key = key, value = value })
  -- end

  -- t:, l:, s:

  local scope_sort = { buffer = 0, window = 1, predef = 2, global = 3 }
  table.sort(res, function(left, right)
    return scope_sort[left.scope] .. left.key < scope_sort[right.scope] .. right.key
  end)

  return res
end

return {
  get_variables = get_variables
}
