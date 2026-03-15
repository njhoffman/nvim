-- require('internals').init()

require("globals")
local _shell = vim.o.shell or "/bin/sh"
vim.cmd("set shell=/bin/sh")

require("components").init()

require("utils.lazy").setup({ cache = true, reload = false, lazy = false })

for _, mod_name in ipairs({
  "project",
  "keymaps",
  "commands",
  "abbreviations",
  "autocommands",
  "devbox",
  "runner",
  "stats",
  "devdocs2.setup",
  "tracker.setup",
  "tmux.setup",
  "configs.registers",
  "configs.smoothcursor",
  "action-hints.setup",
  "early-retirement.setup",
  "oldfiles",
  "tail",
  "configs.mini-comment",
  "hover.setup",
  "configs.feline",
  "configs.definition-or-references",
  -- "baleia.setup",
  -- "demicolon.setup",
}) do
  vim.import(mod_name)
end

vim.defer_fn(function()
  vim.import("alt").setup()
  vim.import("live-command.setup")
  vim.import("configs.satellite")

  vim.import("sidebar").setup()
  vim.import("histories").setup()
  -- vim.import("scrollview.setup")

  vim.import("format_cmdline").setup()

  local llm_config = require("llm-config")
  vim.import("llm").setup(llm_config)

  vim.import("configs.recall")
  vim.import("configs.smoothie").setup()

  if vim.g.started_by_firenvim then
    vim.api.nvim_set_keymap("n", "<C-z>", "<Cmd>call firenvim#hide_frame()<CR>", {})
    vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Cmd>call firenvim#focus_page()<CR>", {})

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = "github.com_*.txt",
      command = "set filetype=markdown",
    })
  end

  require("components").setup()
end, 100)

-- require("notifications.recipes.progress").config()
