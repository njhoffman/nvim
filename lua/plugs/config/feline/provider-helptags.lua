local hls = {
  hl_empty = { fg = '#334455', name = 'help_hl_empty' },
  hl = { fg = '#8899FF', name = 'help_hl' },
}
local state = { match = false, hl = hls.hl_empty }
local nums = { tags = 0, hl = 0 }

--  ﲉ   ﬤ  
local helptags = function()
  -- nums.tags = nums.tags + 1
  local ok, help_tags = pcall(vim.api.nvim_buf_get_var, 0, 'status_help_tag')
  state.match = ok and help_tags or false
  -- vim.dbglog('help: ' .. nums.tags .. '\t' .. nums.hl)
  if state.match then
    state.hl = hls.hl
    return ' '
  else
    state.hl = hls.hl_empty
    return ' '
  end
end

return {
  name = 'helptags',
  provider = helptags,
  provider_hl = function()
    -- nums.hl = nums.hl + 1
    return state.hl
  end,
}
