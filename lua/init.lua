-- dofile('/home/wil/.config/nvim/lua/profiler.lua')
-- require("debug.typescript")
-- local logger = require("logger");
require "plugins.bootstrap"
require "plugins.load"
require "plugins.configure"

-- logger.debug("Loaded plugins")

-- general settings
require "main.options"
-- require "main.colorscheme"

require "lsp.setup"
-- logger.debug("Loaded LSP")

require "mappings"
require "mappings.lsp"
require "mappings.dap"
require "mappings.pickers"
require "mappings.integrations"
require "mappings.unimpaired"
require "mappings.formatters"
require "mappings.movement"
require "mappings.ignored"
require "mappings.buffer"
require "mappings.window"
require "mappings.insert"
require "mappings.visual"
require "mappings.command"
-- logger.info(vim.inspect(packer_plugins))
-- logger.info(string.format("Finished at %s", os.date("%H:%M:%S")))

vim.g.qf_disable_statusline = true -- This should be the default
vim.g.Eunuch_find_executable = "fd" -- I use my fork of vim-eunuch
vim.g.Illuminate_ftblacklist = { ".*" } -- Only use lsp highlighting from the plugin
vim.g.netrw_banner = false
vim.g.Hexokinase_highlighters = { "backgroundfull" }
vim.g.Hexokinase_optInPatterns = { "full_hex", "triple_hex", "rgb", "rgba", "hsl", "hsla" }
vim.g.Hexokinase_refreshEvents = { "BufRead", "BufWrite" }
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_quickfix_mode = true
vim.g.vimtex_compiler_latexmk = {
  options = { "-pdf", "-shell-escape", "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
}
vim.g["test#strategy"] = "neovim"
vim.g.tex_flavor = "latex"
vim.g.indent_blankline_char = "│"
vim.g.indent_blankline_filetype = { "rust", "go", "lua", "json", "ruby" }
vim.g.indent_blankline_use_treesitter = true
vim.g.loaded_ruby_provider = false

require "main.autocommands"

if packer_plugins ~= nil then
  local count = 0
  for _ in pairs(packer_plugins) do count = count + 1 end
  -- logger.debug("Loaded plugins: " .. count)
end
