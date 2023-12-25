local base_source = require('tracker.sources._base')
-- :so $VIMRUNTIME/syntax/hitest.vim

local get_highlights = function(self)
  local results = {}
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
  self:_build_results(results, parsed_hls)
  return results.items, results.columns
end

  -- stylua: ignore
  return vim.tbl_extend('force', base_source, {
    name   = 'highlights',
    icon   = '',
    fields = { 'name', 'definition' },
    get    = get_highlights,
  })
