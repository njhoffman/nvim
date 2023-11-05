local utils = require('action-hints.utils')
local display = require('action-hints.display')
local state = require('action-hints.state')

local function codeactions(config)
  local options = config or {}
  local function range_from_selection(bufnr, mode)
    -- TODO: Use `vim.region()` instead https://github.com/neovim/neovim/pull/13896
    -- [bufnum, lnum, col, off]; both row and column 1-indexed
    local start = vim.fn.getpos('v') or vim.fn.getpos('V') or { 0, 1, 1, 0 }
    local end_ = vim.fn.getpos('.') or { 0, 1, 1, 0 }
    local start_row = start[2]
    local start_col = start[3]
    local end_row = end_[2]
    local end_col = end_[3]

    -- A user can start visual selection at the end and move backwards
    -- Normalize the range to start < end
    if start_row == end_row and end_col < start_col then
      end_col, start_col = start_col, end_col
    elseif end_row < start_row then
      start_row, end_row = end_row, start_row
      start_col, end_col = end_col, start_col
    end

    if mode == 'V' then
      start_col = 1
      local lines = vim.api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)
      end_col = #lines[1]
    end

    return {
      ['start'] = { start_row, start_col - 1 },
      ['end'] = { end_row, end_col - 1 },
    }
  end

  if not utils.supports_method('codeActionProvider') then
    return
  end

  -- if utils.is_cursor_on_whitespace() then
  if state.is_cleared == false then
    display.clear_virtual_text()
    state.is_cleared = true
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  -- context.only = opts.action_kinds

  local params
  local mode = vim.api.nvim_get_mode().mode
  if options.range then
    assert(type(options.range) == 'table', 'codeaction range must be a table')
    local start = assert(options.range.start, 'range must have a `start` property')
    local end_ = assert(options.range['end'], 'range must have a `end` property')
    params = vim.lsp.util.make_given_range_params(start, end_)
  elseif mode == 'v' or mode == 'V' then
    local range = range_from_selection(0, mode)
    params = vim.lsp.util.make_given_range_params(range.start, range['end'])
  else
    params = vim.lsp.util.make_range_params()
  end

  params.context = context

  vim.lsp.buf_request_all(bufnr, 'textDocument/codeAction', params, function(responses, _, _)
    if not responses then
      state.available.codeactions = false
      state.current.codeactions = 0
      return
    end

    local results = {}
    for client_id, response in pairs(responses) do
      -- [1] = { arguments = { title = "Cycle Case" }, command = "NULL_LS_CODE_ACTION", title = "Cycle Case" },
      for _, result in ipairs(response.result or {}) do
        table.insert(results, result)
      end
    end

    if vim.tbl_count(results) > 0 then
      state.available.codeactions = true
      state.current.codeactions = vim.tbl_count(results) - 1
      display.update_virtual_text(config)
      return
    end
    state.available.codeactions = false
    state.current.codeactions = 0
  end)
end

return codeactions
