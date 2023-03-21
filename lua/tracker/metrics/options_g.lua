local get_options = function(scope)
  local res = {}
  scope = scope or "all"
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

local get_variables = function(scope)
  if scope == "buffer" then
    vim.cmd([[
      let temp_reg = @" | redir @" | silent! execute ":let b:" | redir END
      let output = copy(@") | let @" = temp_reg
      let w:output_variables=split(output, "\n")
    ]])
  elseif scope == "window" then
    vim.cmd([[
      let temp_reg = @" | redir @" | silent! execute ":let w:" | redir END
      let output = copy(@") | let @" = temp_reg
      let w:output_variables=split(output, "\n")
    ]])
  else
    vim.cmd([[
      let temp_reg = @" | redir @" | silent! execute ":let g:" | redir END
      let output = copy(@") | let @" = temp_reg
      let w:output_variables=split(output, "\n")
      ]])
  end
  return vim.api.nvim_eval("w:output_variables")
end
