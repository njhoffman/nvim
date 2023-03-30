-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

require("globals")
require("utils.lazy").setup()

for _, mod_name in ipairs({
  "mappings",
  "mapper2.setup",
  "devbox",
  "commands",
  "autocommands",
  "project",
  "runner",
  "stats",
  "hover.setup",
}) do
  vim.import(mod_name)
end

require("sidebar").setup()
require("tracker").setup()

-- require("notifications.recipes.progress").config()
-- require "plenary.profile".stop()
