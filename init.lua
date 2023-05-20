-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

require('globals')

require('utils.lazy').setup({ cache = false, reload = false })

for _, mod_name in ipairs({
  'plugs.config.feline',
  'mapper.setup',
  'project',
  'dial',
  'wf-setup',
  'devbox',
  'commands',
  'autocommands',
  'lsp.illuminate',
  'runner',
  'stats',
  'hover.setup',
}) do
  vim.import(mod_name)
end

-- vim.fn.input()

require('sidebar').setup()
require('tracker').setup()

vim.cmd([[ nnoremap ; : ]])
vim.cmd([[ vnoremap ; : ]])

-- require("notifications.recipes.progress").config()
-- require "plenary.profile".stop()
