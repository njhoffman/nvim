-- https://raw.githubusercontent.com/smjonas/live-command.nvim/main/README.md

local commands = {
  Norm = { cmd = 'norm', hl_range = { kind = 'visible' } },
  G = { cmd = 'g', hl_range = { 1, -1, kind = 'absolute' } },
  D = { cmd = 'd', hl_range = { 1, -1, kind = 'absolute' } },
  Reg = {
    cmd = 'norm',
    args = function(opts)
      return (opts.count == -1 and '' or opts.count) .. '@' .. opts.args
    end,
    range = '',
  },
  LSubvert = { cmd = 'Subvert' },
  S = { cmd = 'Substitute', hl_range = { kind = 'visible' } },
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
