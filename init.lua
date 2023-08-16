-- strace gvim -V9log.txt file.tex > stdout.txt 2> stderr.txt

-- require('preload')
require('globals')
require('utils.lazy').setup({ cache = false, reload = false, lazy = false })

for _, mod_name in ipairs({
  'keymaps',
  'project',
  'dial',
  'wf-setup',
  'devbox',
  'commands',
  'autocommands',
  'runner',
  'stats',
  'hover.setup',
  'lsp.illuminate',
  'plugs.config.feline',
}) do
  vim.import(mod_name)
end

-- vim.fn.input()

require('sidebar').setup()
require('tracker').setup({ event_tracker = false, only_events = { 'User' } })

-- require("notifications.recipes.progress").config()
-- require "plenary.profile".stop()
