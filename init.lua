-- vim-profiler.py nvim -n 10
-- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

require("globals")

for _, mod_name in ipairs({
  "project",
  "runner",
  "devbox",
  -- "codebox",
  "mappings",
  "plugins",
  "lsp-globals",
  "lsp-capabilities",
  "lsp-config",
  "lsp-servers",
  "commands",
  "autocommands",
  "stats",
  "hover.setup",
  -- "dashboard"
}) do
  vim.import(mod_name)
end

vim.cmd([[ BarbarColors ]])

-- require "plenary.profile".stop()
