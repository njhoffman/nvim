-- Markdown indents by 2 like everything else: the runtime ftplugin's "recommended style"
-- (shiftwidth=4) is turned off in vim-options
describe("markdown indentation", function()
  local buf

  before_each(function()
    require("core.options.vim")
    vim.cmd("filetype plugin on")
    buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(buf)
    vim.bo[buf].filetype = "markdown"
  end)

  after_each(function()
    vim.cmd("enew")
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end)

  it("disables the runtime ftplugin's recommended style", function()
    assert.are.equal(0, vim.g.markdown_recommended_style)
  end)

  it("keeps shiftwidth and tabstop at 2", function()
    assert.are.equal(2, vim.bo[buf].shiftwidth)
    assert.are.equal(2, vim.bo[buf].tabstop)
  end)

  it("shifts a list item one level (2 spaces) at a time", function()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "- parent", "- child", "- grandchild" })
    vim.api.nvim_win_set_cursor(0, { 2, 0 })
    vim.cmd("normal! >>")
    vim.api.nvim_win_set_cursor(0, { 3, 0 })
    vim.cmd("normal! >>>>")
    assert.are.same(
      { "- parent", "  - child", "    - grandchild" },
      vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    )
    vim.cmd("normal! <<")
    assert.are.equal("  - grandchild", vim.api.nvim_buf_get_lines(buf, 2, 3, false)[1])
  end)
end)
