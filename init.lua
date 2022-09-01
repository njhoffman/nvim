-- vim-profiler.py nvim -n 10
-- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

require("globals")
for _, mod_name in ipairs({
  "project",
  "runner",
  "mappings",
  "plugins",
  "lsp",
  "commands",
  "autocommands",
  "stats",
  "codebox",
  -- "dashboard"
}) do
  vim.import(mod_name)
end

vim.cmd([[ BarbarColors ]])

-- require "plenary.profile".stop()
