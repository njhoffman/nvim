local function set_highlight(group, fg)
  vim.cmd(string.format('highlight %s guifg=%s guibg=%s gui=bold', group, fg, '#000000'))
end

local get_code_actions = function()
  local bufnr = tonumber(vim.g.actual_curbuf) or 0
  local params = vim.lsp.util.make_range_params()
  params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local res = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params) or {}
  local n = 0
  for _, client in ipairs(res) do
    if client.result then
      n = n + #client.result
    end
  end
  return n
end

local get_references = function()
  local params = vim.lsp.util.make_position_params()
  params.context = { includeDeclaration = vim.F.if_nil(nil, true) }
  local res = vim.lsp.buf_request_sync(0, 'textDocument/references', params) or {}
  local n = 0
  for _, client in ipairs(res) do
    if client.result then
      n = n + #client.result
    end
  end
  return n
end

local lspextras = function(_, _)
  -- set_highlight('StatusLabel', colors.main.fg)
  -- local refs = get_references()
  -- local actions = get_code_actions()
  -- return actions
  -- return refs .. ' ' .. actions
  -- vim.dbglog('lspextras')
  return 'test'
end

return {
  name = 'lspextras',
  provider = lspextras,
}
