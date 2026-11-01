-- md_backtick: visual ` toggles inline code spans and fenced blocks in Markdown
local md = require("md_backtick")

local buf, notes, saved_notify

local function set(lines)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function get()
  return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
end

--- Select charwise from {row, col} to {row, col} (0-based cols, end inclusive) and toggle.
local function toggle_chars(s, e)
  vim.api.nvim_win_set_cursor(0, s)
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, e)
  return md.toggle()
end

local function toggle_lines(srow, erow)
  vim.api.nvim_win_set_cursor(0, { srow, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { erow, 0 })
  return md.toggle()
end

--- Text of the current selection, one string per line.
local function selection()
  local mode = vim.fn.mode()
  return mode, vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })
end

describe("md_backtick", function()
  before_each(function()
    buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(buf)
    notes = {}
    saved_notify = vim.notify
    vim.notify = function(msg)
      table.insert(notes, msg)
    end
  end)

  after_each(function()
    vim.notify = saved_notify
    vim.cmd("normal! \27")
    vim.cmd("enew!")
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end)

  describe("inline", function()
    it("wraps a selection within one line in single backticks", function()
      set({ "run the make command now" })
      assert.are.equal("wrapped", toggle_chars({ 1, 8 }, { 1, 11 }))
      assert.are.same({ "run the `make` command now" }, get())
      assert.are.same({}, notes)
    end)

    it("keeps the wrapped text selected, backticks included", function()
      set({ "run the make command now" })
      toggle_chars({ 1, 8 }, { 1, 11 })
      local mode, text = selection()
      assert.are.equal("v", mode)
      assert.are.same({ "`make`" }, text)
    end)

    it("toggles back off on a second press, keeping the selection", function()
      set({ "run the make command now" })
      toggle_chars({ 1, 8 }, { 1, 11 })
      assert.are.equal("unwrapped", md.toggle())
      assert.are.same({ "run the make command now" }, get())
      assert.are.same({ "Removed backticks" }, notes)
      local mode, text = selection()
      assert.are.equal("v", mode)
      assert.are.same({ "make" }, text)
    end)

    it("unwraps a double-backtick span", function()
      set({ "a ``x`y`` b" })
      assert.are.equal("unwrapped", toggle_chars({ 1, 2 }, { 1, 8 }))
      assert.are.same({ "a x`y b" }, get())
    end)

    it("strips every backtick when the selection isn't one wrapped span", function()
      set({ "use `a` and `b` here" })
      assert.are.equal("stripped", toggle_chars({ 1, 4 }, { 1, 14 }))
      assert.are.same({ "use a and b here" }, get())
      assert.are.same({ "Removed all backticks in the selection" }, notes)
      local _, text = selection()
      assert.are.same({ "a and b" }, text)
    end)

    it("handles multibyte characters at the selection edges", function()
      set({ "x héllo wörld y" })
      toggle_chars({ 1, 2 }, { 1, 14 })
      assert.are.same({ "x `héllo wörld` y" }, get())
    end)
  end)

  describe("block", function()
    it("fences a charwise selection that spans lines, as whole lines", function()
      set({ "intro", "local a = 1", "print(a)", "outro" })
      assert.are.equal("wrapped", toggle_chars({ 2, 3 }, { 3, 2 }))
      assert.are.same({ "intro", "```", "local a = 1", "print(a)", "```", "outro" }, get())
      local mode, text = selection()
      assert.are.equal("V", mode)
      assert.are.same({ "```", "local a = 1", "print(a)", "```" }, text)
    end)

    it("fences a single line selected linewise", function()
      set({ "echo hi" })
      toggle_lines(1, 1)
      assert.are.same({ "```", "echo hi", "```" }, get())
    end)

    it("indents the fence like the first non-blank line (code inside a list)", function()
      set({ "- step", "", "  make build", "  make test" })
      toggle_lines(2, 4)
      assert.are.same({ "- step", "  ```", "", "  make build", "  make test", "  ```" }, get())
    end)

    it("removes the fence on a second press and keeps the content selected", function()
      set({ "a", "b" })
      toggle_lines(1, 2)
      assert.are.equal("unwrapped", md.toggle())
      assert.are.same({ "a", "b" }, get())
      assert.are.same({ "Removed backticks" }, notes)
      local mode, text = selection()
      assert.are.equal("V", mode)
      assert.are.same({ "a", "b" }, text)
    end)

    it("unwraps a fence with a language and keeps backticks inside the code", function()
      set({ "```bash", 'echo "$(date)" `uname`', "```" })
      assert.are.equal("unwrapped", toggle_lines(1, 3))
      assert.are.same({ 'echo "$(date)" `uname`' }, get())
    end)

    it("strips fences and backticks inside a selection that isn't one fenced block", function()
      set({ "see `x`", "```lua", "y()", "```", "end" })
      assert.are.equal("stripped", toggle_lines(1, 5))
      assert.are.same({ "see x", "y()", "end" }, get())
      local _, text = selection()
      assert.are.same({ "see x", "y()", "end" }, text)
    end)

    it("wraps normally after stripping", function()
      set({ "see `x`", "end" })
      toggle_lines(1, 2)
      assert.are.equal("wrapped", md.toggle())
      assert.are.same({ "```", "see x", "end", "```" }, get())
    end)
  end)

  describe("setup", function()
    it("maps ` in visual mode only in markdown buffers", function()
      md.setup()
      vim.bo[buf].filetype = "markdown"
      assert.are.equal(1, vim.fn.maparg("`", "x", false, true).buffer)
      local other = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_set_current_buf(other)
      vim.bo[other].filetype = "lua"
      assert.are_not.equal(1, vim.fn.maparg("`", "x", false, true).buffer)
      vim.api.nvim_buf_delete(other, { force = true })
    end)
  end)
end)
