local hls = {
  references = { fg = '#4466aa', name = 'ref' },
  references_empty = { fg = '#334455', name = 'ref_empty' },
}

local state = {
  references = 0,
  references_hl = hls.references_empty,
}

local references_count = function()
  -- 󰈇    󰈝                   秊 
  local count = 0
  local ok, ref_count = pcall(vim.api.nvim_buf_get_var, 0, 'lsp_cursor_references')
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

return {
  provider = references_count,
  hl = function()
    return state.references_hl
  end,
}
