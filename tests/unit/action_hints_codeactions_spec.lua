--- Tests for the action-hints code action provider's visual selection range.
--- Stubs the LSP request and captures the params built from real visual selections.

describe("action-hints codeactions", function()
  local codeactions = require("action-hints.providers.codeactions")
  local utils = require("action-hints.utils")
  local orig_supports, orig_request = utils.supports_method, vim.lsp.buf_request_all
  local captured

  before_each(function()
    captured = nil
    utils.supports_method = function()
      return true
    end
    vim.lsp.buf_request_all = function(_, _, params)
      captured = params
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "abc", "", "héllo", "" })
  end)

  after_each(function()
    vim.cmd("normal! \27")
    utils.supports_method, vim.lsp.buf_request_all = orig_supports, orig_request
  end)

  local function select(mode, from, to)
    vim.api.nvim_win_set_cursor(0, from)
    vim.cmd("normal! " .. mode)
    vim.api.nvim_win_set_cursor(0, to)
    codeactions({})
    return captured.range
  end

  it("handles a linewise selection ending on an empty line", function()
    local range = select("V", { 1, 0 }, { 2, 0 })
    assert.are.same({ line = 0, character = 0 }, range.start)
    assert.are.same({ line = 2, character = 0 }, range["end"])
  end)

  it("handles a linewise selection of only empty lines", function()
    local range = select("V", { 4, 0 }, { 4, 0 })
    assert.are.same({ line = 3, character = 0 }, range.start)
  end)

  it("handles a charwise selection starting on an empty line", function()
    local range = select("v", { 2, 0 }, { 3, 1 })
    assert.are.same({ line = 1, character = 0 }, range.start)
    assert.are.same({ line = 2, character = 3 }, range["end"])
  end)

  it("normalizes a backwards selection", function()
    local range = select("v", { 3, 1 }, { 1, 1 })
    assert.are.same({ line = 0, character = 1 }, range.start)
    assert.are.same({ line = 2, character = 3 }, range["end"])
  end)
end)
