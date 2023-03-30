-- :so $VIMRUNTIME/syntax/hitest.vim
local get_highlights = function()
  vim.cmd([[
        let temp_reg = @" | redir @" | silent! execute ":highlight" | redir END
        let w:output = copy(@") | let @" = temp_reg  " let w:output_len=len(split(output, "\n"))
      ]])
  local highlights = vim.fn.split(vim.api.nvim_eval("w:output"), "\n")
  local parsed = vim.tbl_map(function(line)
    local definition = string.match(line, "xxx.+$") or ""
    return {
      name = string.match(line, "[^ ]+"),
      definition = string.gsub(definition, "xxx ", ""),
    }
  end, highlights)
  return parsed
end

local provider = function(_)
  return {
    name = "highlights",
    id_fields = { "name", "definition" },
    get_data = get_highlights,
  }
end

return provider
