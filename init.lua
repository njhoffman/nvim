-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

require("globals")
require("utils.lazy").setup({ cache = false, reload = false })

for _, mod_name in ipairs({
  "mapper.setup",
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

vim.cmd([[ nnoremap ; : ]])

-- require("notifications.recipes.progress").config()
-- require "plenary.profile".stop()
