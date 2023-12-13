-- :so $VIMRUNTIME/syntax/hitest.vim

local debuglog = require('debuglog').log

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
  debuglog('monitoring highlights: ' .. #highlights)
  return parsed_hls
end

local config = { longest_name = 0, min_name = 12 }
local output_highlights = function()
  local hls = get_highlights()
  for _, hl in ipairs(hls) do
    local name = hl.name or ''
    config.longest_name = math.max(config.longest_name, #name)
    local name = name .. string.rep(' ', config.longest_name - #name)
    table.insert(hls, '   ' .. name .. ' ' .. hl.definition)
  end
  for _, hl_out in ipairs(hls) do
    debuglog(hl_out)
  end
end

local init_highlights = function(provider, opts)
  local state = require('tracker.state')
  local timer = vim.fn.timer_start(1000, provider.output, { ['repeat'] = -1 })
  if type(state.timers[provider.name]) == 'nil' then
    state.timers[provider.name] = {}
  end
  table.insert(state.timers[provider.name], timer)
  state.initialized[provider.name] = true
end

-- stylua: ignore
local provider =  {
  name      = 'highlights',
  icon      = '',
  id_fields = { 'name', 'definition' },
  init      = init_highlights,
  get       = get_highlights,
  output    = output_highlights,
}

return provider
