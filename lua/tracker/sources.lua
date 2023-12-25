local req_path = function(name)
  return require('tracker.sources.' .. name)
end

-- stylua: ignore
local sources = {
  -- events        = require('tracker.sources.events'),
  augroups         = req_path('au_groups'),
  aucmds           = req_path('au_commands')(),
  aucmds_global    = req_path('au_commands')('g'),
  aucmds_buffer    = req_path('au_commands')('b'),
  keys_all         = req_path('keys')(),
  keys_global      = req_path('keys')('g'),
  keys_buffer      = req_path('keys')('b'),
  opts_all         = req_path('options')(),
  opts_global      = req_path('options')('g'),
  opts_buffer      = req_path('options')('b'),
  opts_window      = req_path('options')('w'),
  vars_all         = req_path('variables')(),
  vars_global      = req_path('variables')('g'),
  vars_buffer      = req_path('variables')('b'),
  vars_predef      = req_path('variables')('v'),
  vars_window      = req_path('variables')('w'),
  vars_script      = req_path('variables')('s'),
  vars_terminal    = req_path('variables')('t'),
  vars_language    = req_path('variables')('l'),
  highlights       = req_path('highlights'),
  code_target      = req_path('code_target'),
  -- functions, commands, ext_leaked, timers, packages, scriptnames
}
return sources
