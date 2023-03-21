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
