-- vim-profiler.py nvim -n 10
-- vim-profiler.py -n 5 nvim foo.cc -c ":exec ':normal ia' | :q\!"
-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

require("globals")
require("lazy-utils").init()

for _, mod_name in ipairs({
  "mappings",
  "devbox",
  "commands",
  "autocommands",
  "project",
  "runner",
  "stats",
  --   "hover.setup",
  --   "codebox",
}) do
  vim.import(mod_name)
end

-- require("notifications.recipes.progress").config()
-- require "plenary.profile".stop()
