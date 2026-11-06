-- The config must not replace modules of the telescope fork, and its log wiring must work with them.
local data = vim.fn.stdpath("data") .. "/lazy/"
local fork = vim.fn.expand("~/git/telescope.nvim")
local telescope_dir = vim.fn.isdirectory(fork) == 1 and fork or (data .. "telescope.nvim")
vim.opt.rtp:append(telescope_dir)
vim.opt.rtp:append(data .. "plenary.nvim")

describe("telescope fork", function()
  it("is not shadowed by a module in this config", function()
    local config_dir = vim.fn.getcwd() .. "/lua/telescope/"
    local shadows = {}
    for _, file in ipairs(vim.fn.glob(telescope_dir .. "/lua/telescope/**/*.lua", true, true)) do
      local relative = file:sub(#telescope_dir + #"/lua/telescope/" + 1)
      if vim.uv.fs_stat(config_dir .. relative) then
        table.insert(shadows, relative)
      end
    end
    assert.are.same({}, shadows)
  end)

  it("opens a picker with timing on through the configured log", function()
    require("configs.telescope.log").setup()
    local log = require("telescope.log")
    assert.is_false(log.use_console)
    assert.is_false(log.timing.use_console)

    local conf = require("telescope.config").values
    local picker = require("telescope.pickers").new(
      { enable_timing = true, __name = "spec.export" },
      {
        prompt_title = "shadow spec",
        finder = require("telescope.finders").new_table({ results = { "a" } }),
        sorter = conf.generic_sorter({}),
      }
    )
    picker:find()
    vim.wait(100)
    assert.are.equal("spec.export", picker.__name)
    require("telescope.actions").close(picker.prompt_bufnr)
  end)
end)
