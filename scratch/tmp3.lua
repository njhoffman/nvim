local type = 'underline'

local unds = 'unused'

local level_hints = '^ ^ LSP '
  .. string.upper(type)
  .. '     ^'
  .. [[
    ^
    _0_ %{trace} trace
    _1_ %{debug} debug
    _2_ %{info} info
    _3_ %{warn} warn
    _4_ %{error} error
    _5_ %{off} off
    ^
    ^^^^            _<Esc>_
]]

sd
vim.dbglog(level_hints)
