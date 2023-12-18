-- :so $VIMRUNTIME/syntax/hitest.vim

local debuglog = require('debuglog').log

local config = { longest_name = 0, min_name = 12 }

local output_highlights = function(highlights)
  local hl_lines = {}
  for _, hl in ipairs(highlights) do
    local name = hl.name or ''
    local definition = hl.definition or ''
    config.longest_name = math.max(config.longest_name, #name)
    local name = name .. string.rep(' ', config.longest_name - #name)
    table.insert(hl_lines, '   ' .. name .. ' ' .. definition)
  end
  for _, hl_out in ipairs(hls) do
    debuglog(hl_out)
  end
end

local get_highlights = function()
  vim.cmd([[
    let temp_reg = @" | redir @" | silent! execute ":highlight" | redir END
    let w:output = copy(@") | let @" = temp_reg  " let w:output_len=len(split(output, "\n"))
  ]])
  local highlights = vim.fn.split(vim.api.nvim_eval('w:output'), '\n')
  local parsed_hls = vim.tbl_map(function(line)
    local definition = string.match(line, 'xxx.+$') or ''
    return {
      name = string.match(line, '[^ ]+'),
      definition = string.gsub(definition, 'xxx ', ''),
    }
  end, highlights)
  return parsed_hls
end

-- stylua: ignore
local provider =  {
  name      = 'highlights',
  icon      = '',
  id_fields = { 'name', 'definition' },
  get       = get_highlights,
  -- output    = output_highlights,
}
return provider
