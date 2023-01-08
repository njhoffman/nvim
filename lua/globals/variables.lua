local home = os.getenv("HOME")
package.path = home .. "/.luarocks/share/lua/5.4/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.4/?.so;" .. package.cpath

vim.g.start_time = vim.fn.reltime()

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
vim.g.netrw_banner = false
vim.g.netrw_silent = 1
-- vim.g.netrw_http_cmd = 'curl'
-- vim.g.netrw_http_xcmd = '-o'

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

-- fixes unlisted buffer error
-- https://github.com/romgrk/barbar.nvim/issues/82#issuecomment-748498951
vim.g.netrw_bufsettings = "noma nomod nonu nowrap ro buflisted"

-- Allows users to specify the type of embedded script highlighting they want:  (perl/python/ruby/tcl support)
vim.g.vimsyn_embed = "--lmpPr"

-- bats
-- Whether or not to add dollar sign to iskeyword.
vim.g.bats_vim_consider_dollar_as_part_of_word = 1

-- pgsql default for sql files
vim.g.sql_type_default = "pgsql"

vim.g.indent_blankline_filetype_exclude = { "alpha", "NvimTree", "packer" }
vim.g.indent_blankline_buftype_exclude = { "terminal" }
vim.g.asyncrun_open = 6

vim.g.markdown_fenced_languages = {
  "awk",
  "bash=sh",
  "c",
  "cpp",
  "css",
  "go",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "python",
  "ruby",
  "rust",
  "sh",
  "shell=sh",
  "sql",
  "terraform",
  "ts=typescript",
  "vim=vimwiki",
  "xml",
  "yaml",
  "yaml",
  "zsh",
}

vim.lsp.log_levels["INSPECT"] = 4
vim.lsp.log_levels["TASK"] = 4
vim.lsp.log_levels["STATUS"] = 4

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
  "matchit",
}

vim.tbl_map(function(plugin)
  vim.g["loaded_" .. plugin] = 1
end, disabled_built_ins)

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
