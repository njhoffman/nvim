-- md_prose: J reflows Markdown prose; typing wraps even on lines that were already long
local md = require("md_prose")

local buf

local function set(lines)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function get()
  return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
end

describe("md_prose", function()
  before_each(function()
    vim.cmd("filetype plugin on")
    buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(buf)
    vim.bo[buf].filetype = "markdown"
    dofile(vim.fn.getcwd() .. "/after/ftplugin/markdown.lua")
    vim.bo[buf].textwidth = 40
  end)

  after_each(function()
    vim.cmd("enew!")
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end)

  it("wraps while typing and drops 'l' and 'a' after the runtime ftplugin", function()
    local fo = vim.bo[buf].formatoptions
    assert.is_truthy(fo:find("t", 1, true))
    assert.is_falsy(fo:find("l", 1, true))
    assert.is_falsy(fo:find("a", 1, true))
  end)

  it("maps J buffer-locally", function()
    assert.are.equal(1, vim.fn.maparg("J", "n", false, true).buffer)
  end)

  it("reflows the paragraph after joining and keeps the cursor at the join point", function()
    set({
      "Some paragraph text that wraps",
      "at forty columns and has",
      "more words after it ok",
      "",
      "next",
    })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    md.join()
    assert.are.same(
      {
        "Some paragraph text that wraps at forty",
        "columns and has more words after it ok",
        "",
        "next",
      },
      get()
    )
    assert.are.same({ 1, 30 }, vim.api.nvim_win_get_cursor(0))
  end)

  it("keeps list items separate when reflowing", function()
    set({ "- first item has some words in it", "  continued here", "- second item", "- third" })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    md.join()
    assert.are.same(
      { "- first item has some words in it", "  continued here", "- second item", "- third" },
      get()
    )
  end)

  it("only joins inside a fenced code block", function()
    set({ "```lua", "local a = 1", "local b = 2", "```" })
    vim.api.nvim_win_set_cursor(0, { 2, 0 })
    md.join()
    assert.are.same({ "```lua", "local a = 1 local b = 2", "```" }, get())
  end)

  it("honors a count", function()
    set({ "```", "a", "b", "c", "d", "```" })
    vim.api.nvim_win_set_cursor(0, { 2, 0 })
    vim.cmd("normal 3J")
    assert.are.same({ "```", "a b c", "d", "```" }, get())
  end)

  it("merges a short paragraph into one line when joining with a count", function()
    set({ "one", "two", "three", "four" })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.cmd("normal 3J")
    assert.are.same({ "one two three four" }, get())
  end)

  it("wraps typed text on a line that was already longer than textwidth", function()
    set({ string.rep("word ", 10) .. "end" })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.cmd("normal! A more words typed here")
    for _, l in ipairs(get()) do
      assert.is_true(#l <= 40, "line too long: " .. l)
    end
  end)
end)
