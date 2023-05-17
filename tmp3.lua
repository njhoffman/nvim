local _get_code_actions = function()
  local params = vim.lsp.util.make_range_params()
  params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local res = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params) or {}
  local n = 0
  for _, client in ipairs(res) do
    if type(client.result) == 'table' then
      n = n + #client.result
    end
  end
  return n
end

local _get_references = function()
  local params = vim.lsp.util.make_position_params()
  params.context = { includeDeclaration = vim.F.if_nil(nil, true) }
  local res = vim.lsp.buf_request_sync(0, 'textDocument/references', params) or {}
  local n = 0
  for _, client in ipairs(res) do
    if type(client.result) == 'table' then
      n = n + #client.result
    end
  end
  return n
end

local get_references = function()
  local params = vim.lsp.util.make_position_params()
  params.context = { includeDeclaration = vim.F.if_nil(nil, true) }
  -- local res = vim.lsp.buf_request_all(0, 'textDocument/references', params) or {}
  -- local n = 0
  -- for _, client in ipairs(res) do
  --   if type(client.result) == 'table' then
  --     n = n + #client.result
  --   end
  -- end
  return res
end

vim.dbglog(get_references())
