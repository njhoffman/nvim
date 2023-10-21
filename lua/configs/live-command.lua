-- https://raw.githubusercontent.com/smjonas/live-command.nvim/main/README.md

local commands = {
  Norm = { cmd = 'norm' },
  G = { cmd = 'g' },
  D = { cmd = 'd' },
  Reg = {
    cmd = 'norm',
    args = function(opts)
      return (opts.count == -1 and '' or opts.count) .. '@' .. opts.args
    end,
    range = '',
  },
  LSubvert = { cmd = 'Subvert' },
}

require('live-command').setup({
  commands = commands,
  defaults = {
    enable_highlighting = true,
    inline_highlighting = true,
    hl_groups = {
      insertion = 'DiffAdd',
      deletion = 'DiffDelete',
      change = 'DiffChange',
    },
  },
  debug = false,
})
