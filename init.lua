-- vim-profiler.py nvim -n 10
-- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("globals")

-- vim.import("lazy").setup({
--   { "folke/neoconf.nvim", cmd = "Neoconf" },
--   "folke/neodev.nvim",
-- })

for _, mod_name in ipairs({
  "plugins",
  "mappings",
  "lsp-globals",
  "lsp-capabilities",
  "lsp-config",
  "lsp-servers",
  "devbox",
  "commands",
  "autocommands",
  "project",
  "runner",
  "hover.setup",
  "stats",
  -- "codebox",
}) do
  vim.import(mod_name)
end

-- require "plenary.profile".stop()
