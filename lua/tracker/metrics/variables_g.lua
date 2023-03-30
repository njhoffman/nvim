local get_w_variables = function()
  vim.cmd([[
      let temp_reg = @" | redir @" | silent! execute ":let g:" | redir END
      let output = copy(@") | let @" = temp_reg
      let w:output_variables=split(output, "\n")
      ]])
  return vim.api.nvim_eval("w:output_variables")
end

local get_b_variables = function()
  vim.cmd([[
      let temp_reg = @" | redir @" | silent! execute ":let b:" | redir END
      let output = copy(@") | let @" = temp_reg
      let w:output_variables=split(output, "\n")
    ]])
  return vim.api.nvim_eval("w:output_variables")
end

local get_g_variables = function()
  vim.cmd([[
      let temp_reg = @" | redir @" | silent! execute ":let g:" | redir END
      let output = copy(@") | let @" = temp_reg
      let w:output_variables=split(output, "\n")
      ]])
  local vars = vim.fn.split(vim.api.nvim_eval("w:output_variables"), "\n")
  local parsed = vim.tbl_map(function(line)
    return {
      name = string.gsub(line, "", ""),
    }
  end, vars)
  return parsed
end

local provider = function(_)
  return {
    name = "variables",
    id_fields = { "name", "definition" },
    get_data = get_g_variables,
  }
end

return provider
