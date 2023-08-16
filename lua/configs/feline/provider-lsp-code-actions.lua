-- local lsp_counts_default = { references = 0, code_actions = 0 }
local hls = {
  code_actions = { fg = '#a4a68a', name = 'ca' },
  code_actions_empty = { fg = '#334455', name = 'ca_empty' },
}

local state = {
  code_actions = 0,
  code_actions_hl = hls.code_actions_empty,
}

local code_actions_count = function()
  --   ﯦ  ﯧ 
  local count = 0
  local ok, ca_count = pcall(vim.api.nvim_buf_get_var, 0, 'lsp_count_code_actions')
  if ok then
    count = ca_count
  end
  state.code_actions = tonumber(count)
  if count == 0 then
    state.code_actions_hl = hls.code_actions_empty
    return ''
  end
  state.code_actions_hl = hls.code_actions
  return ''
end

return {
  provider = code_actions_count,
  hl = function()
    return state.code_actions_hl
  end,
}
