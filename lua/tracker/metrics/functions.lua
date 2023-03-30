-- function mkdx#InsertCtrlNHandler()

local get_functions = function()
  vim.cmd([[
  let temp_reg = @" | redir @" | silent! execute ":function" | redir END
    let w:output = copy(@") | let @" = temp_reg  " let w:output_len=len(split(output, "\n"))
    ]])
  local funcs = vim.fn.split(vim.api.nvim_eval("w:output"), "\n")
  local parsed = vim.tbl_map(function(line)
    return {
      name = string.gsub(line, "^function ", ""),
    }
  end, funcs)
  return parsed
end

local provider = function(_)
  return {
    name = "functions",
    id_fields = "name",
    get_data = get_functions,
  }
end

return provider
