-- local lsp_counts_default = { references = 0, code_actions = 0 }
local hls = {
  code_actions = { fg = '#a4a68a', name = 'ca' },
  code_actions_empty = { fg = '#334455', name = 'ca_empty' },
  references = { fg = '#4466aa', name = 'ref' },
  references_empty = { fg = '#334455', name = 'ref_empty' },
}

local state = {
  code_actions = 0,
  code_actions_hl = hls.code_actions_empty,
  references = 0,
  references_hl = hls.references_empty,
}

local references_count = function()
  -- 󰈇    󰈝                   秊 
  local count = 0
  local ok, ref_count = pcall(vim.api.nvim_buf_get_var, 0, 'lsp_count_references')
  if ok then
    count = ref_count
  end
  state.references = tonumber(count)
  if count == 0 then
    state.references_hl = hls.references_empty
    return ' '
  end
  state.references_hl = hls.references
  return ' '
end

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
  lsp_code_actions = code_actions_count,
  lsp_code_actions_hl = function()
    vim.dbglog('ca 2', state.code_actions)
    return state.code_actions_hl
  end,
  lsp_references = references_count,
  lsp_references_hl = function()
    return state.references_hl
  end,
}
