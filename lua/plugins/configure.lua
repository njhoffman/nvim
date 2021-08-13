local config = require "config"
local M = {}

if config.DAP.enabled ~= 0 and config.DAP.enabled ~= false then
  require("plugins.lua.dapui")
  require("plugins.lua.nvim-dap")
end

-- basic key mappings
-- vim-surround and unimpaired separately loaded
require("plugins.lua.surround")

-- project management
require("plugins.lua.auto-session")
require("plugins.lua.session-lens")
require("plugins.vim.prosession")
require("plugins.vim.vim-rooter")

-- treesitter & syntax
require("plugins.lua.treesitter")
require("plugins.vim.syntax")

-- pickers
require("plugins.vim.fzf")
require("plugins.vim.fzf_preview")
require("plugins.lua.fzf-lua")
require("plugins.lua.jabs")
require("plugins.lua.telescope")
require("plugins.lua.nvim_web_devicons")

-- syntax
require("plugins.vim.pandoc")
-- Don't highlight builtin functions/filters (default: 1)
vim.g.jq_highlight_builtin_functions = 0

-- Don't highlight module prefix, like NAME:: (default: 1)
vim.g.jq_highlight_module_prefix = 0

-- Don't highlight imported JSON file prefix, like $NAME:: (default: 1)
vim.g.jq_highlight_json_file_prefix = 0

-- Highlight objects like .foo (default: 0)
vim.g.jq_highlight_objects = 1

-- Highlight all function calls (default: 0)
-- This will highlight all words directly followed by an opening parenthesis
vim.g.jq_highlight_function_calls = 1

vim.g.vim_jsx_pretty_highlight_close_tag = 1
vim.g.vim_jsx_pretty_colorful_config = 1
vim.g.vim_jsx_pretty_disable_tsx = 0
vim.g.vim_jsx_pretty_disable_jsx = 0

-- Plug 'sheerun/vim-polyglot', { 'do': 'rm ~/.vim/plugged/vim-polyglot/after/indent/javascript.vim' }
-- plasticboy/vim-markdown fenced syntax blocks
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_fenced_languages = {
  "coffee",
  "css",
  "erb=eruby",
  "javascript",
  "js=javascript",
  "json=javascript",
  "python",
  "css",
  "sh",
  "bash=sh",
  "html",
  "zsh",
  "ruby",
  "sass",
  "xml",
}

vim.g.vim_markdown_no_extensions_in_markdown = 1

-- formatting
require("plugins.lua.iswap")
require("plugins.lua.todo_comments")
require("plugins.lua.kommentary")
require("plugins.vim.easyalign")
require("plugins.vim.splitjoin")
require("plugins.vim.vim_multiple_cursors")

-- integrations
require("plugins.lua.gitsigns")
-- require("plugins.lua.neogit")
require("plugins.lua.neuron")
require("plugins.vim.neuron-v2")
require("plugins.lua.octo")
require("plugins.lua.package-info")
require("plugins.vim.vimux")
require("plugins.vim.asynctasks")
require("plugins.vim.vim-ripple")
require("plugins.vim.registers")
require("plugins.vim.markdown-preview")

-- interfaces
require("plugins.lua.nvim_bqf")
require("plugins.lua.dashboard-nvim")
require("plugins.lua.trouble")
require("plugins.lua.nvim_tree")
require("plugins.lua.nvim_toggleterm")
require("plugins.lua.nvim_hlslens")
require("plugins.lua.diffview")
require("plugins.lua.which_key")
require("plugins.lua.nvim_mapper")
require("plugins.lua.snap")
require("plugins.vim.vim_yoink")
require("plugins.vim.vim_mundo")
require("plugins.vim.vim-floaterm")
require("plugins.vim.float-preview")
require("plugins.vim.vista")
-- require("plugins.vim.scratch")

-- motion
require("plugins.vim.vim_smoothie")
require("plugins.vim.vim_wordmotion")
require("plugins.vim.vim_matchup")
-- require("plugins.lua.anywise-reg")

-- visual
require("plugins.vim.vim_hexokinase")
require("plugins.vim.vimade")
require("plugins.vim.scrollbar")
require("plugins.lua.truezen")
require("plugins.vim.vim_plugin_AnsiEsc")
require("plugins.vim.wilder")
require("plugins.lua.twilight")
require("plugins.lua.nvim-notify")
-- require("plugins.vim.indent-line")

-- utils
require("plugins.lua.nvim_reload")
require("plugins.lua.nvim_startup")

-- themes
require("plugins.lua.feline");
-- require("plugins.lua.barbar")
