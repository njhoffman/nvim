-- Tests for utils.hl.add_highlight, the nvim_buf_add_highlight replacement

local hl = require("utils.hl")

local function marks(buf, ns)
  return vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, { details = true })
end

describe("utils.hl.add_highlight", function()
  local buf, ns

  before_each(function()
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "hello world", "second line" })
    ns = vim.api.nvim_create_namespace("utils_hl_spec")
  end)

  after_each(function()
    vim.api.nvim_buf_delete(buf, { force = true })
  end)

  it("highlights a column range", function()
    hl.add_highlight(buf, ns, "Search", 0, 0, 5)
    local m = marks(buf, ns)
    assert.are.equal(1, #m)
    assert.are.same({ 0, 0 }, { m[1][2], m[1][3] })
    assert.are.equal(0, m[1][4].end_row)
    assert.are.equal(5, m[1][4].end_col)
    assert.are.equal("Search", m[1][4].hl_group)
  end)

  it("highlights to end of line when col_end is -1", function()
    hl.add_highlight(buf, ns, "Search", 0, 6, -1)
    local d = marks(buf, ns)[1][4]
    assert.are.equal(1, d.end_row)
    assert.are.equal(0, d.end_col)
  end)

  it("clamps -1 on the last line instead of erroring", function()
    assert.has_no.errors(function()
      hl.add_highlight(buf, ns, "Search", 1, 0, -1)
    end)
    assert.are.equal(1, #marks(buf, ns))
  end)

  it("clamps out-of-range columns instead of erroring", function()
    assert.has_no.errors(function()
      hl.add_highlight(buf, ns, "Search", 0, 2, 999)
    end)
    assert.are.equal(1, #marks(buf, ns))
  end)

  it("maps ns_id 0 and -1 to a shared fallback namespace and returns it", function()
    local a = hl.add_highlight(buf, -1, "Search", 0, 0, 1)
    local b = hl.add_highlight(buf, 0, "Search", 1, 0, 1)
    assert.is_true(a > 0)
    assert.are.equal(a, b)
    assert.are.equal(2, #marks(buf, a))
  end)

  it("returns the namespace it was given", function()
    assert.are.equal(ns, hl.add_highlight(buf, ns, "Search", 0, 0, 1))
  end)
end)
