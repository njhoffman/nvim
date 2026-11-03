-- md_codeblocks: yiC / yaC yank every fenced code block in a Markdown buffer without / with fences
local mc = require("md_codeblocks")

local buf

local function set(lines)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function reg()
  return vim.fn.getreg('"', 1, true), vim.fn.getregtype('"')
end

describe("md_codeblocks", function()
  local notify = vim.notify
  local messages

  before_each(function()
    messages = {}
    vim.notify = function(msg, level)
      table.insert(messages, { msg = msg, level = level })
    end
    vim.cmd("filetype plugin on")
    buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(buf)
    vim.bo[buf].filetype = "markdown"
    dofile(vim.fn.getcwd() .. "/after/ftplugin/markdown.lua")
    vim.fn.setreg('"', "sentinel")
  end)

  after_each(function()
    vim.notify = notify
    vim.cmd("enew!")
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end)

  it("maps yiC and yaC buffer-locally", function()
    assert.are.equal(1, vim.fn.maparg("yiC", "n", false, true).buffer)
    assert.are.equal(1, vim.fn.maparg("yaC", "n", false, true).buffer)
  end)

  it("yanks all blocks linewise, separated by one blank line", function()
    set({
      "# Title",
      "",
      "```bash",
      "echo one",
      "echo two",
      "```",
      "",
      "Some prose.",
      "",
      "```lua",
      "print(1)",
      "```",
    })
    assert.are.equal(2, mc.yank_all(buf))
    local lines, regtype = reg()
    assert.are.same({ "echo one", "echo two", "", "print(1)" }, lines)
    assert.are.equal("V", regtype)
    assert.are.same(lines, vim.fn.getreg("0", 1, true))
    assert.are.equal("Yanked 2 code blocks (4 lines)", messages[#messages].msg)
  end)

  it("handles ~~~ fences and fences of four backticks containing ```", function()
    set({
      "~~~",
      "tilde",
      "~~~",
      "",
      "````md",
      "```",
      "inner",
      "```",
      "````",
    })
    assert.are.equal(2, mc.yank_all(buf))
    assert.are.same({ "tilde", "", "```", "inner", "```" }, (reg()))
  end)

  it("dedents a block nested in a list item, keeping relative indent", function()
    set({
      "- item",
      "",
      "  ```python",
      "  def f():",
      "      return 1",
      "  ```",
    })
    assert.are.equal(1, mc.yank_all(buf))
    assert.are.same({ "def f():", "    return 1" }, (reg()))
  end)

  it("keeps blank lines inside a block", function()
    set({ "```", "a", "", "b", "```" })
    mc.yank_all(buf)
    assert.are.same({ "a", "", "b" }, (reg()))
  end)

  it("skips empty blocks", function()
    set({ "```", "```", "", "```sh", "ls", "```" })
    assert.are.equal(1, mc.yank_all(buf))
    assert.are.same({ "ls" }, (reg()))
  end)

  it("includes an unclosed block running to the end of the buffer", function()
    set({ "text", "", "```", "last line" })
    assert.are.equal(1, mc.yank_all(buf))
    assert.are.same({ "last line" }, (reg()))
  end)

  it("ignores indented code blocks and inline code", function()
    set({ "Use `ls` here.", "", "    indented code", "", "```", "fenced", "```" })
    mc.yank_all(buf)
    assert.are.same({ "fenced" }, (reg()))
  end)

  it("warns and leaves the register alone when there are no blocks", function()
    set({ "# Nothing", "", "just prose" })
    assert.are.equal(0, mc.yank_all(buf))
    assert.are.same({ "sentinel" }, (reg()))
    assert.are.equal(vim.log.levels.WARN, messages[#messages].level)
  end)

  it("runs from the yiC mapping", function()
    set({ "```", "mapped", "```" })
    vim.api.nvim_feedkeys("yiC", "x", false)
    assert.are.same({ "mapped" }, (reg()))
  end)

  describe("with fences (yaC)", function()
    it("keeps each block's fences and language", function()
      set({
        "# Title",
        "",
        "```bash",
        "echo one",
        "```",
        "",
        "prose",
        "",
        "~~~lua",
        "print(1)",
        "~~~",
      })
      assert.are.equal(2, mc.yank_all(buf, true))
      assert.are.same({ "```bash", "echo one", "```", "", "~~~lua", "print(1)", "~~~" }, (reg()))
    end)

    it("dedents fences and contents of a block nested in a list item", function()
      set({ "- item", "", "  ```python", "  def f():", "      return 1", "  ```", "- next" })
      mc.yank_all(buf, true)
      assert.are.same({ "```python", "def f():", "    return 1", "```" }, (reg()))
    end)

    it("yanks an unclosed block at the end of the buffer up to its last line", function()
      set({ "text", "", "```sh", "last line" })
      mc.yank_all(buf, true)
      assert.are.same({ "```sh", "last line" }, (reg()))
    end)

    it("runs from the yaC mapping", function()
      set({ "```js", "mapped", "```" })
      vim.api.nvim_feedkeys("yaC", "x", false)
      assert.are.same({ "```js", "mapped", "```" }, (reg()))
    end)
  end)
end)
