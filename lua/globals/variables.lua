local home = vim.fn.expand("$HOME")
package.path = package.path .. ";" .. home .. "/.luarocks/share/lua/5.4/?.lua"
package.path = package.path .. ";" .. home .. "/.luarocks/share/lua/5.4/?/init.lua"
package.cpath = package.cpath .. ";" .. home .. "/.luarocks/lib/lua/5.4/?.so"

-- TODO: send copy to both registers and tmux buffer
local function copy(lines, _)
  require("osc52").copy(table.concat(lines, "\n"))
end

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.start_time = vim.fn.reltime()
-- let g:clipboard = {
--    'name': 'myClipboard',
--    'copy': {
--       '+': ['tmux', 'load-buffer', '-'],
--       ["+"] = "xclip -f -sel clip",
--       '*': ['tmux', 'load-buffer', '-'],
--      ['+'] = require('vim.clipboard.osc52').copy,
--     },
--    'paste': {
--       '+': ['tmux', 'save-buffer', '-'],
--       '*': ['tmux', 'save-buffer', '-'],
--         ["*"] = "xclip -o -sel clip",
--         ['*'] = require('vim.clipboard.osc52').paste,
--    },
--    'cache_enabled': 1,
--  }
vim.g.clipboard = {
  name = "xsel",
  copy = {
    ["+"] = { "xsel", "--nodetach", "-i", "-b" },
    ["*"] = { "xsel", "--nodetach", "-i", "-p" },
  },
  paste = {
    ["+"] = { "xsel", "-o", "-b" },
    ["*"] = { "xsel", "-o", "-p" },
  },
  cache_enabled = 1,
}
vim.g.qf_disable_statusline = true -- This should be the default
vim.g.Eunuch_find_executable = "fd" -- I use my fork of vim-eunuch
vim.g.Illuminate_ftblacklist = { ".*" } -- Only use lsp highlighting from the plugin

vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_quickfix_mode = true
vim.g.vimtex_compiler_latexmk = {
  options = {
    "-pdf",
    "-shell-escape",
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}
vim.g["test#strategy"] = "neovim"
vim.g.tex_flavor = "latex"
vim.g.indent_blankline_char = "│"
vim.g.indent_blankline_filetype = { "rust", "go", "lua", "json", "ruby" }
vim.g.indent_blankline_use_treesitter = true
vim.g.loaded_ruby_provider = true

-- Allows users to specify the type of embedded script highlighting they want:  (perl/python/ruby/tcl support)
vim.g.vimsyn_embed = "--lmpPr"

-- bats
-- Whether or not to add dollar sign to iskeyword.
vim.g.bats_vim_consider_dollar_as_part_of_word = 1

-- pgsql default for sql files
vim.g.sql_type_default = "pgsql"

vim.g.asyncrun_open = 6
-- Disable menu loading
vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1

vim.g.netrw_banner = false
vim.g.netrw_silent = 1
-- newtrw liststyle: https://medium.com/usevim/the-netrw-style-options-3ebe91d42456
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_http_cmd = 'curl'
-- vim.g.netrw_http_xcmd = '-o'
-- fixes unlisted buffer error: https://github.com/romgrk/barbar.nvim/issues/82#issuecomment-748498951
-- vim.g.netrw_bufsettings = 'noma nomod nonu nowrap ro buflisted'

-- https://raw.githubusercontent.com/romgrk/barbar.nvim/master/README.md
local disabled_built_ins = {
  -- 'netrw',
  -- 'netrwPlugin',
  -- 'netrwSettings',
  -- 'netrwFileHandlers',
  "matchit",
  "matchparen",
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logiPat",
  -- 'remote_plugins',
  "rrhelper",
  -- "spellfile_plugin",
  -- "sql_completion",
  -- "syntax_completion",
  "tar",
  "tarPlugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

vim.tbl_map(function(plugin)
  vim.g["loaded_" .. plugin] = 1
end, disabled_built_ins)

vim.cmd([[
  let g:spellfile_URL = 'https://ftp.nluug.nl/vim/runtime/spell'
  " autocmd SpellFileMissing * call spellfile#LoadFile(expand('<amatch>'))
	" au SpellFileMissing * call Spellfile(expand('<amatch>'))
  " au! SpellFileMissing * call Download_spell_file(expand('<amatch>'))
]])

_G.__FILE__ = function()
  return debug.getinfo(2, "S").source
end
_G.__LINE__ = function()
  return debug.getinfo(2, "l").currentline
end
_G.__FNC__ = function()
  return debug.getinfo(2, "n").name
end
_G.__FNCREF__ = function()
  return debug.getinfo(2, "f").func
end
