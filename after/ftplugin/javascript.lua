local u = require('utils.core')
--------------------------------------------------------------------------------

-- fix my habits
u.ftAbbr('cosnt', 'const')
u.ftAbbr('local', 'const')
u.ftAbbr('--', '//')

--------------------------------------------------------------------------------

-- Open regex in regex101
vim.keymap.set('n', '<localleader>X', function()
  require('funcs.quality-of-life').openAtRegex101()
end, { desc = ' Open next regex in regex101', buffer = true })
