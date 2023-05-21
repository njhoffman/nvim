local commands = require('stats.commands')

-- Stats
--   stats:   print popup notify select
--   watch:   print popup notify
--   changes: print popup notify

vim.api.nvim_create_user_command('Stats', commands.fetch_stats, { desc = 'Internal stats output and monitoring' })
