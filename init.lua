-- require('internals').init()

require("globals")

vim.import("configs.noice")
-- https://github.com/stevearc/quicker.nvim
vim.import("quickfix")

require("utils.lazy").setup({ cache = true, reload = false, lazy = false })

-- qfSeparator, qfLineNr, qfFilename

for _, mod_name in ipairs({
  "project",
  "keymaps",
  "commands",
  "abbreviations",
  "autocommands",
  "devbox",
  "runner",
  "stats",
  "devdocs.setup",
  -- 'configs.cinnamon',
  "tracker.setup",
  "tmux.setup",
  "configs.registers",
  "configs.smoothcursor",
  -- 'configs.nvim-scrollbar',
  -- 'configs.neoscroll',
  -- "action-hints.setup",
  -- 'winsep.setup',
  -- 'better_escape-setup',
  "early-retirement.setup",
  "oldfiles",
  "tail",
  "configs.mini-comment",
  "hover.setup",
  -- "NeoComposer._setup",
  "configs.feline",
  "configs.definition-or-references",
  "baleia.setup",
  -- "demicolon.setup",
}) do
  vim.import(mod_name)
end

vim.defer_fn(function()
  -- require("modeman")
  require("alt").setup()
  require("live-command.setup")
  require("sidebar").setup()
  require("histories").setup()
  -- require("synshade").setup()
  require("scrollview.setup")

  -- 'lab.setup',
  local llm_config = require("llm-config")
  require("llm").setup(llm_config)
  local neoai_cfg = require("neoai.options")
  require("neoai").setup(neoai_cfg)

  -- require('internals').setup()
  if vim.g.started_by_firenvim then
    vim.api.nvim_set_keymap("n", "<C-z>", "<Cmd>call firenvim#hide_frame()<CR>", {})
    vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Cmd>call firenvim#focus_page()<CR>", {})

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = "github.com_*.txt",
      command = "set filetype=markdown",
    })
  end
end, 100)

vim.defer_fn(function()
  vim.import("configs.telescope")
  require("configs.tiny-glimmer")
end, 500)
-- require("notifications.recipes.progress").config()
