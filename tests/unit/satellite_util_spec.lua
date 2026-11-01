-- satellite.util.virtual_line_count: fold-aware line count without nvim_win_text_height
local util = require("satellite.util")

describe("satellite.util.virtual_line_count", function()
  local buf, win, saved_text_height, text_height_calls

  before_each(function()
    buf = vim.api.nvim_create_buf(false, true)
    local lines = {}
    for i = 1, 20 do
      lines[i] = ("line %d "):format(i) .. string.rep("x", 200)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    win = vim.api.nvim_open_win(
      buf,
      true,
      { relative = "editor", row = 0, col = 0, width = 40, height = 10 }
    )
    vim.wo[win].wrap = true
    util.invalidate_virtual_line_count_cache(win)
    text_height_calls = 0
    saved_text_height = vim.api.nvim_win_text_height
    vim.api.nvim_win_text_height = function(...)
      text_height_calls = text_height_calls + 1
      return saved_text_height(...)
    end
  end)

  after_each(function()
    vim.api.nvim_win_text_height = saved_text_height
    util.use_text_height = false
    pcall(vim.api.nvim_win_close, win, true)
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end)

  it("does not call nvim_win_text_height by default", function()
    util.virtual_line_count(win, 1)
    assert.are.equal(0, text_height_calls)
  end)

  it("counts buffer rows from a 0-based start row, ignoring soft wrapping", function()
    -- each 200+ char line wraps to several screen rows in a 40-column window
    assert.are.equal(20, util.virtual_line_count(win, 0))
    assert.are.equal(19, util.virtual_line_count(win, 1))
    assert.are.equal(5, util.virtual_line_count(win, 2, 6))
  end)

  it("counts a closed fold as one line", function()
    vim.api.nvim_win_call(win, function()
      vim.wo.foldmethod = "manual"
      vim.cmd("5,9fold")
    end)
    util.invalidate_virtual_line_count_cache(win)
    assert.are.equal(16, util.virtual_line_count(win, 0))
  end)

  it("matches nvim_win_text_height when lines don't wrap", function()
    vim.wo[win].wrap = false
    vim.api.nvim_win_call(win, function()
      vim.wo.foldmethod = "manual"
      vim.cmd("3,4fold")
      vim.cmd("10,15fold")
    end)
    for _, range in ipairs({ { 0, 19 }, { 1, 19 }, { 2, 12 }, { 4, 9 }, { 9, 16 } }) do
      util.invalidate_virtual_line_count_cache(win)
      local expected = saved_text_height(win, { start_row = range[1], end_row = range[2] }).all
      assert.are.equal(expected, util.virtual_line_count(win, range[1], range[2]))
    end
  end)

  it("uses nvim_win_text_height when enabled", function()
    util.use_text_height = true
    local height = util.virtual_line_count(win, 0)
    assert.are.equal(1, text_height_calls)
    assert.is_true(height > 20)
  end)
end)
