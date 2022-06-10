vim.cmd [[
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors
try
  colorscheme nord-nick
  set background=dark
  hi Normal guibg=none ctermbg=none
  hi LineNr guibg=none ctermbg=none
  hi Folded guibg=none ctermbg=none
  hi NonText guibg=none ctermbg=none
  hi SpecialKey guibg=none ctermbg=none
  hi VertSplit guibg=none ctermbg=none
  hi SignColumn guibg=none ctermbg=none
  hi EndOfBuffer guibg=none ctermbg=none
  hi StatusLine guibg=NONE
  hi StatusLineNC guibg=NONE guifg=NONE
" syntax sync fromstart
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
]]

vim.g.start_time = vim.fn.reltime()

local home = os.getenv("HOME")
package.path = home .. "/.luarocks/share/lua/5.4/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.4/?.so;" .. package.cpath

-- Do not source the default filetype.vim
vim.cmd([[
  let g:did_load_filetypes = 1
  runtime! ftdetect/*.lua
  runtime! ftdetect/*.vim
]])

vim.g.indent_blankline_filetype_exclude = { "alpha", "NvimTree", "packer" }
vim.g.indent_blankline_buftype_exclude = { "terminal" }
vim.g.asyncrun_open = 6

vim.inspect = require('inspect')
vim.lsp.log_levels["INSPECT"] = 4
vim.lsp.log_levels["TASK"] = 4
vim.lsp.log_levels["STATUS"] = 4

vim.logger = require("logger").init("root")
vim.notify = require("logger").notify
vim.dbglog = require("debuglog").log
vim.dbgbuf = require("debuglog").buf
vim.dbg = require("debuglog").dbg
vim.dbg_test = function()
  vim.dbg(vim.api.nvim_get_all_options_info())
end

vim.notify_test = function()
  local str = "Error loading telescope plugin: telescope-find-pickers - .../start/telescope.nvim/"
  str = str .. "lua/telescope/_extensions/init.lua:10: 'telescope-find-pickers' extension doesn't "
  str = str ..
    "exist or isn't installed: module 'telescope._extensions.telescope-find-pickers' not found:"
  vim.notify(str, "error")
end

function _G.__FILE__() return debug.getinfo(2, 'S').source end

function _G.__LINE__() return debug.getinfo(2, 'l').currentline end

function _G.__FNC__() return debug.getinfo(2, 'n').name end

function _G.__FNCREF__() return debug.getinfo(2, 'f').func end

vim.notify(string.format("Initializing neovim at %s ... ", os.date("%H:%M:%S")), "trace")

-- vim.logger:trace("test")
-- vim.logger:info("info test")
-- vim.logger:error("error test")
-- vim.notify = require("notify")
