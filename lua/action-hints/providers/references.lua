local utils = require('action-hints.utils')
local display = require('action-hints.display')
local state = require('action-hints.state')

local function references(config)
  if not utils.supports_method('referencesProvider') then
    return
  end

  if state.is_cleared == false then
    display.clear_virtual_text()
    state.is_cleared = true
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local bufname = vim.uri_from_bufnr(bufnr)

  local params = {
    textDocument = { uri = bufname },
    position = { line = cursor[1] - 1, character = cursor[2] },
    context = { includeDeclaration = true },
  }
  vim.lsp.buf_request(bufnr, 'textDocument/references', params, function(err, result, _, _)
    if err or not result then
      state.available.references = false
      state.current.references = 0
      if err then
        display.clear_virtual_text()
        state.is_cleared = true
      end
      return
    end

    if vim.tbl_count(result) > 0 then
      state.available.references = true
      state.current.references = vim.tbl_count(result) - 1
      state.stats.counts.references = state.stats.counts.references + 1
      display.update_virtual_text(config)
      return
    end
    state.available.references = false
    state.current.references = 0
  end)
end

return references
