-- configs.conform: prettierd must use conform's built-in definition (file on stdin plus its path); the old
-- overrides passed neither, so prettierd ran and changed nothing
local conform_path = vim.fn.stdpath("data") .. "/lazy/conform.nvim"

describe("configs.conform", function()
  local conform

  before_each(function()
    if not conform then
      vim.opt.rtp:append(conform_path)
      require("configs.conform")
      conform = require("conform")
    end
  end)

  it("does not override the built-in prettierd definition", function()
    assert.is_nil(conform.formatters.prettierd)
    local cfg = conform.get_formatter_config("prettierd")
    assert.is_true(cfg.stdin)
    assert.is_truthy(vim.tbl_contains(cfg.args, "$FILENAME"))
  end)

  it("defines no prettierd variants that can't take CLI options", function()
    for name in pairs(conform.formatters) do
      assert.is_falsy(name:find("^prettierd_"), name .. " is still defined")
    end
  end)

  it("runs prettierd for web, data and Markdown filetypes", function()
    for _, ft in ipairs({
      "css",
      "html",
      "json",
      "yaml",
      "javascript",
      "typescript",
      "vue",
      "markdown",
    }) do
      assert.is_truthy(vim.tbl_contains(conform.formatters_by_ft[ft], "prettierd"), ft)
    end
  end)

  it("leaves toml to taplo", function()
    assert.are.same({ "taplo" }, conform.formatters_by_ft.toml)
  end)

  it("formats a css buffer when prettierd is installed", function()
    if vim.fn.executable("prettierd") == 0 then
      pending("prettierd not installed")
      return
    end
    local path = vim.fn.tempname() .. ".css"
    vim.fn.writefile({ "a{color:red}" }, path)
    vim.cmd("edit " .. path)
    local buf = vim.api.nvim_get_current_buf()
    conform.format({ bufnr = buf, formatters = { "prettierd" }, async = false, timeout_ms = 10000 })
    assert.are.same({ "a {", "  color: red;", "}" }, vim.api.nvim_buf_get_lines(buf, 0, -1, false))
    vim.cmd("bwipeout!")
  end)
end)
