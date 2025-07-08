-- use bash parser for zsh files
-- vim.treesitter.language.register("bash", "zsh")

local tsmodules = require("configs.nvim-treesitter.modules")

local ts = require("nvim-treesitter")

ts.define_modules(tsmodules)
local cfg = {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  auto_install = true,
  ensure_installed = "all",
  -- ignore_install = { 'comment' },
  indent = tsmodules.indent,
  playground = tsmodules.playground,
  highlight = tsmodules.highlight,
  refactor = tsmodules.refactor,
  autotag = tsmodules.autotag,
  rainbow = tsmodules.rainbow,
  -- matchup = tsmodules.matchup,
  pairs = tsmodules.pairs,
  textobjects = tsmodules.textobjects,
  textsubjects = tsmodules.textsubjects,
  incremental_selection = tsmodules.incremental_custom,
  endwise = tsmodules.endwise,
}

-- -- vim.treesitter.language.register("lua", { "log" })

-- for matcher module
vim.cmd("packadd matchit")
require("nvim-treesitter.configs").setup(cfg)
require("nvim-treesitter.install").prefer_git = true
require("configs.nvim-treesitter.context")
require("configs.nvim-treesitter.custom")
