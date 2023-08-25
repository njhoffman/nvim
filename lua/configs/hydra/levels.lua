local Hydra = require('hydra')
local utils = require('configs.hydra.utils')

local hints = function(type)
  local level_hints = '^   LSP '
    .. string.upper(type)
    .. '     ^'
    .. [[

   ──────────────^
    _0_ %{off} off
    _1_ %{error} error
    _2_ %{warn} warn
    _3_ %{info} info
    _4_ %{hint} hint
                _<Esc>_^
]]
  return level_hints
end

local exit = true
local heads = function(type)
  return {
    { '4', utils.update_diagnostic(type, 4), { desc = 'hint', exit = exit } },
    { '3', utils.update_diagnostic(type, 3), { desc = 'info', exit = exit } },
    { '2', utils.update_diagnostic(type, 2), { desc = 'warn', exit = exit } },
    { '1', utils.update_diagnostic(type, 1), { desc = 'error', exit = exit } },
    { '0', utils.update_diagnostic(type, 0), { desc = 'off', exit = exit } },
    { '<Esc>', nil, { exit = true } },
  }
end

local get_toggle = function(level, severity)
  local toggles = {
    yes = '  ',
    no = '  ',
  }
  return function()
    return level == severity and toggles.yes or toggles.no
  end
end

local funcs = function(type)
  local severity = utils.get_severity(type)
  return {
    off = get_toggle(0, severity),
    error = get_toggle(1, severity),
    warn = get_toggle(2, severity),
    info = get_toggle(3, severity),
    hint = get_toggle(4, severity),
  }
end

local hydra = function(type)
  return Hydra({
    name = 'Levels',
    hint = hints(type),
    heads = heads(type),
    config = {
      color = 'amaranth', -- amaranth, teal, pink, red, blue
      invoke_on_body = true,
      hint = {
        funcs = funcs(type),
        border = 'rounded',
        position = 'middle',
      },
    },
    mode = { 'n', 'x' },
  })
end

return { hydra = hydra }
