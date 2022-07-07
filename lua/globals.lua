vim.g.start_time = vim.fn.reltime()

vim.cmd [[
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  set termguicolors
  try
    colorscheme nord-nick
    set background=dark
  " hi Normal guibg=none ctermbg=none
  " hi LineNr guibg=none ctermbg=none
  " hi Folded guibg=none ctermbg=none
  " hi NonText guibg=none ctermbg=none
  " hi SpecialKey guibg=none ctermbg=none
  " hi VertSplit guibg=none ctermbg=none
  " hi SignColumn guibg=none ctermbg=none
  " hi EndOfBuffer guibg=none ctermbg=none
  " hi StatusLine guibg=NONE
  " hi StatusLineNC guibg=NONE guifg=NONE
    syntax sync fromstart
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
]]

local home = os.getenv("HOME")
package.path = home .. "/.luarocks/share/lua/5.4/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.4/?.so;" .. package.cpath

vim.g.indent_blankline_filetype_exclude = { "alpha", "NvimTree", "packer" }
vim.g.indent_blankline_buftype_exclude = { "terminal" }
vim.g.asyncrun_open = 6

vim.lsp.log_levels["INSPECT"] = 4
vim.lsp.log_levels["TASK"] = 4
vim.lsp.log_levels["STATUS"] = 4

vim.inspect = require('inspect')
vim.logger = require("logger").init("root")
vim.notify = require("logger").notify
vim.dbglog = require("debuglog").log
vim.dbgbuf = require("debuglog").buf
vim.dbg = require("debuglog").dbg
vim.import = require('importer').import

vim.notify(string.format("Initializing neovim at %s ... ", os.date("%H:%M:%S")), "trace")

local disabled_built_ins = {
  -- "netrw",
  -- "netrwPlugin",
  -- "netrwSettings",
  -- "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit"
}

vim.tbl_map(
  function(plugin) vim.g["loaded_" .. plugin] = 1 end,
  disabled_built_ins
)

function _G.__FILE__() return debug.getinfo(2, 'S').source end

function _G.__LINE__() return debug.getinfo(2, 'l').currentline end

function _G.__FNC__() return debug.getinfo(2, 'n').name end

function _G.__FNCREF__() return debug.getinfo(2, 'f').func end
