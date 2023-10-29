local bufnr = vim.api.nvim_get_current_buf()
local cursor = vim.api.nvim_win_get_cursor(0)
local bufname = vim.uri_from_bufnr(bufnr)

local params = {
  textDocument = { uri = bufname },
  position = { line = cursor[1] - 1, character = cursor[2] },
}

vim.lsp.buf_request(bufnr, 'textDocument/codeAction', params, function(err, result, _, _)
  vim.dbglog('RESULT', result)
end)
