-- vim-profiler.py nvim -n 10
-- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

require("globals")

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
  -- "codebox",
  "stats",
  -- "dashboard"
}) do
  vim.import(mod_name)
end

-- require "plenary.profile".stop()
