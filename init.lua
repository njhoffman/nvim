-- require('internals').init()

require("core.globals")

local _shell = vim.o.shell or "/bin/sh"
vim.cmd("set shell=" .. _shell)

vim.cmd("colorscheme nord-nick")

require("modules.components").init()

require("utils.lazy").setup({ cache = true, reload = false, lazy = false })

for _, mod_name in ipairs({
  "configs.project",
  "core.keymaps",
  "core.commands",
  "core.abbreviations",
  "core.autocommands",
  "modules.runner",
  "modules.stats",
  "modules.devdocs2.setup",
  "modules.tracker.setup",
  "modules.tmux.setup",
  "configs.registers",
  "configs.smoothcursor",
  "action-hints.setup",
  "early-retirement.setup",
  "modules.oldfiles",
  "modules.tail",
  "configs.mini-comment",
  (vim.g.statusline_backend or "feline") == "feline" and "configs.feline" or "configs.bars",
  "configs.definition-or-references",
  "modules.unicode",
  -- "baleia.setup",
  -- "demicolon.setup",
}) do
  vim.import(mod_name)
end

vim.defer_fn(function()
  vim.import("modules.alt").setup()
  vim.import("live-command.setup")
  vim.import("configs.satellite")
  vim.import("configs.convey")
  vim.import("configs.recall")

  vim.import("modules.sidebar").setup()
  vim.import("modules.format_cmdline").setup()

  vim.import("configs.smoothie").setup({
    implementation = "viml",
  })

  vim.import("configs.glyph-guard")

  if vim.g.started_by_firenvim then
    vim.api.nvim_set_keymap("n", "<C-z>", "<Cmd>call firenvim#hide_frame()<CR>", {})
    vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Cmd>call firenvim#focus_page()<CR>", {})

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = "github.com_*.txt",
      command = "set filetype=markdown",
    })
  end
  vim.keymap.set("x", "v", function()
    require("vim.treesitter._select").select_parent(vim.v.count1)
  end, { desc = "Expand treesitter selection" })
  vim.keymap.set("x", "V", function()
    require("vim.treesitter._select").select_child(vim.v.count1)
  end, { desc = "Shrink treesitter selection" })

  require("modules.components").setup()
end, 100)

-- http://www.google.com

-- require("notifications.recipes.progress").config()
