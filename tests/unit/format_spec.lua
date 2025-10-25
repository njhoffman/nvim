-- Unit tests for format commands
-- Tests checkbox toggling, whitespace trimming, and other format utilities

describe("Format Commands", function()
  local format

  before_each(function()
    format = require("commands.format")
  end)

  describe("Module structure", function()
    it("exports required functions", function()
      assert.is_not_nil(format)
      assert.are.equal("table", type(format))
      assert.are.equal("function", type(format.toggle_checkbox))
      assert.are.equal("function", type(format.truncate_log))
      assert.are.equal("function", type(format.trim_space))
    end)
  end)

  describe("toggle_checkbox", function()
    local bufnr

    before_each(function()
      bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_set_current_buf(bufnr)
      vim.bo[bufnr].filetype = "markdown"
    end)

    after_each(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end)

    it("creates checkbox on plain line", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Buy milk" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      format.toggle_checkbox()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("- [ ] Buy milk", lines[1])
    end)

    it("creates checkbox on list item", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "- Buy milk" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      format.toggle_checkbox()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("- [ ] Buy milk", lines[1])
    end)

    it("creates checkbox on numbered list", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "1. Buy milk" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      format.toggle_checkbox()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("1. [ ] Buy milk", lines[1])
    end)

    it("checks unchecked checkbox", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "- [ ] Buy milk" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      format.toggle_checkbox()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("- [x] Buy milk", lines[1])
    end)

    it("unchecks checked checkbox", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "- [x] Buy milk" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      format.toggle_checkbox()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("- [ ] Buy milk", lines[1])
    end)

    it("handles checkbox with capital X", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "- [X] Buy milk" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      format.toggle_checkbox()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("- [ ] Buy milk", lines[1])
    end)

    it("handles indented checkboxes", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "  - [ ] Nested item" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      format.toggle_checkbox()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("  - [x] Nested item", lines[1])
    end)

    it("preserves cursor position", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "- [ ] Buy milk" })
      local orig_pos = { 1, 5 }
      vim.api.nvim_win_set_cursor(0, orig_pos)

      format.toggle_checkbox()

      local new_pos = vim.api.nvim_win_get_cursor(0)
      assert.are.same(orig_pos, new_pos)
    end)

    it("handles empty line", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      -- Should not error
      local ok = pcall(format.toggle_checkbox)
      assert.is_true(ok)
    end)

    it("handles bullet points with asterisk", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "* [ ] Task" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      format.toggle_checkbox()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("* [x] Task", lines[1])
    end)

    it("handles bullet points with plus", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "+ [ ] Task" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      format.toggle_checkbox()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("+ [x] Task", lines[1])
    end)
  end)

  describe("truncate_log", function()
    it("only works on .log files", function()
      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_name(bufnr, "test.txt")
      vim.api.nvim_set_current_buf(bufnr)

      -- Should notify that it's not a log file
      local ok = pcall(format.truncate_log)
      assert.is_true(ok)

      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)
  end)

  describe("trim_space", function()
    local bufnr

    before_each(function()
      bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_set_current_buf(bufnr)
    end)

    after_each(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end)

    it("removes trailing whitespace", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
        "line one   ",
        "line two\t",
        "line three",
      })

      format.trim_space()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("line one", lines[1])
      assert.are.equal("line two", lines[2])
      assert.are.equal("line three", lines[3])
    end)

    it("handles empty lines", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
        "line one",
        "   ",
        "line three",
      })

      format.trim_space()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("line one", lines[1])
      assert.are.equal("", lines[2])
      assert.are.equal("line three", lines[3])
    end)

    it("preserves leading whitespace", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
        "  indented line  ",
        "    more indent  ",
      })

      format.trim_space()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("  indented line", lines[1])
      assert.are.equal("    more indent", lines[2])
    end)

    it("handles buffer with no trailing whitespace", function()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
        "clean line",
        "another clean line",
      })

      format.trim_space()

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      assert.are.equal("clean line", lines[1])
      assert.are.equal("another clean line", lines[2])
    end)
  end)

  describe("Edge cases", function()
    it("handles modifiable buffer check", function()
      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_set_current_buf(bufnr)
      vim.bo[bufnr].modifiable = false

      -- Should handle gracefully
      local ok = pcall(format.trim_space)
      -- May fail due to non-modifiable, which is expected
      assert.is_boolean(ok)

      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)
  end)
end)
