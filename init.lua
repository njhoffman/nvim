-- vim-profiler.py nvim -n 10
-- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

require("globals")
for _, mod_name in ipairs(
  {
    "impatient",
    "user-options",
    "vim-options",
    "mappings",
    "plugins.load",
    "project",
    "buffers",
    "lsp",
    "stats.list",
    "commands",
    "autocommands",
    "dashboard"
  }
) do
  vim.import(mod_name)
end

vim.cmd [[
  BarbarColors
]]


-- require "plenary.profile".stop()
