local providers = require('histories.providers')

-- stylua: ignore
local config = {
  keys = {
    global = {
      -- ['g;']    = providers['changes'].start,
      -- ['gv']    = providers['selects'].start,
      -- ['<M-o>'] = providers['jumps'].start,
    },
    static = {
      cancel        = '<Esc>',
      toggle_ui     = '<M-/>',
      prev          = ':',
      next          = ';',
    },
    active = {
      close         = '<Esc>',
      up            = '<C-p>',
      down          = '<C-n>',
    },
  },
}

return config
