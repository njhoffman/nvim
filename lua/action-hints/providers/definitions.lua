local utils = require('action-hints.utils')
local display = require('action-hints.display')
local state = require('action-hints.state')

local function definitions(config)
  if not utils.supports_method('definitionProvider') then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local bufname = vim.uri_from_bufnr(bufnr)

  local params = {
    textDocument = { uri = bufname },
    position = { line = cursor[1] - 1, character = cursor[2] },
  }

  vim.lsp.buf_request(bufnr, 'textDocument/definition', params, function(err, result, _, _)
    if err or not result then
      state.available.definitions = false
      return
    end
    if vim.tbl_count(result) > 0 then
      state.available.definitions = true
      state.current.definitions = vim.tbl_count(result) - 1
      display.update_virtual_text(config)
      return
    end
    state.current.definitions = 0
    state.available.definitions = false
  end)
end

return definitions
